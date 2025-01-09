<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>AR-NATOMY</title>
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
        .user-info {
            position: absolute; /* Positioning to place it in the corner */
            top: 20px; /* Distance from the top */
            right: 20px; /* Distance from the right */
            text-align: right; /* Align text to the right */
            color: white; /* White text color */
        }
        ul {
            list-style-type: none; /* No bullets for the list */
            padding: 0; /* No padding */
            margin: 20px 0; /* Space above and below the list */
            max-width: 300px; /* Limit the width of the list */
            text-align: left; /* Align text to the left */
        }
    </style>
</head>
<body>
<%
    // Try to connect to the database using the applicationDBManager and applicationDBAuthenticationGoodComplete class
    try {
        // Check the authentication process
        if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
            session.setAttribute("currentPage", null);
            session.setAttribute("userName", null);
            response.sendRedirect("loginHashing.html");
        } else {
            String currentPage = "welcomeMenu.jsp";
            String userName = session.getAttribute("userName").toString();
            String previousPage = session.getAttribute("currentPage").toString();

            // Create the appDBAuth object
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            System.out.println("Connecting...");
            System.out.println(appDBAuth.toString());

            // Create the appDBMnger object
            applicationDBManager appDBMnger = new applicationDBManager();
            System.out.println("Connecting...");
            System.out.println(appDBMnger.toString());

            // Call the verifyUser method
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
%>
                <h1>AR-NATOMY</h1> <!-- Title at the top -->
                <div class="user-info">
                    <p>Logged in as: <%= userActualName %></p>
                    <a href="signout.jsp" style="text-decoration: none;">
                        <button type="button" class="button" style="background-color: #FF4C4C; color: white; border: none;">
                            Sign out
                        </button>
                    </a>
                </div>

                <p>Welcome, <%= userActualName %>!</p>
                <ul>
<%
                // Draw the menu
                ResultSet menuRes = appDBAuth.menuElements(userName);
                String currentMenu = "";

                while (menuRes.next()) {
                    // Check to create a new menu element
                    if (currentMenu.compareTo(menuRes.getString(2)) != 0) {
                        // A new element
                        currentMenu = menuRes.getString(2);
%>
                        <li style="color: white; font-weight: bold;"><%= currentMenu %></li>
<%
                    }
                    // Print the page title and establish a hyperlink
%>
                    <li>
                        <a href="<%= menuRes.getString(1) %>" class="button"><%= menuRes.getString(3) %></a>
                    </li>
<%
                } 
                // Close the list 
%>
                </ul>
<%
            } else {
                // Close any session associated with the user
                session.setAttribute("userName", null);

                // Return to the login page
                response.sendRedirect("loginHashing.html");
            }
            // Close the connection to the database
            appDBAuth.close();
            appDBMnger.close();
        } 
    } catch (Exception e) {
        %>Nothing to show!<%
        e.printStackTrace();
        response.sendRedirect("loginHashing.html");
    } finally {
        System.out.println("Finally");
    }
%>			
</body>
</html>
