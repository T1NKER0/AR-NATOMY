<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>

<html>
    <head>
        <title>New Bid Processed</title>
    </head>
    <body>

    <%
    try{
        // Check the authentication process
        if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null){
            session.setAttribute("currentPage", null);
            session.setAttribute("userName", null);
            response.sendRedirect("loginHashing.html");
        } else {
            String currentPage = "bidProcessed.jsp";
            String userName = session.getAttribute("userName").toString();
            String previousPage = session.getAttribute("currentPage").toString();

            // Create the applicationDBManager object
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            System.out.println("Connecting...");
            System.out.println(appDBAuth.toString());

            // Create the AppDBMnger object
            applicationDBManager appDBMnger = new applicationDBManager();
            System.out.println("Connecting...");
            System.out.println(appDBMnger.toString());

            // Call the verifyUser method to authenticate the user
            ResultSet resUser = appDBAuth.verifyUser(userName, currentPage, previousPage);

            // Verify if the user has been authenticated
            if (resUser.next()) {
                String userActualName = resUser.getString(3);

                // Create the current page attribute
                session.setAttribute("currentPage", currentPage);

                // Get the productID to update the currentBid from the previous page
                String productId = request.getParameter("productId");

                String newBid = request.getParameter("newBid");

                // Update the bid for the product
                boolean updateBid = appDBMnger.modifyBid(productId, newBid);

                if (updateBid) {
                    // Call the bidProduct method to add the bid
                    boolean bidAdded = appDBMnger.bidProduct(newBid, userName, productId);

                    if (bidAdded) {
                        %>
                        <p>Bid successfully added for product listing </p>
                        <form action="welcomeMenu.jsp" method="Post">
                            <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                        </form>

                        <form action="displayItem.jsp" method="GET">
                            <input type="hidden" name="productId" value="<%= request.getParameter("productId") %>">
                            <input type="hidden" name="productName" value="<%= request.getParameter("productName") %>">
                            <input type="hidden" name="dept_name" value="<%= request.getParameter("dept_name") %>">
                            <!-- Other form elements for displayItem.jsp -->
                            <button type="submit">Back to Item</button>
                        </form>
                        <%
                    } else {
                        %>
                        <p>Bid could not be added</p>
                        <%
                    }
                } else {
                    %>
                    <p>Bid could not be updated</p>
                    <%
                }
            } else {
                // Close any session associated with the user
                session.setAttribute("userName", null);

                // Return to the login page
                response.sendRedirect("loginHashing.html");
            }

            // Close connection to the database
            appDBAuth.close();
            appDBMnger.close();
        } 
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        System.out.println("Finally");
    }
    %>
    </body>
</html>
