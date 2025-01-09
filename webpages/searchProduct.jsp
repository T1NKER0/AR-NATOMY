<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <title>Mini eBay: Search Results</title>
</head>
    <body>
        <%
		// Try to connect the database using the applicationDBManager class
        try{
            //Authenticate if the user is logged in, if not redirect the user to login hashing
            if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
    			session.setAttribute("currentPage", null);
    			session.setAttribute("userName", null);
   	 			response.sendRedirect("loginHashing.html");
			}else{

				String currentPage = "searchProduct.jsp";
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

                //Call the verifyUser method to authenticate the user
                ResultSet resUser = appDBAuth.verifyUser(userName, currentPage, previousPage);

                // Verify if the user has been authenticated
                if (resUser.next()){
                    String sessionName = resUser.getString(3);

                    // Create the current page attribute
                    session.setAttribute("currentPage", currentPage);

                    // Create a session variable
                    if (session.getAttribute("userName") == null) {
                        // Create the session variable
                        session.setAttribute("userName", userName);
                    }else{
                        //Update the session variable
                        session.setAttribute("userName", userName);
                    }

                    // Retrieve parameters
                    String productName = request.getParameter("productName");
                    String deptName = request.getParameter("dept_name");

                    // Get the ResultSet based on parameters
                    ResultSet res = null;

                    if ((productName == null || productName.isEmpty()) && (deptName == null || deptName.equals("All Departments"))) {
                        // If no product name is provided and no department is selected, list all products
                        res = appDBMnger.listAllProduct();
                    } else if (productName != null && !productName.isEmpty() && (deptName == null || deptName.isEmpty() || deptName.equals("All Departments"))) {
                        // If a product name is provided but no department is selected, list products by name in all departments
                        res = appDBMnger.listProducts(productName);
                    } else if ((productName == null || productName.isEmpty()) && deptName != null && !deptName.isEmpty() && !deptName.equals("All Departments")) {
                        // If no product name is provided but a department is selected, list all products in that department
                        res = appDBMnger.listProductsInDepartment(deptName);
                    } else if (productName != null && !productName.isEmpty() && deptName != null && !deptName.isEmpty() && !deptName.equals("All Departments")) {
                        // If both product name and department are provided, list products by name in that department
                        res = appDBMnger.listProducts(productName, deptName);
                    }
					
                    // Iterate over the ResultSet
                    int count = 0;

                    while (res.next()) {
                        // Count each retrieved record from the query
                        count++;
                        %>
                        <tr>
                            <!-- ID: <%=res.getString(1)%>, <br> -->
                            NAME: <%=res.getString(2)%> <br>
                            <!-- DESCRIPTION: <%=res.getString(3)%>, <br> -->
                            DEPARTMENT: <%=res.getString(4)%> <br>
                            BID $<%=res.getString(5)%> <br>
                            DUE DATE: <%=res.getString(6)%> <br>
                            <!-- SELLER: <%=res.getString(7)%>, <br> -->
                            <img src="/cpen410/imagesjson/<%=res.getString(8)%>" alt="<%=res.getString(2)%>" style="width: 200px; height: auto;">  <br> <br>
                             <form action="displayItem.jsp" method="GET">
                                <input type="hidden" name="productId" value="<%=res.getString(1)%>">
                                <input type="hidden" name="productName" value="<%=productName %>">
                                <input type="hidden" name="dept_name" value="<%=deptName %>">
                                <input type="submit" value="View Item"> <br> <br>
                            </form>
                        </tr>
                    <%}

                    %>
                    </table>

					<form action="welcomeMenu.jsp" method="POST">
                        <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                    </form>
                    <%
                }else{
                    //Close any session associated with the user
					session.setAttribute("userName", null);

					//return to the login page
					response.sendRedirect("loginHashing.html");
                }
                //Close the connection to the database
				appDBAuth.close();
				appDBMnger.close();
            }
        }catch(Exception e){
            // Print error message if exception occurs
            e.printStackTrace();
            response.sendRedirect("loginHashing.html");

        }finally{
            System.out.println("Finally");
        }
%>
</body>
</html>




