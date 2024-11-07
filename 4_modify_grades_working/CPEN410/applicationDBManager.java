//This class belongs to the ut.JAR.CPEN410 package
package ut.JAR.CPEN410;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

/******
	This class manage a connection to the Department database and it should be accessed from the front End. Therefore,
	this class must contain all needed methods for manipulating data without showing how to access the database
*/
public class applicationDBManager{

	//myDBConn is an MySQLConnector object for accessing to the database
	private MySQLCompleteConnector myDBConn;
	
	/********
		Default constructor
		It creates a new MySQLConnector object and open a connection to the database
		@parameters:
		
	*/
	public applicationDBManager(){
		//Create the MySQLConnector object
		myDBConn = new MySQLCompleteConnector();
		
		//Open the connection to the database
		myDBConn.doConnection();
	}

	/*******
		deleteProduct method
			List all products by name in the database
			@parameters:
			productId: selected productID where delete will be performed
			@returns:
				A boolean value if the product has been deleted.
	*/
	public boolean deleteProduct(String productID) {

		//Declare and define boolean res
		boolean res = false;

		//Declare and define product table
		String table = "product";

		//Declare and define the where clause to identify the productId to be deleted
		String whereClause = "productID = '" + productID + "'";
		
		//Perform the deletion using the doDelete method
		res = myDBConn.doDelete(table, whereClause);
		
		if (res) {
			System.out.println("Deleted Product: " + productID);
		} else {
			System.out.println("Deletion Failed, Product ID: " + productID);
		}
		
		//Returns true or false
		return res;
	}

	/*******
		deleteDepartment method
			List all departments by dept_name in the database
			@parameters:
			dept_name: selected department name where delete will be performed
			@returns:
				A boolean value if the dept_name has been deleted.
	*/
	public boolean deleteDepartment(String dept_name) {

		//Declare and define boolean res
		boolean res = false;
		
		//Declare and define department table
		String table = "department";

		//Declare and define the where clause to identify the dept_name to be deleted
		String whereClause = "dept_name = '" + dept_name + "'";
		
		//Perform the update using the doDelete method
		res = myDBConn.doDelete(table, whereClause);
		
		if (res) {
			System.out.println("Deleted Department: " + dept_name);
		} else {
			System.out.println("Deletion Failed, Department: " + dept_name);
		}
		
		//Return true or false
		return res;
	}

	/*******
		addProduct method
			List all products by name in the database
			@parameters:
				productName: the products name,
				description: product's description,
				dept_name: the department which the product belongs,
				bid: the product's bid,
				dueDate: the product's bid due date,
				userName: the user which listed the product,
				image: the product's image
			@returns:
				A boolean value if the product has been inserted.
	*/
	public boolean addProduct(String productName, String description, String dept_Name, String bid, String dueDate, String userName, String image)
	{
		//Declare boolean res
		boolean res;

		//Declare function variables
		String table, values;

		//Define product table
		table="product";

		//Defince Values to be inserted in the product table
		values="DEFAULT, '"+productName+"', '" + description + "', '"+ dept_Name+"', '" + bid +"', '" + dueDate +"', '"+userName+"', '"+ image+"'";

		//Perform the insertion using the doInsert method
		res=myDBConn.doInsert(table, values);

		System.out.println("Insertion result: " + res);

		//Returns true or false
		return res;
	}

	/*******
		listAllProduct method
			List all products in the database
			@parameters:
			@returns:
				A ResultSet containing all products in the database.
	*/
	public ResultSet listAllProduct() {

		//Declare and define fields list to retrieve from the product table
		String fields = "*";

		//Declare and define table where selection is performed
		String table = "product";

		//Return the ResultSet containing all products in the database
		return myDBConn.doSelect(fields, table);
	}

	/*******
		listProducts method
			List products by productName in the database
			@parameters:
				productName: the product's name
			@returns:
				A ResultSet containing all products with the same productName in the database.
	*/
	public ResultSet listProducts(String productName) {

		//Declare and define fields list to retrieve from the product table
		String fields = "*";

		//Declare and define table where selection is performed
		String table = "product";

		//Define the where clause to select products based on the provided productName
		String whereClause = "productName = '" + productName + "'";

		//Return the ResultSet containing all products with the same productName in the database
		return myDBConn.doSelect(fields, table, whereClause);
	}
	
	/*******
		listProducts method
			List products by productName in a specific department in the database
			@parameters:
				productName: the product's name,
				dept_name: the department name
			@returns:
				A ResultSet containing all products with the same productName in a specific department in the database.
	*/
	public ResultSet listProducts(String productName, String dept_name) {

		//Declare and define fields list to retrieve from the product table
		String fields = "*";

		//Declare and define table where selection is performed
		String table = "product";

		//Define the where clause to select products based on the provided productName and dept_name
		String whereClause = "productName = '" + productName + "' AND dept_name = '" + dept_name + "'";
		
		//Return the ResultSet containing all products with the same product name in a specific department in the database
		return myDBConn.doSelect(fields, table, whereClause);
	}

	/*******
		getProductId method
			gets the productId of the product in the database
			@parameters:
				productId: the product's ID
			@returns:
				//Return the ResultSet containing the product's productId in the database.
	*/
	public ResultSet getProductId(String productId) {

		//Declare and define fields list to retrieve from the product table
		String fields = "*";

		//Declare and define table where selection is performed
		String table = "product";

		//Define the where clause to select products based on the provided productName
		String whereClause = "productId = '" + productId + "'";
		// Perform the selection

		//Return the ResultSet containing the product's productId in the database
		return myDBConn.doSelect(fields, table, whereClause);
	}

	/*******
		listAllDepartments method
			List all departments in the database
			@parameters:
			@returns:
				A ResultSet containing all departments in the database.
	*/
	public ResultSet listAllDepartments() {

		//Declare and define fields list to retrieve from the department table
		String fields = "*";

		//Declare and define table where selection is performed
		String table = "department";

		//Return the ResultSet containing all products in the database
		return myDBConn.doSelect(fields, table);
	}

	/*******
		modifyDepartment method
			Modifies an existing department in the database 
			@parameters:
				oldDepartmentName: the department selected to be modified,
				newDepartmentName: the new department name specified by the administrator
			@returns:
				A boolean value if the department has been modified.
	*/
	public boolean modifyDepartment(String oldDepartmentName, String newDepartmentName) {

		//Declare and definge boolean res
		boolean res = false;

		//Try to modify department in database
		try {

			//Define the table and fields to update
			String table = "department";
			String setClause = "dept_name = '" + newDepartmentName + "'";
	
			//Define the where clause to identify the department to be modified
			String whereClause = "dept_name = '" + oldDepartmentName + "'";
	
			//Perform the update using the doUpdate method with 3 parameters, if insertion is succesful res is true
			res = myDBConn.doUpdate(table, setClause, whereClause);
			
			//If true department is succesfully updated, else department doesnt exist 
			if (res) {
				System.out.println("Department details updated successfully for department: " + oldDepartmentName);
			} else {
				System.out.println("No department found with name: " + oldDepartmentName);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		//Return true or false
		return res;
	}
	
	/*******
		addDepartment method
			Adds a new department in the database
			@parameters:
				dept_name: the department's name
			@returns:
				A boolean value if the department has been inserted into the database.
	*/
	public boolean addDepartment(String dept_name)
	{

		//Declare boolean res
		boolean res;

		//Declare function variables
		String table, values;

		//Define table where selection is performed
		table="department";
		
		//Define values to be inserted
		values="'"+ dept_name+"'";

		//Perform insertion using the doInsert method
		res=myDBConn.doInsert(table, values);

		System.out.println("Insertion result: " + res);

		//Returns true or false
		return res;
	}

	/*******
		modifyProduct method
			modifies the product's name, description, dept_name, dueDate, and image
			@parameters:
				productId: the product's ID,
				newproductName: the products name,
				newDescription: product's description,
				newDeptnName: the department which the product belongs,
				newBid: the product's bid,
				newDueDate: the product's bid due date,
				newImage: the product's image
			@returns:
				A boolean: True, product has been succesfully modified, error has ocurred.
	*/
	public boolean modifyProduct(int productId, String newProductName, String newDescription, String newDeptName, String newBid, String newDueDate, String newImage) {
		boolean res = false;
		try {
			// Declate and define the table and fields to update
			String table = "product";
			String setClause = "productName = '" + newProductName + "', " +
							   "description = '" + newDescription + "', " +
							   "dept_name = '" + newDeptName + "', " +
							   "dueDate = '" + newDueDate + "', " +
							   "image = '" + newImage + "'";
			
			//Delcare and define the where clause to identify the product to be modified
			String whereClause = "productID = " + productId ;
			
			//Perform the update using the doUpdate method with 3 parameters
			res = myDBConn.doUpdate(table, setClause, whereClause);
			
			//If true, the product has been succesfully updated, else the productId doesnt exist.
			if (res) {
				System.out.println("Product details updated successfully for product ID: " + productId);
			} else {
				System.out.println("No product found with ID: " + productId);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//Return boolean value true, product has been succesfully modified, error has ocurred.
		return res;
	}

	/*******
		modifyBid method
			modifies the product's bid in the database
			@parameters:
				productId: the product's ID,
				newBid: the new product's Bid
			@returns:
				A boolean if the products bid was updated to a new bid in the database
	*/
	public boolean modifyBid(String productId, String newBid) {

		//Declare and define boolean res
		boolean res = false;

		//try to modify bid
		try {

			//Declare and define the table and fields to update
			String table = "product";
			String setClause = "bid = " + newBid;
			
			// Define the where clause to identify the product to be modified
			String whereClause = "ProductID= '" + productId + "'";
			
			//Perform the update using the doUpdate method with 3 parameters
			res = myDBConn.doUpdate(table, setClause, whereClause);
			
			//if true bid is successfully updated, else bid wasn't updated
			if (res) {
				System.out.println("Bid updated successfully for product: " + productId);
			} else {
				System.out.println("No product found with ID: " + productId);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		//Returns true or false
		return res;
	}

	/*******
		listProductsInDepartment method
			List all departments in the database
			@parameters:
				deptName: the department's name
			@returns:
				A ResultSet containing all products in a specific department in the database
	*/
	public ResultSet listProductsInDepartment(String deptName) {

		//Declare and define fields list to retrieve from the product table
		String fields = "*";

		//Declare and define table where selection is performed
		String table = "product";

		// Define the where clause to select products based on the provided department name
		String whereClause = "dept_name = '" + deptName + "'";

		//Return the ResultSet containing all products in a specific department in the database
		return myDBConn.doSelect(fields, table, whereClause);
	}

	/*******
    bidProduct method
        Adds a bid for a product in the bid table
        @parameters:
            userName: the username of the bidder,
            bidValue: the bid value,
            productId: the ID of the product being bid on
        @returns:
            A boolean value indicating whether the bid was successfully added.
*/
public boolean bidProduct(String bid, String userName, String productId) {
    boolean res = false;
    try {
        // Define table where insertion is performed
        String table = "bid";
        
        // Define values to be inserted, ensuring string values are properly enclosed in single quotes
        String values = "'" + bid + "', '" + userName + "', '" + productId + "', " + "DEFAULT";
        
        // Perform insertion using the doInsert method
        res = myDBConn.doInsert(table, values);
        
        // Output insertion result
        if (res) {
            System.out.println("Bid added successfully for product ID: " + productId);
        } else {
            System.out.println("Failed to add bid for product ID: " + productId);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return res;
}

/*******
    getRoles method
        Retrieves all roles from the database
        @parameters:
        @returns:
            A ResultSet containing all roles in the database.
*/
public ResultSet getRoles() {

    // Declare and define fields list to retrieve from the roles table
    String fields = "*";

    // Declare and define the table where selection is performed
    String table = "role"; // Assuming the roles table is named "roles"

    // Return the ResultSet containing all roles in the database
    return myDBConn.doSelect(fields, table);
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

	/***********
		Debugging method
			This method creates an applicationDBManager object, retrieves all departments in the database, and close the connection to the database
			@parameters:
				args[]: String array 
			@returns:
	
	public static void main(String[] args)
	{
		
		try{
			//Create a applicationDBManager object
			applicationDBManager appDBMnger = new applicationDBManager();
			System.out.println("Connecting...");
			System.out.println(appDBMnger.toString());
			
			//Call the listAllDepartment in order to retrieve all departments in the database
			ResultSet res=appDBMnger.listAllDepartment();
			
			//Iterate over the ResulSet containing all departments in the database, and count how many tuples were retrieved
			int count=0;
			while (res.next()){
				System.out.println(res.getString(1));
				count++;	
			}
			//Print the results count
			System.out.println("Count:"  + count);
			
			//Close the ResulSet
			res.close();
			//Close the database connection
			appDBMnger.close();
			
		} catch(Exception e)
		{
			//Nothing to show!
			e.printStackTrace();
		}		
	}*/
}