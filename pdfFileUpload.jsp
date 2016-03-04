<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
   int maxMemSize = 5000 * 1024;
	String filePath = "D:\\Arcims\\Website\\MSD_new\\memorias\\";
	int fileMaxSize = 10*1024*1024;
//out.setCharacterEncoding("UTF-8");

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


         while ( i.hasNext () ) 
         {
            FileItem fi = (FileItem)i.next();
            if ( !fi.isFormField () )	
            {
            String fileName = fi.getName();
	if (!fileName.trim().toLowerCase().endsWith(".pdf")){
	throw new Exception("El archivo debe ser un PDF ("+fileName+")");
	}
            long sizeInBytes = fi.getSize();
			if (sizeInBytes > fileMaxSize){
			throw new Exception("El archivo es demasiado grande ("+sizeInBytes+" bytes). El tamaño máximo soportado es 10MB");
			}
            // Write the file
			String fullFilePath=null;
            if( fileName.lastIndexOf("\\") >= 0 ){
           fullFilePath = filePath + 
            fileName.substring( fileName.lastIndexOf("\\"));
            }else{
             fullFilePath =  filePath + 
            fileName.substring(fileName.lastIndexOf("\\")+1) ;
            }
			 File file = new File(fullFilePath);
            fi.write( file ) ;
          
            }
         }
        
      }catch(Exception ex) {
         System.out.println(ex);
		 out.println("ERROR:"+ex.getMessage());
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
