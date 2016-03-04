<%@ page language='java' contentType='text/html;charset=UTF-8'%>
<%@ page import="java.util.*, java.io.*, java.lang.*, java.sql.*, conexion.*" %>
<html>
	<body>
		<jsp:useBean id="dbConn" class="conexion.conexionOracle" scope="request"/>
<%
		// Jsp que conecta con BBDD Oracle y muestra por pantalla los registros para hacer botones dinámicos en la home SITAR
		// @documento: BotonesHomeSITAR.jsp
		// @author: Idearium Consultores
		// @fecha: Mayo de 2013
	Connection conn = null; //Objeto para la conexión a la BD
	Statement stmt = null; //Objeto para la ejecucion de sentencias
	ResultSet rs = null; //Objeto para guardar los resultados
	String idioma=request.getParameter("lang");
	if ((idioma == null)||(idioma.length() <=0)){
		idioma = "es";
	}
	//out.println(idioma);
	try {
			//Nos conectamos a la BD
		conn=dbConn.getConnection();

			//Creamos una sentencia a partir de la conexión, que refleje cambios y solo de lectura
		stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);

			//Seleccionamos la tabla
rs=stmt.executeQuery("SELECT orden, path_"+idioma+" as path,url_"+idioma+" as url,text_"+idioma+" as text,falta,fbaja,esquema FROM carto.t_web_sitar_botones");
//rs=stmt.executeQuery("SELECT * FROM carto.BOTONESWEB");

		while (rs.next()){
			out.println(rs.getString("orden") + ";" +rs.getString("path") + ";" +
			rs.getString("url") + ";" +
			rs.getString("text") + "<br>");
		}
		rs.close();
	} catch (SQLException e1) {
		out.println("Fallo en SQL: " + e1.getMessage());
	} finally {
		try {
			if (conn != null) {
				conn.close();
			}
		} catch (SQLException e2) {
			out.println("Fallo al desconectar SQL: " + e2.getMessage());
		}
		try {
			if (stmt != null) {
				stmt.close();
			}
		} catch (SQLException e3) {
			out.println("Fallo al cerrar sentencia SQL: " + e3.getMessage());
		}
	}
%>
	</body>
</html>
