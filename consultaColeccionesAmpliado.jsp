<%@ page language='java' contentType='text/html;charset=UTF-8'%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.*"%>
<%@ page import = "conexion.*" %>
 
 <html>
 		<body>
		       
			 <!-- Creamos un bean a la clase que hace la conexion con la BD -->
			 <jsp:useBean id="dbConn" class="conexion.conexionOracle" scope="request"/>
			 <!-- Llamamos al metodo que ejecuta la consulta -->
			
<%
// Jsp que conecta con BBDD Oracle y muestra por pantalla los datos que existen en la tabla "carto.t01_colecciones"
// @documento: consultaColecciones.jsp
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
		rs=stmt.executeQuery("SELECT * FROM carto.t01_coleccion ORDER BY orden");
		 while (rs.next()){
			      out.println(rs.getString("tabla_origen")+";"+
						rs.getString("orden")+";"+rs.getString("tipo")+";"+
						rs.getString("coleccion")+";"+
						rs.getString("elementos")+";"+
						rs.getString("esnovedad")+";"+
						rs.getString("descrip")+";"+
						rs.getString("fecha")+";"+
						rs.getString("fecha_ini")+";"+
						rs.getString("fecha_fin")+";"+
						rs.getString("url_meta")+";"+
						rs.getString("lex")+";"+
						rs.getString("keyword")+";"+
						rs.getString("vista_origen")+";"+
						rs.getString("esquema")+";");
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
