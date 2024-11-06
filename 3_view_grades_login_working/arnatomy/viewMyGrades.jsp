<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>My Grades</title>
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
        .user-info {
            position: absolute; /* Positioning to place it in the corner */
            top: 20px; /* Distance from the top */
            right: 20px; /* Distance from the right */
            text-align: right; /* Align text to the right */
            color: white; /* White text color */
        }
        table {
            width: 100%; /* Full width */
            border-collapse: collapse; /* Merge borders */
            margin-top: 20px; /* Space above the table */
        }
        th, td {
            padding: 10px; /* Padding in table cells */
            border: 1px solid white; /* White borders for the cells */
            text-align: center; /* Center align text */
        }
        th {
            background-color: #00A3E0; /* Light blue header */
        }
        .button {
            background-color: #FF4C4C; /* Sign out button color */
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            text-decoration: none;
        }
        .button:hover {
            background-color: #FF3333;
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
            String currentPage = "viewMyGrades.jsp"; // Current page
            String userName = session.getAttribute("userName").toString(); // Get the username from the session
            String previousPage = session.getAttribute("currentPage").toString(); // Get the previous page

            // Create the appDBAuth object
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();

            // Call the verifyUser method to check authentication and role verification
            ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);

            // Verify if the user has been authenticated
            if (res.next()) {
                String userActualName = res.getString(3); // Get the actual name

                // Create the current page attribute
                session.setAttribute("currentPage", currentPage);

                // Create/update session variable
                session.setAttribute("userName", userName);
%>
                <h1> My Grades </h1> <!-- Title at the top -->
                <div class="user-info">
                    <p>Logged in as: <%= userActualName %></p>
                    <a href="signout.jsp" class="button">Sign out</a>
                </div>

                <p>Welcome to the My Grades page, <%= userActualName %>!</p>

                <table>
                    <thead>
                        <tr>
                            <th>Assessment ID</th>
                            <th>Assessment Name</th>
                            <th>Description</th>
                            <th>Grade</th>
                            <th>Date Taken</th>
                        </tr>
                    </thead>
                    <tbody>
<%
                // Call the getUserGrades method to retrieve grades for the logged-in user
                ResultSet gradesRes = appDBAuth.getUserGrades(userName); // Adjust the method name and logic as needed

                // Loop through the ResultSet to display assessment details
                while (gradesRes.next()) {
                    int assessmentId = gradesRes.getInt("assessment_id"); // Get Assessment ID
                    String assessmentName = gradesRes.getString("assessmentName"); // Get Assessment Name
                    String description = gradesRes.getString("description"); // Get Description
                    String grade = gradesRes.getString("grade"); // Get Grade
                    Date dateTaken = gradesRes.getDate("dateTaken"); // Get Date Taken
%>
                        <tr>
                            <td><%= assessmentId %></td>
                            <td><%= assessmentName %></td>
                            <td><%= description %></td>
                            <td><%= grade %></td>
                            <td><%= dateTaken %></td>
                        </tr>
<%
                }
%>
                    </tbody>
                </table>
<%
            } else {
                // Close any session associated with the user
                session.setAttribute("userName", null);
                // Return to the login page
                response.sendRedirect("loginHashing.html");
            }

            // Close the connection to the database
            appDBAuth.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("loginHashing.html");
    } finally {
        System.out.println("Finally");
    }
%>
</body>
</html>
