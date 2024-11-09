import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.json.JSONObject; // JSON library for formatting JSON responses
import ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete; // Import the custom authentication class
import java.sql.ResultSet;
import java.sql.SQLException;

public class sessionServlet extends HttpServlet {
    private applicationDBAuthenticationGoodComplete auth;

    @Override
    public void init() throws ServletException {
        // Initialize the authentication object
        auth = new applicationDBAuthenticationGoodComplete();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve parameters from the request
        String username = request.getParameter("user");
        String password = request.getParameter("pass");

        // Set response content type to JSON
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        // Create a JSON object for the response
        JSONObject jsonResponse = new JSONObject();

        // Call the authenticate method and get the ResultSet
        ResultSet authResult = auth.authenticate(username, password);
        try {
            if (authResult != null && authResult.next()) {
                // If user is authenticated successfully
                jsonResponse.put("status", "success");
                jsonResponse.put("name", authResult.getString("Name"));
                jsonResponse.put("userName", authResult.getString("userName"));
                jsonResponse.put("roleId", authResult.getString("roleId"));
                response.setStatus(HttpServletResponse.SC_OK); // HTTP status for success
            } else {
                // If authentication fails
                jsonResponse.put("status", "failure");
                jsonResponse.put("message", "Invalid credentials");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // HTTP status for unauthorized
            }
        } catch (SQLException e) {
            //jsonResponse.put("status", "error");
            //jsonResponse.put("message", "Database error");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // HTTP status for server error
            e.printStackTrace(); // Log exception for debugging
        } catch (Exception e) {
            //jsonResponse.put("status", "error");
            //jsonResponse.put("message", "Internal server error");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // HTTP status for server error
            e.printStackTrace(); // Log exception for debugging
        } finally {
            out.println(jsonResponse.toString());
            out.close(); // Always close the PrintWriter
        }
    }

    @Override
    public void destroy() {
        auth = null; // Cleanup the authentication object
    }
}
