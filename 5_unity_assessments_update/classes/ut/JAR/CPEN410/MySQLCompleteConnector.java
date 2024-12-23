//This class belongs to the ut.JAR.CPEN410 package
package ut.JAR.CPEN410;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

/******
	This class manage a connection to the Department database and it should not be accessed from the front End. 
*/
public class MySQLCompleteConnector{

	//Database credential <jdbc:<protocol>://<hostName>/<databaseName>>
	private String DB_URL="jdbc:mysql://localhost/arnatomy";
	
	//Database authorized user information
	private String USER="root";
	private String PASS="Marcos0206";
   
   //Connection objects
   private Connection conn;
   
   //Statement object to perform queries and transations on the database
   private Statement stmt;
   
	/********
		Default constructor
		@parameters:
		
	*/
	public MySQLCompleteConnector()
	{
		//define connections ojects null
		conn = null;
		stmt = null;}
		
	/********
		doConnection method
			It creates a new connection object and open a connection to the database
			@parameters:

	*/		
	public void doConnection(){
		try{
		  //Register JDBC the driver
		  Class.forName("com.mysql.jdbc.Driver").newInstance();

								   
		  System.out.println("Connecting to database...");
		   //Open a connection using the database credentials
		  conn = DriverManager.getConnection(DB_URL, USER, PASS);
		  
		  System.out.println("Creating statement...");
		  //Create an Statement object for performing queries and transations
		  stmt = conn.createStatement();
		  System.out.println("Statement Ok...");
		} catch(SQLException sqlex){
			sqlex.printStackTrace();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

	public Connection getConnection() {
		return this.conn; // Assuming you have a connection field
	}
	

	public ResultSet showTables() {
		ResultSet resultSet = null;
	
		// Create the SQL query to show tables
		String query = "SHOW TABLES";
	
		try {
			// Use the existing connection (conn) to create a Statement object
			Statement statement = conn.createStatement();
			// Execute the query and retrieve the result set
			resultSet = statement.executeQuery(query);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	
		return resultSet;
	}
	
	
	
	/********
		closeConnection method
			Close the connection to the database
			@parameters:

	*/		
	public void closeConnection()
	{
		try{
			//close the statement object
			stmt.close();
			//close the connection to the database
			conn.close();
			}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	/***********
		doSelect method
			This method performs a query to the database
			@parameters:
				fields: list of fields to be projected from the tables
				tables: list of tables to be selected
				where: where clause
			@returns:
				ResulSet result containing the project tuples resulting from the query
	*/
	public ResultSet doSelect(String fields, String tables, String where){
		//Create a ResulSet
		ResultSet result=null;
		
		//Create the selection statement 
		String selectionStatement = "Select " + fields+ " from " + tables + " where " + where + " ;";
		System.out.println(selectionStatement);
		
		try{
			//perform the query and catch results in the result object
			result = stmt.executeQuery(selectionStatement);
		} catch(Exception e){
			e.printStackTrace();
		}
		finally{

			//return results
			return result;

		}
	}
	/***********
		doSelect method
			This method performs a query to the database
			@parameters:
				fields: list of fields to be projected from the tables
				tables: list of tables to be selected
			@returns:
				ResulSet result containing the project tuples resulting from the query
	*/
	
	public ResultSet doSelect(String fields, String tables){
		//Create a ResulSet
		ResultSet result=null;
		
		//Create the selection statement 
		String selectionStatement = "Select " + fields+ " from " + tables + ";";
		System.out.println(selectionStatement);
		
		try{
			//perform the query and catch results in the result object
			result = stmt.executeQuery(selectionStatement);
		} catch(Exception e){
			e.printStackTrace();
		}
		finally{
			//return results
			return result;
		}
	}

	
	/***********
		doSelect method
			This method performs a query to the database
			@parameters:
				fields: list of fields to be projected from the tables
				tables: list of tables to be selected
				where: where clause
				orderBy: order by condition
			@returns:
				ResulSet result containing the project tuples resulting from the query
	*/
	public ResultSet doSelect(String fields, String tables, String where, String orderBy){
		
		//Create a ResulSet
		ResultSet result=null;
		
		//Create the selection statement 
		String selectionStatement = "Select " + fields+ " from " + tables + " where " + where + " order by " + orderBy + ";";
		
		try{
			//perform the query and catch results in the result object
			result = stmt.executeQuery(selectionStatement);
		} catch(Exception e){
			e.printStackTrace();
		}
		finally{
			//return results
			return result;
		}
	}
	
	/***********
		doInsertion method
			This method performs an insertion to the database
			@parameters:
				values: values to be inserted 
				table: table to be updated
				
			@returns:
				boolean value: true: the insertion was ok, an error was generated
	*/
	
	public boolean doInsert(String table, String values)
	{
		boolean res=false;
		int result;
		String charString ="INSERT INTO "+ table + " values (" + values +");";
		System.out.println(charString);
		//try to insert a record to the selected table
		try{
			 result=stmt.executeUpdate(charString);
			 if (result > 0)
			 {
				res = true;
			 }
			 System.out.println("MySQLCompleteConnector insertion: " + res);
		}
		catch(Exception e)
		{
			
			e.printStackTrace();
		}
		finally{
			
		}
			return res;
	}

	public boolean doDelete(String table, String where) {
		boolean deletionSuccess = false;
		int result;
		String deletionStatement = "DELETE FROM " + table + " WHERE " + where + ";";
		System.out.println(deletionStatement);
		try {
			result = stmt.executeUpdate(deletionStatement);
			if (result > 0) {
				deletionSuccess = true;
			}
			System.out.println("MySQLCompleteConnector deletion: " + deletionSuccess);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return deletionSuccess;
	}

	public boolean doUpdate(String table, String setClause, String whereClause) {
		boolean updateSuccess = false;
		int result;
		String updateStatement = "UPDATE " + table + " SET " + setClause + " WHERE " + whereClause + ";";
		System.out.println(updateStatement);
		try {
			result = stmt.executeUpdate(updateStatement);
			if (result > 0) {
				updateSuccess = true;
			}
			System.out.println("MySQLCompleteConnector update: " + updateSuccess);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return updateSuccess;
	}
	


	
	/***********
		Debugging method
			This method creates an applicationDBManager object, retrieves all departments in the database, and close the connection to the database
			@parameters:
				args[]: String array 
			@returns:
	*/
	public static void main(String[] args)
	{	
		System.out.println("TEsting");
		//Create a MySQLConnector
		MySQLCompleteConnector conn = new MySQLCompleteConnector();
		//Declare tthe fiels, tables and whereClause string objects
		String fields, tables, whereClause;
		//Define the projected fields
		fields ="dept_name, building";
		//Define the selected tables
		tables="department";
		//Establish the where clause
		whereClause="budget>1000";		
		
			
		try{
			System.out.println("Connecting...");
			//Establish the database connection
			conn.doConnection();
			//perform the query using the doSelect methods with 3 parameters
			ResultSet res=conn.doSelect(fields, tables, whereClause);
		
			//Iterate over the ResulSet containing all departments in the database, and count how many tuples were retrieved
			int count=0;
			while (res.next())
			{
				count++;
				
			}
			//Print the results count
			System.out.println("Count: " + count);
			
			//Close the ResulSet
			res.close();
			//Close the database connection
			conn.closeConnection();
			
		} catch(Exception e)
		{
			e.printStackTrace();
		}
	}

}