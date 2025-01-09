<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>

<html>
<head>
    <title>Remove User</title>
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
            font-size: 16px; /* Increase font size for better visibility */
        }
        .button:hover {
            background-color: #00A3E0; /* Light blue background on hover */
            color: white; /* White text on hover */
        }
        form {
            text-align: center; /* Center the form */
            margin: 20px 0; /* Margin for spacing */
        }
        table {
            margin: 0 auto; /* Center the table */
            border-collapse: collapse; /* Remove space between table cells */
        }
        td {
            padding: 10px; /* Padding for table cells */
            color: white; /* White text color for table cells */
        }
        select {
            width: 200px; /* Width for the dropdown */
            font-size: 14px; /* Font size for the dropdown */
            padding: 5px; /* Padding for the dropdown */
            border: none; /* No border */
            border-radius: 5px; /* Rounded corners */
        }
        input[type="submit"], input[type="reset"], button {
            background-color: white; /* White background for buttons */
            color: #003D5B; /* Text color to match the theme */
            border: none; /* No border */
            border-radius: 5px; /* Rounded corners */
            padding: 10px 20px; /* Padding for buttons */
            cursor: pointer; /* Pointer cursor on hover */
            font-size: 16px; /* Increase font size for better visibility */
        }
        input[type="submit"]:hover, input[type="reset"]:hover, button:hover {
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
        String currentPage = "removeUser.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();

        // Create the appDBAuth object
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

            // Call listAllUsers method 
            ResultSet resUser = appDBAuth.listAllUsers(); 
%>
            <h1>Remove User</h1>
            <!-- User Dropdown List -->
            <form action="deleteUser.jsp" method="POST">
                <table>
                    <tr>
                        <td>User</td>
                        <td>
                            <select id="userNameDelete" name="userNameDelete">
                                <option value="Select User">Select User</option>
                                <%
                                while (resUser.next()) {
                                    // Assuming the first column contains the username
                                %>
                                <option value="<%= resUser.getString(2) %>"><%= resUser.getString(2) %></option>
                                <%
                                }
                                %>
                            </select>
                        </td>
                    </tr>
                </table>
                <input type="submit" class="button" id="Submit" value="Submit" />
                <input type="reset" class="button" id="Reset" value="Reset" />
            </form>
            <form action="welcomeMenu.jsp" method="POST">
                <button type="submit" class="button" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
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
    e.printStackTrace();
    // Handle exceptions here
} finally {
    System.out.println("Finally");
}
%>

</body>
</html>
