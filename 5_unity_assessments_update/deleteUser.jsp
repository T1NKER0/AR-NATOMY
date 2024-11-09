<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Delete User</title>
    <style>
        body {
            background-color: #003D5B; /* Dark water blue color */
            color: white; /* White text color for contrast */
            font-family: Arial, sans-serif; /* Font style */
            margin: 0;
            padding: 20px;
        }
        h1 {
            text-align: center; /* Center the title */
            font-size: 2.5em; /* Font size for the title */
            margin-bottom: 30px; /* Space below the title */
        }
        p {
            text-align: center; /* Center the paragraph */
        }
        .button {
            display: inline-block; /* Inline block for button */
            padding: 10px 20px; /* Padding for the button */
            background-color: white; /* White button background */
            color: #003D5B; /* Text color to match the theme */
            border: none; /* No border */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Pointer cursor on hover */
            text-decoration: none; /* No underline */
            margin: 5px; /* Space between buttons */
            text-align: center; /* Center text in button */
        }
        .button:hover {
            background-color: #00A3E0; /* Light blue background on hover */
            color: white; /* White text on hover */
        }
    </style>
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
        String currentPage = "deleteUser.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();
        String userNameDelete = request.getParameter("userNameDelete");

        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
        System.out.println("Connecting...");
        System.out.println(appDBAuth.toString());

        // Call the verifyUser method.
        ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);

        // Verify if the user has been authenticated
        if (res.next()) {
            String userActualName = res.getString(3);

            // Create the current page attribute
            session.setAttribute("currentPage", currentPage);

            // Create a session variable
            if (session.getAttribute("userName") == null) {
                // Create the session variable
                session.setAttribute("userName", userName);
            } else {
                // Update the session variable
                session.setAttribute("userName", userName);
            }

            // Call deleteUser method
            boolean deleteUserResult = appDBAuth.deleteUser(userNameDelete);

            // User was successfully deleted
            if (deleteUserResult) {
%>
                <h1>User successfully deleted</h1>
                <form action="removeUser.jsp" method="GET">
                    <button type="submit" class="button" name="removeUser" value="removeUser">Remove User</button>
                </form>
                <form action="welcomeMenu.jsp" method="GET">
                    <button type="submit" class="button" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                </form>
<%
            } else { // Failed to delete
%>
                <h1>Deletion Failed</h1>
                <form action="removeUser.jsp" method="GET">
                    <button type="submit" class="button" name="removeUser" value="removeUser">Remove User</button>
                </form>
                <form action="welcomeMenu.jsp" method="GET">
                    <button type="submit" class="button" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                </form>
<%
            }
        } else {
            // Close any session associated with the user
            session.setAttribute("userName", null);

            // Return to the login page
            response.sendRedirect("loginHashing.html");
        }
        // Close connection to the database
        appDBAuth.close();
    }
} catch (Exception e) {
    %>Nothing to show!<%
    e.printStackTrace();
} finally {
    System.out.println("Finally");
}
%>

</body>
</html>
