<%@ page language='java' contentType='text/html;charset=UTF-8'%>
<%@ page import="java.sql.*"%>
<%@ page import = "conexion.*" %>

<jsp:useBean id="dbConn" scope="request" class="conexion.conexionOracle"/>

<%
// Jsp que conecta con BBDD Oracle y muestra por pantalla los registros que existen en la tabla "carto.t_web_sitar_noticias"
// @documento: consultaOracle.jsp
// @author: Maria TENA AINA
// @fecha: Diciembre 2011
    Connection conn=null;//Objeto para la conexi�n a la BD
    Statement stmt=null;//Objeto para la ejecucion de sentencias
    ResultSet rs=null;//Objeto para guardar los resultados
		try {
		//Nos conectamos a la BD
		conn=dbConn.getConnection();
		//Creamos una sentencia a partir de la conexi�n, que refleje cambios y solo de lectura
		stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
		//Seleccionamos la tabla
		rs=stmt.executeQuery("SELECT * FROM carto.t_web_sitar_noticias");
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

    

