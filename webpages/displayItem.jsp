<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <title>Display Item</title>
</head>
<body>
<%
try {

    //Authenticate if the user is logged in, if not redirect the user to login hashing
    if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
    	session.setAttribute("currentPage", null);
    	session.setAttribute("userName", null);
   	 	response.sendRedirect("loginHashing.html");
	}else{
        String productId = request.getParameter("productId");

        String currentPage = "displayItem.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();


        //Create AppDBAuth object
        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
        System.out.println("Connecting...");
        System.out.println(appDBAuth.toString());

        //Create AppDBMnger object
        applicationDBManager appDBMnger = new applicationDBManager();
        System.out.println("Connecting...");
        System.out.println(appDBMnger.toString());


        //Call the verifyUser method to authenticate the user
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

            //Retrieve the details of the product based on the productId
            ResultSet res = appDBMnger.getProductId(productId);

            if (res.next()) {
                // Display the details of the product
                %>

                <form action="searchProduct.jsp" method="GET">
                    <input type="hidden" name="productId" value="<%= request.getParameter("productId") %>">
                    <input type="hidden" name="productName" value="<%= request.getParameter("productName") %>">
                    <input type="hidden" name="dept_name" value="<%= request.getParameter("dept_name") %>">
                    <button type="submit" name="searchProduct" value="searchProduct">Back to product list</button>
                </form> <br> <br> 

                <form action="welcomeMenu.jsp" method="GET">
                    <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                </form> <br> <br>

                <h2>Product Details</h2>
                <!-- Display the ID, Description, and a bigger image -->
                <p>Product ID: <%= res.getString(1) %></p>
                <p>Name: <%= res.getString(2) %></p>
                <p>Description: <%= res.getString(3) %></p>
                <p>Department: <%= res.getString(4) %></p>
                <p>BID $<%= res.getString(5) %></p>
                <p>Due Date: <%= res.getString(6) %></p>
                <p>Seller: <%=res.getString(7)%></p>
                <img src="/cpen410/imagesjson/<%= res.getString(8) %>" alt="<%= res.getString(2) %>" style="width: 400px; height: auto;">
                <form action="updateBid.jsp" method="POST">
                    <input type="hidden" name="productId" value="<%= request.getParameter("productId") %>">
                    <input type="hidden" name="productName" value="<%= request.getParameter("productName") %>">
                    <input type="hidden" name="dept_name" value="<%= request.getParameter("dept_name") %>">
                    <!-- Other form elements for updateBid.jsp -->
                    <button type="submit">Place Bid</button>
                </form>
                <%
            }else{
                // If no product found with the given productId
                %>
                <p>No product found with ID: <%= productId %></p>
                <%
            }
        }else{
            //Close any session associated with the user
		    session.setAttribute("userName", null);

            //return to the login page
		    response.sendRedirect("loginHashing.html");
        }

        // Close the connection to the database
        appDBAuth.close();
        appDBMnger.close();
    } 
}catch(Exception e) {
    //If an exception occurs, print the stack trace
    e.printStackTrace();
    response.sendRedirect("loginHashing.html");
}finally{
    System.out.println("Finallly");
}
%>
</body>
</html>
