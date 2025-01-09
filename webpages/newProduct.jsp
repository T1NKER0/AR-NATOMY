<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>

<html>
	<head>
		<title>Add a product</title>
	</head>
	<body>
	<%
	try{
		//Check the authentication process
		if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
			session.setAttribute("currentPage", null);
			session.setAttribute("userName", null);
			response.sendRedirect("loginHashing.html");
		}else{

			String currentPage="newProduct.jsp";
			String userName = session.getAttribute("userName").toString();
			String previousPage = session.getAttribute("currentPage").toString();

			//Create the appDBAuth object
			applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
			System.out.println("Connecting...");
			System.out.println(appDBAuth.toString());

			//Create the appDBMnger object
			applicationDBManager appDBMnger = new applicationDBManager();
            System.out.println("Connecting...");
            System.out.println(appDBMnger.toString());

			// Call the verifyUser method to authenticate the user
            ResultSet resUser = appDBAuth.verifyUser(userName, currentPage, previousPage);

            // Verify if the user has been authenticated
            if (resUser.next()) {
                String userActualName = resUser.getString(3);

                // Create the current page attribute
                session.setAttribute("currentPage", currentPage);

                // Create a session variable
                if (session.getAttribute("userName") == null) {
                    // Create the session variable
                    session.setAttribute("userName", userName);

                }else{

                    //Update the session variable
                    session.setAttribute("userName", userName);
                }
				%>
				<form id="form_1" action="addProduct.jsp" method="post">
					<table border="0">
					<tr>
						<td> Product Name </td>
						<td><input type="text" id="productName"  name="productName" /></td>
					</tr>
					<tr>
						<td> Description </td>
						<td><input type="text" id="productDescription"  name="productDescription" /></td>
					</tr>
					<tr>
						<td> Bid </td>
						<td><input type="text" id="bid"  name="bid" />
					</tr>
					<tr>
						<td> Due Date </td>
						<td><input type="text" id="dueDate"  name="dueDate" />
					</tr>
                	<tr>
						<td> Image </td>
						<td><input type="file" id="image"  name="image" />
					</tr>
				<%
			
				//Call the listAllDepartment method. This method returns a ResultSet containing all the tuples in the table Department
				ResultSet resDep=appDBMnger.listAllDepartments();

				%> 
				<tr>
					<td> Department </td>
					<td>
					<select id="dept_name" name="dept_name">
				<%
				while(resDep.next()){ 
				%><option value="<%=resDep.getString(1)%>"><%=resDep.getString(1)%></option><%
				} 
				%>
				</select>
				</td>
				</tr>

				</table>
				<input type="submit" id="Submit" value="submit" />
				<input type="reset" id="Submit" value="reset" />
				</form>

				<form action="welcomeMenu.jsp" method="POST">
				<button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
				</form>
				<%
			}else{
			    //Close any session associated with the user
		        session.setAttribute("userName", null);

		        //return to the login page
		        response.sendRedirect("loginHashing.html");
			}
			//Close connection to database
            appDBAuth.close();
            appDBMnger.close();
		}
	}catch(Exception e){
        e.printStackTrace();
        // Handle exceptions here
	}finally{
        System.out.println("Finally");
    }
%>		
</body>
</html>