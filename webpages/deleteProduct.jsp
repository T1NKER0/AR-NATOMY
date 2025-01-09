<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%-- Import the java.sql package to use the ResultSet class --%>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Delete Product</title>
	</head>
	<body>
    <%
    // Try to connect to the database using the applicationDBManager class
    try {
        // Check the authentication process
        if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
            session.setAttribute("currentPage", null);
            session.setAttribute("userName", null);
            response.sendRedirect("loginHashing.html");
        }else{

            // Retrieve variables
            String currentPage = "deleteProduct.jsp";
            String userName = session.getAttribute("userName").toString();
            String previousPage = session.getAttribute("currentPage").toString();

            //Create the appDBMAuth object
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            System.out.println("Connecting...");
            System.out.println(appDBAuth.toString());

            //Create the appDBMnger object
            applicationDBManager appDBMnger= new applicationDBManager();
            System.out.println("Connecting...");
            System.out.println(appDBMnger.toString());

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

                // Call the deleteProduct method to delete a product
                String productID = request.getParameter("productID");
                boolean resProduct = appDBMnger.deleteProduct(productID);

                // Verify if the product has been deleted successfully
                if (resProduct) {
                    %>Product successfully deleted
                    <form action="removeProduct.jsp" method="POST">
                        <button type="submit" name="removeProduct" value="removeProduct">Back to remove Product</button>
                    </form>
                    <form action="welcomeMenu.jsp" method="GET">
                        <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                    </form>
                    <%
                }else{
                    %>Deletion Failed <br>
                    <form action="removeProduct.jsp" method="POST">
                        <button type="submit" name="removeProduct" value="removeProduct">Back to remove Product</button>
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
    }catch (Exception e) {
        // Print error message if an exception occurs
        e.printStackTrace();
        out.println("Exception occurred: " + e.getMessage());
    }finally {
        System.out.println("Finally");
    }
    %>sessionName=<%=session.getAttribute("userName")%>
	</body>
</html>
