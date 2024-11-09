import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;
import ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete; // Import the custom authentication class
import java.sql.ResultSet;
import java.sql.SQLException;

public class AssessmentVisibilityServlet extends HttpServlet {
    private applicationDBAuthenticationGoodComplete dbConnection;

    @Override
    public void init() throws ServletException {
        // Initialize the database connection object
        dbConnection = new applicationDBAuthenticationGoodComplete();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("application/json");
    PrintWriter out = response.getWriter();

    try {
        // Fetch visibility statuses from the database
        // Process the results and extract visibility values
        boolean isHeartVisible = false;
        boolean isRespiratoryVisible = false;
        boolean isGastrointestinalVisible = false;

        ResultSet heartResult = dbConnection.getAssessmentVisibility(1); // For Heart Assessment
        // Process the heartResult
        if (heartResult.next()) {
            isHeartVisible = heartResult.getBoolean("isVisible");
            System.out.println("Heart Assessment visibility: " + isHeartVisible);
        } else {
            System.out.println("No data for Heart Assessment");
        }

        ResultSet respiratoryResult = dbConnection.getAssessmentVisibility(2); // For Respiratory Assessment
        // Process the respiratoryResult
        if (respiratoryResult.next()) {
            isRespiratoryVisible = respiratoryResult.getBoolean("isVisible");
            System.out.println("Respiratory Assessment visibility: " + isRespiratoryVisible);
        } else {
            System.out.println("No data for Respiratory Assessment");
        } 

        ResultSet gastrointestinalResult = dbConnection.getAssessmentVisibility(3); // For Gastrointestinal Assessment
        // Process the gastrointestinalResult
        if (gastrointestinalResult.next()) {
            isGastrointestinalVisible = gastrointestinalResult.getBoolean("isVisible");
            System.out.println("Gastrointestinal Assessment visibility: " + isGastrointestinalVisible);
        } else {
            System.out.println("No data for Gastrointestinal Assessment");
        } 

        // Construct the response JSON
        JSONObject jsonResponse = new JSONObject();
        JSONArray assessmentsArray = new JSONArray();

        JSONObject heartAssessment = new JSONObject();
        heartAssessment.put("assessment", "Heart Assessment");
        heartAssessment.put("isVisible", isHeartVisible);
        assessmentsArray.put(heartAssessment);
        System.out.println("Heart Assessment JSON: " + heartAssessment.toString());

        JSONObject respiratoryAssessment = new JSONObject();
        respiratoryAssessment.put("assessment", "Respiratory System Assessment");
        respiratoryAssessment.put("isVisible", isRespiratoryVisible);
        assessmentsArray.put(respiratoryAssessment);
        System.out.println("Respiratory Assessment JSON: " + respiratoryAssessment.toString());

        JSONObject gastrointestinalAssessment = new JSONObject();
        gastrointestinalAssessment.put("assessment", "Gastrointestinal System Assessment");
        gastrointestinalAssessment.put("isVisible", isGastrointestinalVisible);
        assessmentsArray.put(gastrointestinalAssessment);
        System.out.println("Gastrointestinal Assessment JSON: " + gastrointestinalAssessment.toString());

        jsonResponse.put("assessments", assessmentsArray);
        jsonResponse.put("status", "success");

        // Debug: Log the final JSON response
        System.out.println("Final JSON Response: " + jsonResponse.toString());
        out.println(jsonResponse.toString());

    } catch (SQLException e) {
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
    } catch (JSONException e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        JSONObject errorResponse = new JSONObject();
        try {
            errorResponse.put("status", "error");
            errorResponse.put("message", "JSON formatting error");
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
