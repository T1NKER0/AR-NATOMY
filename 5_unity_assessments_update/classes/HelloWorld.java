// Import required java libraries

import java.io.*;
//JAVA version >-10
//javax -> jakarta
import jakarta.servlet.*;

import jakarta.servlet.http.*;

// Extend HttpServlet class

public class HelloWorld extends HttpServlet {
  private String message;

  private String title;

  public void init() throws ServletException {

     // Do required initialization

     message = "este .java se compila -> se convierte en.class -> el .class se llama en el servlet registration en web.xml";

  title = "my first servlet";

  }
  
      public void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
         // Set response content type

         response.setContentType("text/html");
 
         // Actual logic goes here.

         PrintWriter out = response.getWriter();

         out.println("<html><head><title>" + title + "</title></head>");

		out.println("<body><h1>" + message + "</h1></body>");

		out.println("</html>");

      }

      public void destroy() {

         // do nothing.

      }

    }





  