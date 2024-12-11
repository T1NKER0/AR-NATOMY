import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.json.JSONObject;
import org.json.JSONException;
import ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete; // Import the custom authentication class
import java.sql.SQLException;

public class UploadGradeServlet extends HttpServlet {
    private applicationDBAuthenticationGoodComplete dbConnection;

    @Override
    public void init() throws ServletException {
        // Initialize the database connection object
        dbConnection = new applicationDBAuthenticationGoodComplete();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            // Read the request body
            StringBuilder jsonInput = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonInput.append(line);
            }

            // Parse the JSON input
            JSONObject inputJson = new JSONObject(jsonInput.toString());
            String username = inputJson.getString("username");
            String assessmentName = inputJson.getString("assessmentName");
            float grade = (float) inputJson.getDouble("grade");
            String dateTaken = inputJson.getString("dateTaken");

            // Debugging: Log received data
            System.out.println("Received data:");
            System.out.println("Username: " + username);
            System.out.println("Assessment: " + assessmentName);
            System.out.println("Grade: " + grade);
            System.out.println("Date Taken: " + dateTaken);

            // Call the addAssessment method
            boolean success = dbConnection.addAssessment(username, grade, dateTaken, assessmentName);

            // Create the JSON response
            JSONObject jsonResponse = new JSONObject();
            if (success) {
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "Assessment added successfully.");
                System.out.println("Assessment added successfully.");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Failed to add assessment.");
                System.out.println("Failed to add assessment.");
            }
            out.println(jsonResponse.toString());

        } catch (JSONException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JSONObject errorResponse = new JSONObject();
            try {
                errorResponse.put("status", "error");
                errorResponse.put("message", "Invalid JSON format: " + e.getMessage());
            } catch (JSONException jsonEx) {
                out.println("{\"status\":\"error\",\"message\":\"Severe JSON error\"}");
            }
            out.println(errorResponse.toString());
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JSONObject errorResponse = new JSONObject();
            try {
                errorResponse.put("status", "error");
                errorResponse.put("message", "Database error: " + e.getMessage());
            } catch (JSONException jsonEx) {
                out.println("{\"status\":\"error\",\"message\":\"Severe JSON error\"}");
            }
            out.println(errorResponse.toString());
            e.printStackTrace();
        } finally {
            out.close();
        }
    }
}
