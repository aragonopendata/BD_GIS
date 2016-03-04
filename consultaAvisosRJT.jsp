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
// Jsp que conecta con BBDD Oracle y muestra por pantalla los Avisos que existen en la tabla "carto.t_web_sitar_noticias"
// @documento: consultaAvisos.jsp
// @author: Maria TENA AINA
// @fecha: Diciembre 2011
    Connection conn=null;//Objeto para la conexión a la BD
    Statement stmt=null;//Objeto para la ejecucion de sentencias
    ResultSet rs=null;//Objeto para guardar los resultados
		try {
		//Nos conectamos a la BD
		conn=dbConn.getConnection();
		//Creamos una sentencia a partir de la conexión, que refleje cambios y solo de lectura
		stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
		//Seleccionamos la tabla
		rs=stmt.executeQuery("select * from carto.t_web_rjt_noticias where tipo='Aviso' and fechabaja = 99999999");
		 while (rs.next()){
			          out.println(rs.getString("contenido")+"<br>");
			      }
						rs.close();
		 } catch (SQLException e1) {
			out.println("Fallo en SQL: "+e1.getMessage());
		} finally {
		  try {
			  if (conn!=null)
				   conn.close();
	    } catch (SQLException e2) {
	     	out.println("Fallo al desconectar SQL: "+e2.getMessage());
	    } try {
		  	if (stmt!=null)
			     stmt.close();
	  	} catch (SQLException e3) {
		    out.println("Fallo al cerrar sentencia SQL: "+e3.getMessage());
	  	}	
	  }
%>

</body>
</html>