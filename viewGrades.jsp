<%@ page import="java.sql.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<html>
<head>
    <title>View Grades</title>
    <style>
        body {
            background-color: #003D5B;
            color: white;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
        }
        h1 {
            text-align: center;
            font-size: 2.5em;
            margin-bottom: 30px;
        }
        .user-info {
            position: absolute;
            top: 20px;
            right: 20px;
            text-align: right;
            color: white;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid white;
            text-align: center;
        }
        th {
            background-color: #00A3E0;
        }
        button {
            background-color: #000080; /* Navy Blue for other buttons */
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
            border-radius: 5px;
        }
        .back-button {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #001f3f; /* Darker blue for back button */
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        /* Specific style for the Sign out button */
        .signout-btn {
            background-color: #FF5733; /* Red color for sign out */
            color: white;
            border: none;
            padding: 8px 15px;
            cursor: pointer;
            border-radius: 5px;
        }
        .signout-btn:hover {
            background-color: #C7441C; /* Darker red on hover */
        }
    </style>
</head>
<body>
<%
    try {
        if (session.getAttribute("userName") == null) {
            response.sendRedirect("loginHashing.html");
        } else {
            String currentPage = "viewGrades.jsp";
            String userName = session.getAttribute("userName").toString();
            String previousPage = session.getAttribute("currentPage").toString();
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);

            if (res.next()) {
                String userActualName = res.getString(3);
                session.setAttribute("userName", userName);
                // Create the current page attribute
                session.setAttribute("currentPage", currentPage);
%>
                <h1>Grades</h1>
                <div class="user-info">
                    <p>Logged in as: <%= userActualName %></p>
                    <a href="signout.jsp"><button class="signout-btn">Sign out</button></a> <!-- Sign out button with red styling -->
                </div>
                <p>Welcome, <%= userActualName %>!</p>

                <table>
                    <tr>
                           <th>ID</th>
                            <th>Student</th>
                            <th>Grade</th>
                            <th>Assessment</th>
                            <th>Date Taken</th>
                        </tr> 
                    <tbody>
<%
                ResultSet assessmentsRes = appDBAuth.getAssessments(); // Fetch assessments
                while (assessmentsRes.next()) {
                    int assessmentId = assessmentsRes.getInt("assessment_id"); // Get Assessment ID
                    String studentName = assessmentsRes.getString("userstudent"); // Get Assessment Name
                    String grade = assessmentsRes.getString("grade"); // Get Grade
                    Date dateTaken = assessmentsRes.getDate("dateTaken"); // Get Date Taken
                    String assessment_type = assessmentsRes.getString("assessment_name"); // Get Description
%>

                        <tr>
                            <td><%= assessmentId %></td>
                            <td><%= studentName %></td>
                            <td><%= grade %></td>
                            <td><%= assessment_type %></td>
                            <td><%= dateTaken %></td>
                        </tr>
<%
                }
%>
                    </tbody>
                </table>
                
               <h3>Select an Assessment to Update Grade</h3>
<form action="updateGrade.jsp" method="get">
    <label for="assessmentId">Choose Assessment ID:</label>
    <select name="assessmentId" id="assessmentId">
        <% 
            assessmentsRes.beforeFirst(); // Reset result set to the beginning
            while (assessmentsRes.next()) {
                int assessmentId = assessmentsRes.getInt("assessment_id");
                String userStudent = assessmentsRes.getString("userstudent"); // Get student username for the assessment
        %>
            <option value="<%= assessmentId %>,<%= userStudent %>">
                <%= assessmentId %> - <%= userStudent %>
            </option>
        <% 
            }
        %>
    </select>
    <input type="submit" value="Go">
</form>

                
                <a href="welcomeMenu.jsp" class="back-button">Back to Welcome Menu</a>
<%
            } else {
                session.invalidate();
                response.sendRedirect("loginHashing.html");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.invalidate();
        response.sendRedirect("loginHashing.html");
    }
%>
</body>
</html>
