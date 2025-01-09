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
        session.setAttribute("currentPage", "newUser.jsp");
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();

        // Create instance of the authentication manager
        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();

        // Call the verifyUser method
        ResultSet res = appDBAuth.verifyUser(userName, "newUser.jsp", previousPage);  

        if (res.next()) { // User is verified
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
        form {
            background-color: rgba(255, 255, 255, 0.1); /* Semi-transparent white background for form */
            padding: 20px; /* Padding around the form */
            border-radius: 8px; /* Rounded corners for the form */
            max-width: 400px; /* Limit the width of the form */
            margin: 0 auto; /* Center the form horizontally */
        }
        table {
            width: 100%; /* Full width for the table */
            margin-bottom: 20px; /* Space below the table */
        }
        td {
            padding: 10px; /* Padding for table cells */
            vertical-align: middle; /* Align text to the middle of the cell */
        }
        input[type="text"], input[type="password"], select {
            width: 100%; /* Full width for input fields */
            padding: 10px; /* Padding for input fields */
            border: 1px solid #007B99; /* Border color */
            border-radius: 5px; /* Rounded corners for input fields */
            background-color: white; /* White background for input fields */
            color: #003D5B; /* Text color for input fields */
        }
        input[type="submit"], input[type="reset"] {
            padding: 10px 20px; /* Padding for buttons */
            background-color: #007B99; /* Button background color */
            color: white; /* Button text color */
            border: none; /* No border */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Pointer cursor on hover */
            margin-top: 10px; /* Space above the buttons */
            width: 100%; /* Full width for buttons */
        }
        input[type="submit"]:hover, input[type="reset"]:hover {
            background-color: #005f7a; /* Darker shade on hover */
        }
        /* Back button style */
        .back-button {
            background-color: #007B99; /* Background color for back button */
            color: white; /* Text color for back button */
            border: none; /* No border */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Pointer cursor on hover */
            padding: 10px 20px; /* Padding for back button */
            margin-top: 20px; /* Space above the back button */
            display: inline-block; /* Inline block for layout */
        }
        .back-button:hover {
            background-color: #005f7a; /* Darker shade on hover */
        }
    </style>
</head>
<body>
    <h1>Add User</h1>
    <form id="form_1" action="addUser.jsp" method="post">
        <table border="0">
            <tr>
                <td> Username </td>
                <td><input type="text" id="userName" name="userName" required/></td>
            </tr>
            <tr>
                <td> Name </td>
                <td><input type="text" id="completeName" name="completeName" required/></td>
            </tr>
            <tr>
                <td> Password </td>
                <td><input type="password" id="userPass" name="userPass" required/></td>
            </tr>
            <tr>
                <td> Role </td>
                <td>
                    <select id="userRole" name="userRole" required>
                        <option value="" disabled selected>Select role</option>
                        <%
                            // Fetch roles from the database
                            applicationDBManager appDBMnger = new applicationDBManager();
                            ResultSet roleRes = null;
                            try {
                                roleRes = appDBMnger.getRoles();
                                if (roleRes != null) {
                                    while (roleRes.next()) {
                                        String roleId = roleRes.getString("RoleID");
                                        String roleName = roleRes.getString("Name");
                        %>
                                        <option value="<%= roleId %>"><%= roleName %></option>
                        <%
                                    }
                                    roleRes.close();
                                } else {
                                    out.println("<option value='' disabled>Error loading roles</option>");
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                                out.println("<option value='' disabled>Error loading roles</option>");
                            } finally {
                                appDBMnger.close();
                            }
                        %>
                    </select>
                </td>
            </tr>
        </table>
        <input type="submit" id="Submit" value="Submit" />
        <input type="reset" id="Reset" value="Reset" />
    </form>

    <!-- Back button to redirect to welcomeMenu -->
    <form action="welcomeMenu.jsp" method="get" style="text-align: center; margin-top: 20px;">
        <input type="submit" value="Back to Welcome Menu" class="back-button" />
    </form>

</body>
</html>

<%
        } else { // User is not verified
            response.sendRedirect("loginHashing.html");
        }
    }
%>
