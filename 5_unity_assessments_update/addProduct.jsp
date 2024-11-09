<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Add Product</title>
	</head>
	<body> 
    <%
    //Try to connect to the database using the applicationDBManager class
    try {
        //Check the authentication process
        if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
            session.setAttribute("currentPage", null);
            session.setAttribute("userName", null);
            response.sendRedirect("loginHashing.html");
        }else{

            //Retrieve variables
            String currentPage = "addProduct.jsp";
            String userName = session.getAttribute("userName").toString();
            String previousPage = session.getAttribute("currentPage").toString();

            //Retrieve other parameters
            String productName = request.getParameter("productName");
            String productDescription = request.getParameter("productDescription");
            String dept_Name = request.getParameter("dept_name");
            String bid = request.getParameter("bid");
            String dueDate = request.getParameter("dueDate");
            String image = request.getParameter("image");

            //Create the appDBAuth object
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            System.out.println("Connecting...");
            System.out.println(appDBAuth.toString());

            //Create the appDBMnger object
            applicationDBManager appDBMnger = new applicationDBManager();
            System.out.println("Connecting...");
            System.out.println(appDBMnger.toString());


            //Call the verifyUser method to authenticate the user
            ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);

            //Verify if the user has been authenticated
            if (res.next()) {
                %>User Verified<%
                session.setAttribute("currentPage", currentPage);
                %><%
                //Call the addProduct method to add a new product
                boolean resProduct = appDBMnger.addProduct(productName, productDescription, dept_Name, bid, dueDate, userName, image);

                //Verify if the product has been added successfully
                if (resProduct) {
                    %>Product added
                    <form action="newProduct.jsp" method="GET">
                        <button type="submit" name="newProduct" value="newProduct">New Product</button>
                    </form>
                    <form action="welcomeMenu.jsp" method="GET">
                        <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                    </form>
                    <%
                }else{
                    %>
                    Product cannot be added <br>
                    <form action="newProduct.jsp" method="GET">
                        <button type="submit" name="newProduct" value="newProduct">New Product</button>
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
            //Close the connection to the database
            appDBAuth.close();
        }
    }catch (Exception e) {
        //Print error message if an exception occurs
        e.printStackTrace();
        out.println("Exception occurred: " + e.getMessage());
    }finally{
        System.out.println("Finally");
    }
    %>sessionName=<%=session.getAttribute("userName")%>
	</body>
</html>
