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
	String[] numeros=request.getParameter("codigos").split(",");
	String[] esquemas=request.getParameter("esquemas").split(",");
		try {
		//Nos conectamos a la BD
		conn=dbConn.getConnection();
		//Creamos una sentencia a partir de la conexión, que refleje cambios y solo de lectura
		stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
		//Seleccionamos la tabla
		//SELECT FROM T01_Productos WHERE Esquema = 'Comarca' and Id='10' and Coleccion = 'Cartografia' ORDER BY Descripcion
		String conditions ="esquema='aragon'";
		for (int i=0; i<esquemas.length;i++){
			conditions = conditions+ " OR "+"(id='"+numeros[i]+"' AND esquema='"+esquemas[i]+"')";
		}
		rs=stmt.executeQuery("SELECT distinct coleccion FROM carto.T01_Productos where "+conditions);
	/*	rs=stmt.executeQuery("SELECT distinct id,coleccion,esquema,descripcion "+
		"FROM carto.T01_Productos p, carto.t01_coleccion c where c."+conditions+" ORDER BY esquema");*/
		 while (rs.next()){
			      out.println(
						//rs.getString("coleccion")+";"+
						//rs.getString("id")+";");
						rs.getString("coleccion")/*+"-"+rs.getString("id")+"-"+rs.getString("descripcion")+"\n"*/+";");
			      }
						rs.close();
		rs=stmt.executeQuery("SELECT distinct coleccion FROM carto.T01_DIT where "+conditions);
	
		 while (rs.next()){
			      out.println(
						
						rs.getString("coleccion")/*+"-"+rs.getString("id")+"-"+rs.getString("descripcion")+"\n"*/+";");
			      }
						rs.close();
		 } catch (SQLException e1) {
		 e1.printStackTrace();
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
