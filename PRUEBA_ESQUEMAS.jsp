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
// Jsp que conecta con BBDD Oracle y muestra por pantalla los registros que existen en la tabla "carto.t01_productos"
// @documento: EsquemaAragon.jsp
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
		//rs=stmt.executeQuery("SELECT path,coleccion,name,fecha,escala,tam_pixel,descargas,tamano,descripcion FROM carto.t01_productos where esquema = 'aragon' ORDER BY coleccion,name");
			rs = stmt.executeQuery("SELECT a.path,a.coleccion,a.name,a.fecha,a.escala,a.tam_pixel,a.descargas,a.tamano,a.descripcion, b.categoria, b.tipo, b.fecha_m, b.fecha_i, b.licencia, b.idioma, b.descrip, a.etiqueta, b.fecha_i, b.calidad, b.organismo, b.url_org, b.frecuencia, b.cobertura, a.detalle, b.diccionario FROM carto.t01_productos A,carto.t01_coleccion B  where (A.ESQUEMA = 'provincia' OR A.esquema = 'aragon') AND a.coleccion=b.coleccion ORDER BY A.coleccion,A.name"); 
		
		while (rs.next()){
			          out.println(rs.getString("esquema")+";"+
														rs.getString("coleccion")+";"+
	//													rs.getString("name")+";"+
	//													rs.getString("fecha")+";"+
	//													rs.getString("escala")+";"+
	//													rs.getString("tam_pixel")+";"+
	//													rs.getString("descargas")+";"+
	//													rs.getString("tamano")+";"+
														rs.getString("descripcion")+"<br>");
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
