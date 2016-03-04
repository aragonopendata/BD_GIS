<%@ page language='java' contentType='text/html;charset=UTF-8'%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.*"%>
<%@ page import = "conexion.*" %>
 <html>
<body>
<jsp:useBean id="dbConn" class="conexion.conexionOracle" scope="request"/>
<%
// Jsp que conecta con BBDD Oracle y registra una consulta de informacion
// @documento: registraBusqueda.jsp
// @author: Idearium Consultores
// @fecha: Septiembre 2014

		String literal = request.getParameter("literal");
		String objectid = request.getParameter("objectid");
		String type = request.getParameter("type");
		String app = request.getParameter("app");
		
		Calendar c = new GregorianCalendar(); 
		String mes = Integer.toString(c.get(Calendar.MONTH)+1);
		if (mes.length()<2){
			mes = "0"+mes;
		}
		String dia = Integer.toString(c.get(Calendar.DATE));
		if (dia.length()<2){
			dia = "0"+dia;
		}
		String fecha = Integer.toString(c.get(Calendar.YEAR))+"/"+mes+"/"+dia;
		
		Connection conn=null;//Objeto para la conexión a la BD
    Statement stmt=null;//Objeto para la ejecucion de sentencias
		try {
		
				    String ip = request.getHeader("X-Forwarded-For");  
            if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
                ip = request.getHeader("Proxy-Client-IP");  
            }  
            if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
                ip = request.getHeader("WL-Proxy-Client-IP");  
            }  
            if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
                ip = request.getHeader("HTTP_CLIENT_IP");  
            }  
            if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
                ip = request.getHeader("HTTP_X_FORWARDED_FOR");  
            }  
            if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
                ip = request.getRemoteAddr();  
            }  
			
				//Nos conectamos a la BD
			conn=dbConn.getConnection();
			stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);

				//Insertamos datos propuestos para cambio
				//out.println("INSERT INTO carto.log_busq_eleccion(literal, objectid, type, timestamp, app,ip) VALUES ('"+literal+"','"+objectid+"','"+type+"','"+fecha+"','"+app+"','"+ip+"')");
			int datos=stmt.executeUpdate("INSERT INTO carto.log_busq_eleccion(literal, objectid, type, timestamp, app,ip) VALUES ('"+literal+"','"+objectid+"','"+type+"','"+fecha+"','"+app+"','"+ip+"')");
		
		} catch (SQLException e1) {
			out.println("Fallo en SQL: "+e1.getMessage());
		} finally {
			try {
				  if (conn!=null)
					   conn.close();
			} catch (SQLException e2) {
				out.println("Fallo al desconectar SQL: "+e2.getMessage());
			} catch (NullPointerException e2) {
				out.println("Fallo null2 SQL: "+e2.getMessage());
			} 
			try {
				if (stmt!=null) 			
					 stmt.close();
			} catch (SQLException e3) {
				out.println("Fallo al cerrar sentencia SQL: "+e3.getMessage());
			} catch (NullPointerException e3) {
				out.println("Fallo null3 SQL: "+e3.getMessage());
			}
		}
%>
</body>
</html>
