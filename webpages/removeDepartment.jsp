<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>

<html>
<head>
    <title>Remove User</title>
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
        String currentPage = "removeDepartment.jsp";
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

            ResultSet resDep = appDBMnger.listAllDepartments();
            %>
            <!-- User Dropdown List -->
            <form action="deleteDepartment.jsp" method="POST">
            <table border="0">
            <tr>
                <td> Department </td>
                <td>
                    <select id="dept_name" name="dept_name" style="width: 200px; font-size: 14px;">
                        <option value="Select Department">Select Department</option>
                        <%
                        while (resDep.next()) {
                        %>
                        <option value="<%= resDep.getString(1) %>"><%= resDep.getString(1) %></option>
                        <%
                        }
                        %>
                    </select>
                </td>
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
        //Close the connection to the database
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
sessionName=<%= session.getAttribute("userName") %>
</body>
</html>