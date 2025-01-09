<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>

<html>
<head>
    <title>Update Bid</title>
</head>
<body>
<%
try {
    if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
        session.setAttribute("currentPage", null);
        session.setAttribute("userName", null);
        response.sendRedirect("loginHashing.html");
    }else{
        String currentPage = "updateBid.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();

        String productId = request.getParameter("productId");

        //Create AppDBAuth object
        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
        System.out.println("Connecting...");
        System.out.println(appDBAuth.toString());

        //Create AppDBMnger object
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

            // Create a session variable
            if (session.getAttribute("userName") == null) {
                // Create the session variable
                session.setAttribute("userName", userName);
            } else {
                // Update the session variable
                session.setAttribute("userName", userName);
            }

            // Retrieve the details of the product based on the productId
            ResultSet res = appDBMnger.getProductId(productId);
            if(res.next()){

                // Display the details of the product
                %>
                <form action="displayItem.jsp" method="GET">
                    <input type="hidden" name="productId" value="<%= request.getParameter("productId") %>">
                    <input type="hidden" name="productName" value="<%= request.getParameter("productName") %>">
                    <input type="hidden" name="dept_name" value="<%= request.getParameter("dept_name") %>">
                    <!-- Other form elements for displayItem.jsp -->
                    <button type="submit">Back to Item</button>
                </form>

                <form action="welcomeMenu.jsp" method="GET">
                    <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                </form>

                <h2>Product details</h2>
                <!-- Display ID, name, description, and the current bid -->
                <p>Product ID: <%=res.getString(1)%></p>
                <p>Name: <%=res.getString(2)%></p>
                <p>Description: <%=res.getString(3)%></p>
                <p>Department: <%=res.getString(4)%></p>
                <p>Current Bid: $ <%=res.getString(5)%></p>
                <p>Due Date: <%=res.getString(6)%></p>
                <p>Seller: <%=res.getString(7)%></p>
                <img src="/cpen410/imagesjson/<%=res.getString(8)%>" alt ="<%=res.getString(2) %>" style ="width: 400px; height: auto;">
    
                <form action="bidProcessed.jsp" method="POST">
                    <input type="hidden" name="productId" value="<%= productId %>">
                    <input type="hidden" name="productName" value="<%= request.getParameter("productName") %>">
                    <input type="hidden" name="dept_name" value="<%= request.getParameter("dept_name") %>">
                    <label for="newBid">New Bid: $</label>
                    <input type="number" id="newBid" name="newBid" min= "<%= Double.parseDouble(res.getString(5)) + 0.01 %>" step="0.01" required>
                    <input type="submit" value="Update Bid">
                </form>
                <%
            }else{

                // if no product found with the given productId
                %>
                <p>No product with ID: <%= productId %></p>
                <%
            }
        }else{
            //Close any session associated with the user
		    session.setAttribute("userName", null);

            //return to the login page
		    response.sendRedirect("loginHashing.html");
        }
        // Close the ResultSet and the connection to the database
        appDBAuth.close();
        appDBMnger.close(); 
    }
}catch(Exception e) {
    // if an exception occurs, print the stack trace
    e.printStackTrace();
    response.sendRedirect("loginHashing.html");
}finally{
    System.out.println("Finallly");
}
%>
</body>
</html>