<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>

<html>
<head>
    <title>Modify User</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        form {
            margin-bottom: 20px;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        input[type="text"], input[type="password"], select {
            width: calc(100% - 20px);
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"], input[type="reset"], button {
            padding: 10px 15px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }
        input[type="submit"]:hover, input[type="reset"]:hover, button:hover {
            background-color: #0056b3;
        }
        h2 {
            color: #333;
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
        String currentPage = "modifyUser.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();

        // Create the appDBMAuth object
        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
        System.out.println("Connecting...");
        System.out.println(appDBAuth.toString());

        // Call the verifyUser method to check if the user is an admin
        ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);

        // Verify if the user has been authenticated
        if (res.next()) {
            String sessionName = res.getString(3);
            // Create the current page attribute
            session.setAttribute("currentPage", currentPage);
            // Create or update the session variable
            session.setAttribute("userName", userName);
%>            

            <%
            // Retrieve the list of all users
            ResultSet resUser = appDBAuth.listAllUsers();
            %>
            <!-- User Modification Form -->
            <form action="updateUser.jsp" method="POST">
                <table>
                    <tr>
                        <td>Select User to Modify:</td>
                        <td>
                            <select id="userNameModify" name="userNameModify">
                                <option value="Select User">Select User</option>
                                <%
                                while (resUser.next()) {
                                %>
                                <option value="<%= resUser.getString("username") %>"><%= resUser.getString("username") %></option>
                                <%
                                }
                                %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>New Username:</td>
                        <td><input type="text" id="newUserName" name="newUserName" required/></td>
                    </tr>
                    <tr>
                        <td>New Password:</td>
                        <td><input type="password" id="newPass" name="newPass" required/></td>
                    </tr>
                    <tr>
                        <td>New Name:</td>
                        <td><input type="text" id="newName" name="newName" required/></td>
                    </tr>
                    
                </table>
                <input type="submit" id="Submit" value="Submit" />
                <input type="reset" id="Reset" value="Reset" />
            </form>

            <form action="welcomeMenu.jsp" method="GET">
                <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
            </form>
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
    e.printStackTrace(); // Handle exceptions here
} finally {
    System.out.println("Finally");
}
%><!-- Session Info -->

</body>
</html>
