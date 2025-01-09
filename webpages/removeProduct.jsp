<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>

<html>
<head>
    <title>Remove Product</title>
</head>
<body>
<%

try {
    // Check the authentication process
    if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
        session.setAttribute("currentPage", null);
        session.setAttribute("userName", null);
        response.sendRedirect("loginHashing.html");
    } else {
        String currentPage = "removeProduct.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();

		//Create the appDBMAuth object
		applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
		System.out.println("Connecting...");
		System.out.println(appDBAuth.toString());

		//Create the appDBMnger object
		applicationDBManager appDBMnger= new applicationDBManager();
		System.out.println("Connecting...");
		System.out.println(appDBAuth.toString());

		//Call the verifyUser method to check if the user is an admin
		ResultSet resUser = appDBAuth.verifyUser(userName, currentPage, previousPage);

		//Verify if the user has been authenticated
		if (resUser.next()){

			String sessionName=resUser.getString(3);
						
			//Create the current page attribute
			session.setAttribute("currentPage", currentPage);
						
			//Create a session variable
			if (session.getAttribute("userName")==null){

				//create the session variable
				session.setAttribute("userName", userName);

			}else{
				//Update the session variable
				session.setAttribute("userName", userName);
			}

            ResultSet resProd = appDBMnger.listAllProduct(); 
            %>
            <!-- Product Table -->
            <table border="1">
                <tr>
                    <td>Product ID</td>
                    <td>Product Name</td>
                    <td>Product Description</td>
                    <td>Product Department</td>
                    <td>Product Bid</td>
                    <td>Product Due Date</td>
                    <td>Product Seller</td>
                </tr>
            <%
            while (resProd.next()) { 
                %>
                <tr>
                    <td><%= resProd.getString(1) %></td>
                    <td><%= resProd.getString(2) %></td>
                    <td><%= resProd.getString(3) %></td>
                    <td><%= resProd.getString(4) %></td>
                    <td><%= resProd.getString(5) %></td>
                    <td><%= resProd.getString(6) %></td>
                    <td><%= resProd.getString(7) %></td>
                </tr>
                <%
            } 
            %>
            </table>
            <form id="form_1" action="deleteProduct.jsp" method="post">
		    <table border="0">
			<tr>
				<td> Product ID </td>
				<td><input type="text" id="productID"  name="productID" /></td>
			</tr>
		    </table>
                <input type="submit" id="Submit" value="submit" />
                <input type="reset" id="Submit" value="reset" />
	        </form>

            <form action="welcomeMenu.jsp" method="GET">
                <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
            </form>
            <%
        }else{
            //Close any session associated with the user
			session.setAttribute("userName", null);

			//return to the login page
			response.sendRedirect("loginHashing.html");
        }

        //Close connection to database
        appDBAuth.close();
        appDBMnger.close();
    }
}catch (Exception e) {
    e.printStackTrace();
    // Handle exceptions here
}finally{
    System.out.println("Finally");
}
%>sessionName=<%= session.getAttribute("userName")%>
</body>
</html>
