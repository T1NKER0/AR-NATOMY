<%@ page import="java.sql.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<html>
<head>
    <title>Update Grade</title>
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
        form {
            margin-top: 20px;
            text-align: center;
        }
        label {
            display: inline-block;
            margin: 10px;
        }
        input[type="text"], select {
            padding: 5px;
            border-radius: 5px;
            border: 1px solid #00A3E0;
        }
        /* Style for Update Grade button */
        input[type="submit"] {
            background-color: #006400; /* Dark Green */
            color: white;
            border: none;
            padding: 8px 15px;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 20px;
        }
        input[type="submit"]:hover {
            background-color: #004d00; /* Darker green on hover */
        }

        /* Style for Sign Out button */
        .signout-btn {
            background-color: #FF5733; /* Red for Sign Out */
            color: white;
            border: none;
            padding: 8px 15px;
            cursor: pointer;
            border-radius: 5px;
            text-decoration: none; /* Remove underline from the link */
        }
        .signout-btn:hover {
            background-color: #C7441C; /* Darker red on hover */
        }

        /* Style for Back to View Grades button */
        .back-btn {
            background-color: #007BFF; /* Blue for Back button */
            color: white;
            border: none;
            padding: 8px 15px;
            cursor: pointer;
            border-radius: 5px;
            text-decoration: none; /* Remove underline from the link */
            margin-top: 10px;
        }
        .back-btn:hover {
            background-color: #0056b3; /* Darker blue on hover */
        }
    </style>
</head>
<body>
<%
    try {
        if (session.getAttribute("userName") == null) {
            response.sendRedirect("loginHashing.html");
        } else {
            String currentPage = "updateGrade.jsp";
            String userName = session.getAttribute("userName").toString();
            String previousPage = session.getAttribute("currentPage").toString();
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);

            if (res.next()) {
                String userActualName = res.getString(3);
                session.setAttribute("currentPage", currentPage);

                // Get assessmentId and userStudent from parameters
                String selectedValue = request.getParameter("assessmentId");
                String assessmentId = "";
                String userStudent = "";

                if (selectedValue != null && selectedValue.contains(",")) {
                    String[] parts = selectedValue.split(",");
                    assessmentId = parts[0]; // Extract assessmentId
                    userStudent = parts[1];  // Extract userStudent
                }

%>
                <h1>Update Grade</h1>
                <div class="user-info">
                    <p>Logged in as: <%= userActualName %></p>
                    <a href="signout.jsp"><button class="signout-btn">Sign out</button></a><br>
                    <!-- Back to View Grades button -->
                    <a href="viewGrades.jsp"><button class="back-btn">Back to View Grades</button></a>
                </div>
                <form action="processGradeUpdate.jsp" method="post">
                    <label for="assessmentId">Assessment ID:</label>
                    <input type="text" id="assessmentId" name="assessmentId" value="<%= assessmentId %>" readonly><br>
                    
                    <label for="userStudent">Student Username:</label>
                    <input type="text" id="userStudent" name="userStudent" value="<%= userStudent %>" readonly><br>

                    <label for="newGrade">New Grade:</label>
                    <input type="text" id="newGrade" name="newGrade" required><br>

                    <input type="submit" value="Update Grade">
                </form>
<%
            } else {
                session.invalidate();
                response.sendRedirect("loginHashing.html");
            }

            appDBAuth.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.invalidate();
        response.sendRedirect("loginHashing.html");
    }
%>

</body>
</html>
