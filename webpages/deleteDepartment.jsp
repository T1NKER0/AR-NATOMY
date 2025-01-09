<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Add User</title>
	</head>
	<body>

<%
	//Try to connect the database using the applicationDBManager class
	try{
		// Check the authentication process
   		if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
        session.setAttribute("currentPage", null);
        session.setAttribute("userName", null);
        response.sendRedirect("loginHashing.html");
    	} else {
				
        	String currentPage="deleteDepartment.jsp";
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
				
				
				String dept_name = request.getParameter("dept_name");

				//Call the deleteDepartment method.
				boolean resDepartment=appDBMnger.deleteDepartment(dept_name);

				//If delete is successful
				if (resDepartment){
					%>
					Department succesfully deleted
					<form action="removeDepartment.jsp" method="GET">
						<button type="submit" name="removeDepartment" value="removeDepartment">Remove Department</button>
					</form>
					<form action="welcomeMenu.jsp" method="GET">
						<button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
					</form>
					<%session.setAttribute("userName", userName);%>

					<%
				}else{//Not successful
					%>
					Deletion Failed <br>
					<form action="removeDepartment.jsp" method="GET">
						<button type="submit" name="removeDepartment" value="removeDepartment">Remove Department</button>
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

			//Close connection to database
			appDBAuth.close();
			appDBMnger.close();
		}
			
	} catch(Exception e){
		%>Nothing to show!<%
		e.printStackTrace();
	}finally{
		System.out.println("Finally");
	}
	%>sessionName=<%=session.getAttribute("userName")%>
	</body>
</html>