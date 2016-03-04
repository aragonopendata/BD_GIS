<%@page trimDirectiveWhitespaces="true" language='java'%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="sun.misc.BASE64Encoder"%>
<%
   int maxMemSize = 5000 * 1024;


   // Verify the content type
   String contentType = request.getContentType();
   if ((contentType.indexOf("multipart/form-data") >= 0)) {

      DiskFileItemFactory factory = new DiskFileItemFactory();
      // maximum size that will be stored in memory
      factory.setSizeThreshold(maxMemSize);
 
      // Create a new file upload handler
      ServletFileUpload upload = new ServletFileUpload(factory);

      try{ 
         // Parse the request to get file items.
         List fileItems = upload.parseRequest(request);

         // Process the uploaded file items
         Iterator i = fileItems.iterator();

		BASE64Encoder encoder = new BASE64Encoder();
         while ( i.hasNext () ) 
         {
            FileItem fi = (FileItem)i.next();
            if ( !fi.isFormField () )	
            {
				String name = fi.getName();
				int pos = name.lastIndexOf(".");
				byte[] imageBytes = fi.get();
				out.println("data:image/"+name.substring(pos+1)+";base64,"+encoder.encode(imageBytes));
            }
         }
        
      }catch(Exception ex) {
         System.out.println(ex);
		 out.println("ERROR");
      }
   }else{
      out.println("<html>");
      out.println("<head>");
      out.println("<title>Servlet upload</title>");  
      out.println("</head>");
      out.println("<body>");
      out.println("<p>No file readed</p>"); 
      out.println("</body>");
      out.println("</html>");
   }
%>