<%@ page language='java' contentType='text/html;charset=UTF-8'%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@ page import = "conexion.*" %>
 <html>
<body>
<jsp:useBean id="dbConn" class="conexion.conexionOracle" scope="request"/>
<%
// Jsp que comprueba fecha actual
// @documento: comprobarFecha.jsp
// @author: Maria TENA AINA
// @fecha: junio 2013
  
		
		Calendar c = new GregorianCalendar(); 
		//int mes = c.get(Calendar.MONTH)+1;
		
		String fecha = Integer.toString(c.get(Calendar.YEAR))+"/"+Integer.toString(c.get(Calendar.MONTH)+1)+"/"+Integer.toString(c.get(Calendar.DATE));
		out.println(fecha);
		
%>
</body>
</html>