<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>

<html>
    <head>
        <title>Add Department</title>
    </head>
    <body>
    <%
    try {

        // Check the authentication process
        if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
            session.setAttribute("currentPage", null);
            session.setAttribute("userName", null);
            response.sendRedirect("loginHashing.html");

        }else{
            String currentPage = "newDepartment.jsp";
            String userName = session.getAttribute("userName").toString();
            String previousPage = session.getAttribute("currentPage").toString();

            //Create the appDBAuth Object
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
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
                %>
                <form id="form_1" action="addDepartment.jsp" method="POST">
                    <table border="0">
                    <tr>
                        <td> Department Name </td>
                        <td><input type="text" id="dept_name"  name="dept_name" required/></td>
                    </tr>
                    </table>
                    <input type="submit" id="Submit" value="submit" />
                    <input type="reset" id="Submit" value="reset" />
                </form>

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

            // Close the connection to the database
            appDBAuth.close();
        }
    }catch (Exception e) {
        e.printStackTrace();
        // Handle exceptions here

    }finally {
        System.out.println("Finally");
    }
    %>
    </body>
</html>