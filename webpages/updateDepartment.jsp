<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>

<html>
<head>
    <title>Update Department</title>
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

        String currentPage = "updateDepartment.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();

        // Create the appDBAuth object
        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
        System.out.println("Connecting...");
        System.out.println(appDBAuth.toString());

        // Create the appDBmnger object
        applicationDBManager appDBMnger = new applicationDBManager();
        System.out.println("Connecting...");
        System.out.println(appDBMnger.toString());

        // Call the verifyAdmin method to check if the user is an admin
        ResultSet resUser = appDBAuth.verifyUser(userName, currentPage, previousPage);

        // Get the department name parameter from the previous page
        String oldDepartmentName = request.getParameter("departmentNameModify");
        String newDepartmentName = request.getParameter("newDepartmentName");

       //Verify if the user has been authenticated
		if (resUser.next()){
			String userActualName=resUser.getString(3);
					
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

            // Call the modifyDepartment method to update department details
            boolean updateSuccess = appDBMnger.modifyDepartment(oldDepartmentName, newDepartmentName);

            // Display success or failure message based on the update result
            if (updateSuccess) {
                %>
                <p>Department details updated successfully for department: <%= oldDepartmentName %></p>
                <form action="modifyDepartment.jsp" method="GET">
                    <button type="submit" name="modifyDepartment" value="modifyDepartment">Modify Department</button>
                </form>
                <form action="welcomeMenu.jsp" method="GET">
                    <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                </form>
                <%
            } else {
            %>
            <p>No department found with name: <%= oldDepartmentName %></p>
            <form action="modifyDepartment.jsp" method="GET">
                <button type="submit" name="modifyDepartment" value="modifyDepartment">Modify Department</button>
            </form>
            <form action="welcomeMenu.jsp" method="GET">
                <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
            </form>
            <%
            }
        } else {
            //Close any session associated with the user
			session.setAttribute("userName", null);
					
			//return to the login page
			response.sendRedirect("loginHashing.html");
        }

        //Close connection to database
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
