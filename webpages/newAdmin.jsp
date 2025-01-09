<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Add User</title>
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

            String currentPage = "newAdmin.jsp";
            String userName = session.getAttribute("userName").toString();
            String previousPage = session.getAttribute("currentPage").toString();

            // Create the appDBAuth object
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            System.out.println("Connecting...");
            System.out.println(appDBAuth.toString());

            //Call the verifyUser method.
			ResultSet res=appDBAuth.verifyUser(userName, currentPage, previousPage);
			
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
                %>
                <form id="form_1" action="addAdmin.jsp" method="POST">
			        <table border="0">
				    <tr>
					    <td> Username </td>
					    <td><input type="text" id="userName"  name="userName" /></td>
				    </tr>
				    <tr>
					    <td> Password </td>
					    <td><input type="password" id="userPass"  name="userPass" />
				    </tr>
				    <tr>
					    <td> Name </td>
					    <td><input type="text" id="completeName"  name="completeName" />
				    </tr>
				    <tr>
					    <td> Telephone </td>
					    <td><input type="text" id="telephone"  name="telephone" />
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
        }
    }catch(Exception e) {
        e.printStackTrace();
        // Handle exceptions here
    }finally{
        System.out.println("Finally");
    } 
    %>      
    sessionName=<%=session.getAttribute("userName")%>
</body>
</html>