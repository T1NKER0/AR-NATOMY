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
	//Try to connect the database using the applicationDBManager class
	try{
		//Check the authentication process
		if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
			session.setAttribute("currentPage", null);
			session.setAttribute("userName", null);
			response.sendRedirect("loginHashing.html");
		}else{
			//Retrieve variables
			String dept_name = request.getParameter("dept_name");

    		String currentPage="addDepartment.jsp";
    		String userName = session.getAttribute("userName").toString();
    		String previousPage = session.getAttribute("currentPage").toString();

			//Create the appdbAuth Object
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            System.out.println("Connecting...");
            System.out.println(appDBAuth.toString());

			//Create the appDBMnger object
			applicationDBManager appDBMnger = new applicationDBManager();
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

				//Call the addDepartment method. This method inserts a new department into the table department
				boolean resDepartment=appDBMnger.addDepartment(dept_name);

				if(resDepartment){
					%>Department Added
					<form action="newDepartment.jsp" method="POST">
                    	<button type="submit" name="newDepartment" value="newDepartment">Back</button>
                	</form>
                    <form action="welcomeMenu.jsp" method="POST">
                    	<button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                	</form>
					<%
				}else{
                    %>Department couldnt be added
					<form action="newDepartment.jsp" method="POST">
                    	<button type="submit" name="newDepartment" value="newDepartment">Back</button>
                	</form>
                    <form action="welcomeMenu.jsp" method="POST">
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
			appDBMnger.close();
            appDBAuth.close();
		}
	}catch(Exception e){
		%>Nothing to show!<%
		e.printStackTrace();
	}finally{
		System.out.println("Finally");
	}
	%>
	</body>
</html>