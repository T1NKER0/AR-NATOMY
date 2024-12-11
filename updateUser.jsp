<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>

<html>
<head>
    <title>Update User</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 20px;
        }

        h1 {
            color: #007BFF;
            text-align: center;
        }

        form {
            background: #fff;
            padding: 20px;
            margin: 0 auto;
            max-width: 400px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        button {
            background-color: #007BFF;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            margin: 5px 0;
        }

        button:hover {
            background-color: #0056b3;
        }

        p {
            text-align: center;
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

        String currentPage = "updateUser.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();

        //Get the userName parameter from the previous page
        String oldUserName = request.getParameter("userNameModify");

        //Retrieve other form parameters
        String newUserName = request.getParameter("newUserName");
        String newPass = request.getParameter("newPass");
        String newName = request.getParameter("newName");

        //Create the appDBMnger object
        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
        System.out.println("Connecting...");
        System.out.println(appDBAuth.toString());

        //Call the verifyUser method to check if the user is an admin
        ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);

        //Verify if the user has been authenticated
        if (res.next()){

            String sessionName = res.getString(3);
                            
            //Create the current page attribute
            session.setAttribute("currentPage", currentPage);
                            
            //Create a session variable
            if (session.getAttribute("userName") == null){
                //create the session variable
                session.setAttribute("userName", userName);
            } else {
                //Update the session variable
                session.setAttribute("userName", userName);
            }

            //Call the modifyUser method to update user details
            boolean updateSuccess = appDBAuth.modifyUser(oldUserName, newUserName, newPass, newName);

            // Display success or failure message based on the update result
            if (updateSuccess) {
                %>
                <h1>Success!</h1>
                <p>User details updated successfully for user: <%= oldUserName %></p>
                <form action="modifyUser.jsp" method="GET">
                    <button type="submit" name="modifyUser" value="modifyUser">Modify User</button>
                </form>
                <form action="welcomeMenu.jsp" method="GET">
                    <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                </form>
                <%
            } else {
                %>
                <h1>Error</h1>
                <p>No user found with username: <%= oldUserName %></p>
                <form action="modifyUser.jsp" method="GET">
                    <button type="submit" name="modifyUser" value="modifyUser">Modify User</button>
                </form>
                <form action="welcomeMenu.jsp" method="GET">
                    <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                </form>
                <%
            }
        } else {
            //Close any session associated with the user
            session.setAttribute("userName", null);

            //return to the login page
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
