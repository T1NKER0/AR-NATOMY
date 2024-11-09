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
        /* Style for buttons */
        input[type="submit"], button {
            background-color: #002A42; /* Darker Navy Blue */
            color: white;
            border: none;
            padding: 8px 15px;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 20px;
        }
        input[type="submit"]:hover, button:hover {
            background-color: #001D31; /* Even Darker Navy Blue on hover */
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
    </style>
</head>
<body>
<%
    try {
        // Verify user session and page access
        if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
            session.invalidate();
            response.sendRedirect("loginHashing.html");
            return;
        }

        String currentPage = "processGradeUpdate.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();
        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
        ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);

        if (res.next()) {
            String userActualName = res.getString(3);
            session.setAttribute("currentPage", currentPage);

            // Process the grade update
            String assessmentId = request.getParameter("assessmentId");
            String newGradeStr = request.getParameter("newGrade");
            String userStudent = request.getParameter("userStudent");

            if (assessmentId != null && newGradeStr != null && userStudent != null) {
                try {
                    int assessmentIdInt = Integer.parseInt(assessmentId);
                    double newGrade = Double.parseDouble(newGradeStr);

                    // Use modifyGrade method with userStudent
                    boolean updateSuccessful = appDBAuth.modifyGrade(assessmentIdInt, userStudent, newGrade);

                    if (updateSuccessful) {
%>
                        <h1>Grade Updated Successfully</h1>
                        <div class="user-info">
                            <p>Logged in as: <%= userActualName %></p>
                            <a href="signout.jsp"><button class="signout-btn" type="button">Sign out</button></a>
                        </div>
                        <p>Grade for Assessment ID <%= assessmentId %> has been updated to <%= newGrade %>.</p>
                        <form action="viewGrades.jsp" method="get">
                            <button type="submit">Back to View Grades</button>
                        </form>
                        <form action="welcomeMenu.jsp" method="get">
                            <button type="submit">Back to Welcome Menu</button>
                        </form>
<%
                    } else {
%>
                        <h1>Error: Grade Not Updated</h1>
                        <p>There was an issue updating the grade. Please try again.</p>
                        <form action="viewGrades.jsp" method="get">
                            <button type="submit">Back to View Grades</button>
                        </form>
                        <form action="welcomeMenu.jsp" method="get">
                            <button type="submit">Back to Welcome Menu</button>
                        </form>
<%
                    }
                } catch (NumberFormatException e) {
%>
                    <h1>Error: Invalid Input</h1>
                    <p>Please ensure the Assessment ID and Grade are valid numbers.</p>
                    <form action="viewGrades.jsp" method="get">
                        <button type="submit">Back to View Grades</button>
                    </form>
                    <form action="welcomeMenu.jsp" method="get">
                        <button type="submit">Back to Welcome Menu</button>
                    </form>
<%
                }
            } else {
%>
                <h1>Error: Missing Input</h1>
                <p>Please provide Assessment ID, Student Username, and the New Grade.</p>
                <form action="viewGrades.jsp" method="get">
                    <button type="submit">Back to View Grades</button>
                </form>
                <form action="welcomeMenu.jsp" method="get">
                    <button type="submit">Back to Welcome Menu</button>
                </form>
<%
            }
        } else {
            session.invalidate();
            response.sendRedirect("loginHashing.html");
        }

        appDBAuth.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("loginHashing.html");
    }
%>
</body>
</html>
