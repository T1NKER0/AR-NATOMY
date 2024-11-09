// Source code is decompiled from a .class file using FernFlower decompiler.
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete;

public class AssessmentUpdateStatusServlet extends HttpServlet {
   private applicationDBAuthenticationGoodComplete dbConnection;

   public AssessmentUpdateStatusServlet() {
   }

   public void init() throws ServletException {
      this.dbConnection = new applicationDBAuthenticationGoodComplete();
   }

   protected void doPost(HttpServletRequest var1, HttpServletResponse var2) throws ServletException, IOException {
      var2.setContentType("application/json");
      PrintWriter var3 = var2.getWriter();

      try {
         boolean var4 = var1.getParameter("button1") != null;
         boolean var25 = var1.getParameter("button2") != null;
         boolean var6 = var1.getParameter("button3") != null;
         byte var7 = 1;
         byte var8 = 2;
         byte var9 = 3;
         boolean var10 = this.updateAssessmentVisibility(var7, var4);
         boolean var11 = this.updateAssessmentVisibility(var8, var25);
         boolean var12 = this.updateAssessmentVisibility(var9, var6);
         JSONObject var13 = new JSONObject();
         if (var10 && var11 && var12) {
            var13.put("status", "success");
         } else {
            var13.put("status", "failure");
         }

         JSONArray var14 = new JSONArray();
         JSONObject var15 = new JSONObject();
         var15.put("assessment", "Heart Assessment");
         var15.put("isVisible", var4);
         var14.put(var15);
         JSONObject var16 = new JSONObject();
         var16.put("assessment", "Respiratory System Assessment");
         var16.put("isVisible", var25);
         var14.put(var16);
         JSONObject var17 = new JSONObject();
         var17.put("assessment", "Gastrointestinal System Assessment");
         var17.put("isVisible", var6);
         var14.put(var17);
         var13.put("assessments", var14);
         var3.println(var13.toString());
      } catch (JSONException var23) {
         var2.setStatus(500);
         JSONObject var5 = new JSONObject();

         try {
            var5.put("status", "error");
            var5.put("message", "JSON formatting error");
         } catch (JSONException var22) {
            var3.println("{\"status\":\"error\",\"message\":\"Severe JSON error\"}");
         }

         var3.println(var5.toString());
         var23.printStackTrace();
      } finally {
         var3.close();
      }

   }

   private boolean updateAssessmentVisibility(int var1, boolean var2) {
      return this.dbConnection.updateAssessmentVisibility(var1, var2);
   }

   protected void doGet(HttpServletRequest var1, HttpServletResponse var2) throws ServletException, IOException {
      var2.setContentType("application/json");
      PrintWriter var3 = var2.getWriter();
      JSONObject var4 = new JSONObject();
      var3.println(var4.toString());
      var3.close();
   }
}
