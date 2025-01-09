<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONException" %>
<html>
<head>
    <title>Update Assessments</title>
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
        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: white;
            color: #003D5B;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 5px;
            text-align: center;
        }
        .button:hover {
            background-color: #00A3E0;
            color: white;
        }
        .user-info {
            position: absolute;
            top: 20px;
            right: 20px;
            text-align: right;
            color: white;
        }
        .settings-form {
            max-width: 400px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<%
    // User authentication check and setup as in the original page
    try {
        if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
            session.setAttribute("currentPage", null);
            session.setAttribute("userName", null);
            response.sendRedirect("loginHashing.html");
        } else {
            String currentPage = "updateAssessmentVisibility.jsp";
            String userName = session.getAttribute("userName").toString();
            String previousPage = session.getAttribute("currentPage").toString();

            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();

            ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);

            if (res.next()) {
                String userActualName = res.getString(3);
                session.setAttribute("currentPage", currentPage);

                // Default visibility values for the checkboxes
                boolean isHeartVisible = false;
                boolean isRespiratoryVisible = false;
                boolean isGastrointestinalVisible = false;

                // Handle the form submission and database update here
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    isHeartVisible = "visible".equalsIgnoreCase(request.getParameter("button1"));
                    isRespiratoryVisible = "visible".equalsIgnoreCase(request.getParameter("button2"));
                    isGastrointestinalVisible = "visible".equalsIgnoreCase(request.getParameter("button3"));

                    // Use the applicationDBManager class to update the visibility
                    boolean heartUpdateSuccess = appDBAuth.updateAssessmentVisibility(1, isHeartVisible);
                    boolean respiratoryUpdateSuccess = appDBAuth.updateAssessmentVisibility(2, isRespiratoryVisible);
                    boolean gastrointestinalUpdateSuccess = appDBAuth.updateAssessmentVisibility(3, isGastrointestinalVisible);

                    // Create a response message
                    String updateMessage = "Visibility updated successfully.";
                    if (!(heartUpdateSuccess && respiratoryUpdateSuccess && gastrointestinalUpdateSuccess)) {
                        updateMessage = "Failed to update visibility.";
                    }
%>

                    <script>
                        alert("<%= updateMessage %>");
                    </script>

<%
                }
%>

                <h1>Assessment Visibility Status</h1>
                <div class="user-info">
                    <p>Logged in as: <%= userActualName %></p>
                    <a href="signout.jsp" style="text-decoration: none;">
                        <button type="button" class="button" style="background-color: #FF4C4C; color: white;">
                            Sign out
                        </button>
                    </a>
                </div>

                <div class="settings-form">
                    <form action="updateAssessmentVisibility.jsp" method="post">
                        <label>
                            <input type="checkbox" name="button1" value="visible" <%= (isHeartVisible ? "checked" : "") %>> Enable Heart Assessment
                        </label><br>
                        <label>
                            <input type="checkbox" name="button2" value="visible" <%= (isRespiratoryVisible ? "checked" : "") %>> Enable Respiratory System Assessment
                        </label><br>
                        <label>
                            <input type="checkbox" name="button3" value="visible" <%= (isGastrointestinalVisible ? "checked" : "") %>> Enable Gastrointestinal System Assessment
                        </label><br>
                        <button type="submit" class="button">Update Visibility</button>
                    </form>
                </div>

                <a href="welcomeMenu.jsp" class="button">Go to Welcome Menu</a>

<%
            } else {
                session.setAttribute("userName", null);
                response.sendRedirect("loginHashing.html");
            }
            appDBAuth.close();
        }
    } catch (Exception e) {
%>
        <p>Unable to display settings page. Please try again later.</p>
        <%
        e.printStackTrace();
        response.sendRedirect("loginHashing.html");
    }
%>
</body>
</html>
