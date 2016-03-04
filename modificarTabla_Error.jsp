<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
// Jsp que devuelve un error si falta algún parámetro en "modificarTabla_Chequeo.jsp" o "modificarTabla_Entidades.jsp"
// @documento: modificarTabla_Error.jsp
// @author: Maria TENA AINA
// @fecha: Octubre 2012
%>
<html>
  <head>
    <title></title>
  </head>
	<body>
  <%
  String error=request.getParameter("Error");
	out.println("ERROR: " + error);
  %>
  </body>
</html>
