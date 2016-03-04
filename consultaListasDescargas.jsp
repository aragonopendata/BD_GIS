<%@page language='java' contentType='text/html;charset=UTF-8'%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.net.*"%>
<%@ page import = "conexion.*" %>

<html>
<body>
<jsp:useBean id="dbConn" class="conexion.conexionOracle" scope="request"/>
<%
// Jsp que muestra las listas desplegables de la aplicación de descargas
// @documento: consultaListasDescargas.jsp
// @author: idearium consultroes
// @fecha: Septiembre 2013



    Connection conn=null;//Objeto para la conexión a la BD
    Statement stmt=null;//Objeto para la ejecucion de sentencias
    ResultSet rs=null;//Objeto para guardar los resultados
	try {
		//Nos conectamos a la BD
		conn=dbConn.getConnection();
		//Creamos una sentencia a partir de la conexión, que refleje cambios y solo de lectura
		stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
		//Seleccionamos la tabla
		rs=stmt.executeQuery("select * from carto.t_listas_descargas ORDER BY lista,orden");
		String ultima_lista="";
		while (rs.next()){
			if (!rs.getString("lista").equalsIgnoreCase(ultima_lista)){
				if (!ultima_lista.equals("")){
					out.println("</select>");
				}
				ultima_lista = rs.getString("lista");
				out.println("<select id=\""+ultima_lista+"\">");
			}
			out.println("<option value=\""+rs.getString("id")+"\">"+rs.getString("valor")+"</option>");
		}
		out.println("</select>");
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
	  
	URL url = new URL("http://sitar.aragon.es/BD_GIS/consultaColecciones.jsp");
	HttpURLConnection connection = (HttpURLConnection)url.openConnection();
	connection.setRequestMethod("GET");
	connection.setConnectTimeout(5000);
	try{
			//read the result from the server
			BufferedReader rd  = new BufferedReader(new InputStreamReader(connection.getInputStream(),"UTF-8"));
			out.println("<select id=\"coleccion\">");
			String line;
			while ((line = rd.readLine()) != null){
				line = line.trim();
				if ((!line.startsWith("<"))&&(line.length()>0)){
					out.println(line+";"/*+"md/1_Productos/Internos/Cartografia/1990-2008/CartografiaVectorial1000.xml"*/);
				}
			}
			out.println("</select>");
	}
	catch(SocketTimeoutException ex){
	}
	connection.disconnect();

%>
</body>
</html>