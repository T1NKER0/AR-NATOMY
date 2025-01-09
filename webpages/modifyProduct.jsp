<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>

<html>
<head>
    <title>Modify Product</title>
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

        String currentPage = "modifyProduct.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();

        //Create the appDBAuth object
        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
        System.out.println("Connecting...");
        System.out.println(appDBAuth.toString());

        //Create the appDBMnger object
        applicationDBManager appDBMnger = new applicationDBManager();
        System.out.println("Connecting...");
        System.out.println(appDBMnger.toString());

        // Call the verifyAdmin method to check if the user is an admin
        ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);
        %>
        <% 
      	//Verify if the user has been authenticated
		if (res.next()){
			String userActualName=res.getString(3);
					
			//Create the current page attribute
			session.setAttribute("currentPage", currentPage);
					
			//Create a session variable
			if (session.getAttribute("userName")==null ){
				//create the session variable
				session.setAttribute("userName", userName);
			}else{
				//Update the session variable
				session.setAttribute("userName", userName);
			}

            // Retrieve the list of all products
            ResultSet resProduct = appDBMnger.listAllProduct();
            %>
            <!-- Product Modification Form -->
            <form action="updateProduct.jsp" method="POST">
                <table border="0">
                <tr>
                    <td> Select Product to Modify </td>
                    <td>
                    <select id="productIdModify" name="productIdModify" style="width: 200px; font-size: 14px;">
                        <option value="Select Product">Select Product</option>
                        <%
                        while (resProduct.next()) {
                            %><option value="<%= resProduct.getString(1) %>"><%= resProduct.getString(1) %></option><%
                        }
                        %>
                    </select>
                    </td>
                </tr>
                <tr>
                    <td> New Product Name </td>
                    <td><input type="text" id="newProductName" name="newProductName" required/></td>
                </tr>
                <tr>
                    <td> New Description </td>
                    <td><input type="text" id="newDescription" name="newDescription" required/></td>
                </tr>
                <tr>
                    <td> New Department Name </td>
                    <td><input type="text" id="newDeptName" name="newDeptName" required/></td>
                </tr>
                <tr>
                <tr>
                    <td> New Due Date </td>
                    <td><input type="text" id="newDueDate" name="newDueDate" required/></td>
                </tr>
                <tr>
                    <td> New Image </td>
                    <td><input type="file" id="newImage" name="newImage" /></td>
                </tr>
                </table>
                    <input type="submit" id="Submit" value="Submit" />
                    <input type="reset" id="Reset" value="Reset" />
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

            // Close the connection to the database
            appDBAuth.close();
            appDBMnger.close();
    }   
}catch(Exception e) {
    e.printStackTrace();
    // Handle exceptions here
} finally {
    System.out.println("Finally");
}
%>
<!-- Session Info -->
sessionName=<%= session.getAttribute("userName") %>
</body>
</html>
