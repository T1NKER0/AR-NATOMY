//This class belongs to the ut.JAR.CPEN410 package
package ut.JAR.CPEN410;

//Import the java.sql package for managing the ResulSet objects
import java.sql.*;

//Import hashing functions
import org.apache.commons.codec.*;

/******
	This class authenticate users using userName and passwords

*/
public class applicationDBAuthenticationGoodComplete{

	//myDBConn is an MySQLConnector object for accessing to the database
	private MySQLCompleteConnector myDBConn;
	
	/********
		Default constructor
		It creates a new MySQLConnector object and open a connection to the database
		@parameters:
		
	*/
	public applicationDBAuthenticationGoodComplete(){
		//Create the MySQLConnector object
		myDBConn = new MySQLCompleteConnector();
		
		//Open the connection to the database
		myDBConn.doConnection();
	}
	
	
	/*******
		authenticate method
			Authentication method
			@parameters:
			@returns:
				A ResultSet containing the userName and all roles assigned to her.
	*/
	public ResultSet authenticate(String userName, String userPass)
	{
		
		//Declare function variables
		String fields, tables, whereClause, hashingVal;
		
		//Define the table where the selection is performed
		tables="users, roleuser";

		//Define the list fields list to retrieve assigned roles to the user
		fields ="users.userName, roleuser.roleId, users.Name";
		hashingVal = hashingSha256(userName + userPass);
		whereClause="users.userName = roleuser.userName and users.userName='" +userName +"' and hash ='" + hashingVal + "'";
		
		
		System.out.println("listing...");
		
		//Return the ResultSet containing all roles assigned to the user
		return myDBConn.doSelect(fields, tables, whereClause);
	}

	/*******
		verifyUser method
			verification method
			@parameters:
			@returns:
				A Result set of the username along with the role assigned where the user is allowed to navigate the webpages.
	*/
	public ResultSet verifyUser(String userName, String currentPage, String previousPage)
	{
		
		//Declare function variables
		String fields, tables, whereClause, hashingVal;
		
		//Define the table where the selection is performed
		tables="roleuser, role, rolewebpage, webpage, users, webpageprevious";

		//Define the list fields list to retrieve assigned roles to the user
		fields ="users.userName, roleuser.roleId, users.Name ";
		whereClause=" users.userName = roleuser.userName and users.userName='" +userName +"' and role.roleId=roleuser.roleId and ";
		whereClause+=" rolewebpage.roleId=role.roleId and rolewebpage.pageURL=webpage.pageURL and webpage.pageURL='" +currentPage+"' and ";
		whereClause+=" webpageprevious.previousPageURL='"+previousPage+"' and webpageprevious.currentPageURL=webpage.pageURL"; 
		
		System.out.println("listing...");
		
		//Return the ResultSet containing all roles assigned to the user
		return myDBConn.doSelect(fields, tables, whereClause);
		
		
	}

	public boolean addUserWithRole(String userName, String completeName, String userPass, String roleId) {
		// Declare boolean res for insertion results
		boolean userAdded = false;
		boolean roleAssigned = false;
	
		// Define hashing value using hashingSha256
		String hashingValue = hashingSha256(userName + userPass);
	
		// Define user table
		String userTable = "users";
		
		// Define values to be inserted for the user table, excluding the id field
		String userValues = "DEFAULT, '" + userName + "', '" + completeName + "', '" + hashingValue + "'";
		System.out.println("Adding user to table: " + userTable);
		
		// Perform insertion of values in the users table
		userAdded = myDBConn.doInsert(userTable, userValues);
		System.out.println("User insertion result: " + userAdded);
	
		// If user was successfully added, assign role
		if (userAdded) {
			// Assign the current date as the date of assignment
			String dateAssign = "2024-03-12"; // You may want to dynamically set this
	
			// Define roleuser table
			String roleUserTable = "roleuser";
	
			// Define values to be inserted in the roleuser table
			String roleUserValues = "'" + userName + "', '" + roleId + "', '" + dateAssign + "'";
			System.out.println("Adding user role to table: " + roleUserTable);
			
			// Perform insertion of values in the roleuser table
			roleAssigned = myDBConn.doInsert(roleUserTable, roleUserValues);
			System.out.println("Role assignment result: " + roleAssigned);
		}
	
		// Returns true only if both operations are successful
		return userAdded && roleAssigned;
	}
	
	/*******
		modifyUser method
			Modifies an existing user in the database 
			@parameters:
			@returns:
				A boolean value if the user has been modified.
	*/
	public boolean modifyUser(String oldUserName, String newUserName, String newUserPass, String newName) {

		boolean res = false;
	
		try {
			// Define the table and fields to update
			String table = "users";
			String setClause = "UserName = '" + newUserName + "', " +
							   "Name = '" + newName + "'";
			
			// Check if a new password is provided
			if (!newUserPass.isEmpty()) {
				String hashingValue = hashingSha256(newUserName + newUserPass);
				setClause += ", Hash = '" + hashingValue + "'";
			}
	
			// Define the where clause to identify the user to be modified
			String whereClause = "userName = '" + oldUserName + "'";
	
			// Perform the update using the doUpdate method with 3 parameters
			res = myDBConn.doUpdate(table, setClause, whereClause);
	
			if (res) {
				System.out.println("User details updated successfully for user: " + oldUserName);
			} else {
				System.out.println("No user found with username: " + oldUserName);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return res;
	}

	/*******
		setUserRole method
			setUserRole method
			@parameters:
			@returns:
				A boolean value when the user is assigned a role.
	

	/*******
		setAdminRole method
			setAdminRole method
			@parameters:
			@returns:
				A boolean value when the Admin is assigned a role.
	*/
	public boolean setAdminRole(String userName) {
		
		//Declare and define roleId
		String roleId = "ROLE1";

		//Declare and define dateAssign table
		String dateAssign = "2024-03-12";

		//Declare and define roleuser table
		String table = "roleuser";

		//Delcare and define the values to be inserted
		String values = "'" + userName + "', '" + roleId + "', '" + dateAssign + "'";

		//True or false if insertion was succesful
		boolean res = myDBConn.doInsert(table, values);

		System.out.println("Role assignment result: " + res);

		//Returns true or false
		return res;
	}
	
	/*******
		listUsers method
			List all users in the database
			@parameters:
			@returns:
				A ResultSet containing all the users in the database.
	*/
	public ResultSet listAllUsers() {

		//Declare and define fields list to retrieve from the usergood table
		String fields = "*";

		//Declare and define table where selection is performed
		String table = "users";

		//Return the ResultSet containing all users in the database
		return myDBConn.doSelect(fields, table);
	}

	/*******
		deleteUser method
			deletes users by username in the database
			@parameters:
			@returns:
				A boolean value if the user has been deleted.
	*/
	public boolean deleteUser(String userName) {

		//Declare and define boolean res to false
		boolean res = false;

		//Declare and define usergood table
		String table = "users";

		//Define the where clause
		String whereClause = "userName = '" + userName + "'";
		
		//True or false if deletion was succesful
		res = myDBConn.doDelete(table, whereClause);
		
		if (res) {
			System.out.println("Deleted User: " + userName);
		} else {
			System.out.println("Deletion Failed: " + userName);
		}
		
		//Returns true or false
		return res;
	}

	/*******
		menuElements method
			Authentication method
			@parameters:
			@returns:
				A ResultSet containing the userName and all roles assigned to her.
	*/
	public ResultSet menuElements(String userName) {
		// Declare function variables
		String fields, tables, whereClause, orderBy;
	
		// Define the table where the selection is performed
		tables = "roleuser, role, rolewebpage, menuElement,webpage ";
	
		// Define the list fields list to retrieve assigned roles to the user
		fields = "rolewebpage.pageURL, menuElement.title, webpage.pageTitle";
	
		// Define the where clause to filter the results
		whereClause = "roleuser.roleID=role.roleID and role.roleID=rolewebpage.roleId and menuElement.menuID = webpage.menuID";
		whereClause += " and rolewebpage.pageURL=webpage.pageURL";
		whereClause += " and userName='" + userName + "' AND menuElement.menuID != 4"; // Corrected placement of single quotes
	
		// Define the order by clause
		orderBy = "menuElement.title, webpage.pageTitle";
	
		System.out.println("listing...");
	
		// Return the ResultSet containing all roles assigned to the user
		return myDBConn.doSelect(fields, tables, whereClause, orderBy);
	}
	
	/* 
	public boolean addAdmin(String userName, String completeName, String userPass, String userTelephone)
	{
		boolean res;
		String table, values, hashingValue;
		hashingValue=hashingSha256(userName + userPass);
		table="usergood";
		values="'"+userName+"', '" +hashingValue+"', '"+ completeName + "', '" + userTelephone + "'";
		res=myDBConn.doInsert(table, values);
		System.out.println("Insertion result" + res);
		return res;
	}*/

	/*********
		hashingSha256 method
			Generates a hash value using the sha256 algorithm.
			@parameters: Plain text
			@returns: the hash string based on the plainText
	*/
	private String hashingSha256(String plainText)
	{
			String sha256hex = org.apache.commons.codec.digest.DigestUtils.sha256Hex(plainText); 
			return sha256hex;
	}

	
	/*********
		close method
			Close the connection to the database.
			This method must be called at the end of each page/object that instatiates a applicationDBManager object
			@parameters:
			@returns:
	*/
	public void close()
	{
		//Close the connection
		myDBConn.closeConnection();
	}

}