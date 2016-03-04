<%@ page trimDirectiveWhitespaces="true" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%

String nombreFichero = "rdfsGenerados.rdf";

String fileRdf = (String) session.getAttribute("fichero_en_sesion");

javax.servlet.ServletOutputStream servletoutputstream = response.getOutputStream();
response.setHeader("Content-Disposition", (new StringBuffer()).append("attachment; filename=\"").append(nombreFichero).append("\"").toString());
response.setContentType("application/rdf+xml, charset=UTF-8");

response.setContentLength(fileRdf.getBytes().length);
servletoutputstream.write(fileRdf.getBytes());
servletoutputstream.flush();


out.clear();
out = pageContext.pushBody(); 

%>
	  
</body>
</html>