import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.json.*;
import ut.JAR.CPEN410.*;
import java.sql.ResultSet;
import java.sql.SQLException;


import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.json.*;

public class getDataBaseJson extends HttpServlet {
    
    public void init() throws ServletException {
        // Do required initialization
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
        this.doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JSONObject jsonResult = new JSONObject();
        try {
            jsonResult.put("tables", fetchTablesFromDatabase());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        PrintWriter out = response.getWriter();
        out.println(jsonResult.toString());
    }

    private JSONArray fetchTablesFromDatabase() {
        applicationDBManager dbManager = new applicationDBManager();
        return dbManager.showTables(); // Directly use the JSONArray returned by showTables()
    }

    public void destroy() {
        // do nothing.
    }
}
