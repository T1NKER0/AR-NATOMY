<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>

<html>
<head>
    <title>Update Product</title>
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

        String currentPage = "updateProduct.jsp";
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

            int productIdModify = Integer.parseInt(request.getParameter("productIdModify"));
            String newProductName = request.getParameter("newProductName");
            String newDescription = request.getParameter("newDescription");
            String newDeptName = request.getParameter("newDeptName");
            String newDueDate = request.getParameter("newDueDate");
            String newImage = request.getParameter("newImage");

            //Modify the product
            boolean modifyResult = appDBMnger.modifyProduct(productIdModify, newProductName, newDescription, newDeptName, "", newDueDate, newImage);
            if (modifyResult) {
                %> Product details updated successfully!
                <form action="modifyProduct.jsp" method="GET">
                    <button type="submit" name="modifyProduct" value="modifyProduct">Modify Product</button>
                </form>
                <form action="welcomeMenu.jsp" method="GET">
                    <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                </form>
                <%
            }else{
                %> Error updating product details.
                <form action="modifyProduct.jsp" method="GET">
                    <button type="submit" name="modifyProduct" value="modifyProduct">Modify Product</button>
                </form>
                <form action="welcomeMenu.jsp" method="GET">
                    <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                </form>
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
} catch (Exception e) {
    e.printStackTrace();
    // Handle exceptions here
} finally {
    System.out.println("Finally");
}
%>
</body>
</html>

