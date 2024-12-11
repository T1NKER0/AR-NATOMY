// Import required java libraries
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.*;
import org.json.*;
import ut.JAR.CPEN410.*;
import java.sql.*;

/***
	This servlet generates a JSON object and sent it the a web browser when required
*/

// Extend HttpServlet class
public class getSpecificProductJSON extends HttpServlet {
 
   //Product list (ArrayList)
   //private ArrayList<productClass> products;
   
   //Servlet initialization
   public void init() throws ServletException {
      // Do required initialization
         }

	public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
	
		this.doPost(request, response);
	  }

	/* doGet Method
		Generates a JSON object containg a JSON Array list
	*/
   public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
	
      String productId = request.getParameter("productId");
		JSONObject jsonResult = createJSon(productId);
      
      // Actual logic goes here.
      PrintWriter out = response.getWriter();
	  
	  // Set response content type
	  response.setContentType("application/json");
	  response.setCharacterEncoding("UTF-8");
      //Send the response
	  out.println(jsonResult.toString());
	}

   public void destroy() {
      // do nothing.
   }
   
   /*
		This method creates a JSONObject
   */ 
   public JSONObject createJSon(String productId)
   {
	   //Create the JSONObject
	   JSONObject json = new JSONObject();

      applicationDBManager appDBMg = new applicationDBManager();

	   try{

         ResultSet res = appDBMg.getProductId(productId);

         if (res.next()){
            //Add the appropriate data to the object
            json.put("Product ID", res.getString(1));
            json.put("Product Name", res.getString(2));
            json.put("Description", res.getString(3));
            json.put("Department", res.getString(4));
            json.put("Bid", res.getString(5));
            json.put("Due-Date", res.getString(6));
            json.put("Seller", res.getString(7));
            json.put("Image", res.getString(8));
         }
         appDBMg.close();
         res.close();
	   } catch(Exception e){
		   e.printStackTrace();
	   }finally{
		   //return the JSONObject
		   return json;
	   }
   }
}
