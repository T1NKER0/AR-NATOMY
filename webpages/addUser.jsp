<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>

<%
    // Check the authentication process
    if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
        session.invalidate(); // Clear session data
        response.sendRedirect("loginHashing.html");
    } else {
        // Update currentPage attribute here
        String currentPage = "addUser.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();

        // Create instance of the authentication manager
        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();

        // Call the verifyUser method
        ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);  

        if (res.next()) { // User is verified
            // Retrieve form parameters
            String newUserName = request.getParameter("userName");
            String newCompleteName = request.getParameter("completeName");
            String newUserPass = request.getParameter("userPass");
            String newUserRole = request.getParameter("userRole");
            String message = "";

            // Insert user into the database
            boolean isInserted = appDBAuth.addUserWithRole(newUserName, newCompleteName, newUserPass, newUserRole);

            // Check insertion result
            if (isInserted) {
                message = "User added successfully!";
            } else {
                message = "Failed to add user. Please try again.";
            }

            appDBAuth.close(); // Close database connection
%>

<html>
<head>
    <title>Add User</title>
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
    <h1>Add User</h1>
    <p><%= message %></p>

    <!-- Back button to redirect to welcomeMenu -->
    <form action="welcomeMenu.jsp" method="get" style="text-align: center; margin-top: 20px;">
        <input type="submit" value="Back to Welcome Menu" class="button" />
    </form>

    <!-- Button to return to newUser.jsp -->
    <form action="newUser.jsp" method="get" style="text-align: center; margin-top: 20px;">
        <input type="submit" value="Add Another User" class="button" />
    </form>

</body>
</html>

<%
        } else { // User is not verified
            response.sendRedirect("loginHashing.html");
        }
    }
%>
