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
// Jsp que conecta con BBDD Oracle y añade registros en la tabla "carto.t08_cambios_entidades" 
// con los datos que recibe como parametros desde "modificarTabla_Chequeo.jsp"
// @documento: modificarTabla_Entidades.jsp
// @author: Maria TENA AINA
// @fecha: Octubre 2012

    String usuario=request.getParameter("usuario");
    String campo=request.getParameter("campo");
    String propuesta=request.getParameter("propuesta"); 
    String motivo=request.getParameter("motivo");
		
		Calendar c = new GregorianCalendar(); 
		String fecha = Integer.toString(c.get(Calendar.YEAR))+"/"+Integer.toString(c.get(Calendar.MONTH)+1)+"/"+Integer.toString(c.get(Calendar.DATE));
		
		String registroAdd=null;
		
		Connection conn = null;//Objeto para la conexión a la BD
    Statement stmt = null;//Objeto para la ejecucion de sentencias
    ResultSet rs = null;//Objeto para guardar los resultados
		try {
		//Nos conectamos a la BD
		conn=dbConn.getConnection();
    //Creamos una sentencia a partir de la conexión, que refleje cambios y que permita escribir
		stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		//Seleccionamos la tabla
		rs = stmt.executeQuery("SELECT * FROM carto.t08_cambios_entidades ORDER BY OBJECTID");
			if (rs.next()){
			  //Buscamos ultimo ID de la tabla
				rs.last();
				String registro=rs.getString("OBJECTID").trim();//Quitamos espacios en blanco
				int registroInt=Integer.parseInt(registro) + 1;//Pasamos a integral para sumarle 1
				registroAdd=Integer.toString(registroInt);//Lo pasamos otra vez a String
		  }else{
				registroAdd="1";
			}
		//Insertamos datos propuestos para cambio
		int datos=stmt.executeUpdate("INSERT INTO carto.t08_cambios_entidades (OBJECTID,USUARIO,"+campo+",MOTIVO_CAMBIO,F_PROPUESTA) VALUES ('"+registroAdd+"','"+usuario+"','"+propuesta+"','"+motivo+"','"+fecha+"')");
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
	  	}	try {
		  	if (rs!=null)
		     	 rs.close();
	  	} catch (SQLException e4) {
	    	out.println("Fallo al cerrar resultados SQL: "+e4.getMessage());
	  	}
	  }
%>
</body>
</html>