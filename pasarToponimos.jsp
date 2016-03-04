<%@page language='java' contentType='text/html;charset=UTF-8'%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.*"%>
<%@page import = "conexion.*" %>
<html>
<body>
<jsp:useBean id="dbConn" class="conexion.conexionOracle" scope="request"/>
<%
// Jsp que conecta con BBDD Oracle y llama a la funcion "carto.f_fonetica" 
// que devuelve la cadena fonética de un texto pasado como variable desde "pasarToponimos_Formulario.jsp"
// @documento: pasarToponimos.jsp
// @author: Maria TENA AINA
// @fecha: Octubre 2012

    String texto=request.getParameter("texto").trim();//Quitamos espacios en blanco
    String toponimo=null;		
    Connection conn = null;//Objeto para la conexión a la BD
    Statement stmt = null;//Objeto para la ejecucion de sentencias
    ResultSet rs = null;//Objeto para guardar los resultados
		try {
			//Nos conectamos a la BD
			conn=dbConn.getConnection();
			//Creamos una sentencia a partir de la conexión, que refleje cambios y que sea solo lectura
			stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			//Pasamos la variable a la funcion para ejecutarla
			rs = stmt.executeQuery("SELECT carto.f_fonetica('"+texto+"') FROM DUAL");
			//Recuperamos el toponimo devuelto por la función
			if (rs.next()){
				toponimo = rs.getString(1);
			}else{
			out.println("-1 ESCRIBE OTRO TEXTO");
		  }
			out.println(toponimo);
		} catch (SQLException e1) {
			out.println("-1 Fallo en SQL: "+e1.getMessage());
		} finally {
		  try {
			  if (conn!=null)
				   conn.close();
	    } catch (SQLException e2) {
	     	out.println(" "+e2.getMessage());
	    } catch (NullPointerException e2) {
	     	out.println("");
			}	try {
		  	if (stmt!=null)
			     stmt.close();
	  	} catch (SQLException e3) {
		    out.println("-1 Fallo al cerrar sentencia SQL: "+e3.getMessage());
	  	}	catch (NullPointerException e3) {
	     	out.println("");
			}	try {
		  	if (rs!=null)
		     	 rs.close();
	  	} catch (SQLException e4) {
	    	out.println("-1 Fallo al cerrar resultados SQL: "+e4.getMessage());
	  	} catch (NullPointerException e4) {
	     	out.println("");
			}
	  }
%>
</body>
</html>