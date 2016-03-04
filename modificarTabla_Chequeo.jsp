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
// Jsp que conecta con BBDD Oracle y comprueba que existe el usuario en la tabla "carto.usuarios"
// y que la clave es correcta, recibe los parametros desde "insertarDatos_Formulario.jsp"
// Si la identificacion es correcta llama a "modificarTabla_Entidades.jsp"
// @documento: modificarTabla_Chequeo.jsp
// @author: Maria TENA AINA
// @fecha: Octubre 2012

    String usuario=request.getParameter("usuario").trim();//Quitamos espacios en blanco 
    String clave=request.getParameter("clave").trim();//Quitamos espacios en blanco
		String campo=request.getParameter("campo").trim();//Quitamos espacios en blanco
		String propuesta=request.getParameter("propuesta").trim();//Quitamos espacios en blanco
		String motivo=request.getParameter("motivo");
		
    boolean usuarioIn=false;
		boolean identidad=false;	
		
		Connection conn=null;//Objeto para la conexión a la BD
    Statement stmt=null;//Objeto para la ejecucion de sentencias
    ResultSet rs=null;//Objeto para guardar los resultados
		try {
		//Nos conectamos a la BD
		conn=dbConn.getConnection();
		//Creamos una sentencia a partir de la conexión, que refleje cambios y solo de lectura
		stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
		//Seleccionamos la tabla
		rs=stmt.executeQuery("SELECT * FROM carto.usuarios");
		 //Comprobamos identificacion de usuario
		 while (!identidad && rs.next()){
				    String usuariobd=rs.getString("USUARIO");
						String clavebd=rs.getString("CLAVE");
						if (usuario.equalsIgnoreCase(usuariobd)) {usuarioIn=true;}
						if (clave.equals(clavebd)) {identidad=true;}
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
		//Si la identificacion es correcta admitimos la propuesta de cambios
		if (usuarioIn && identidad) {
      %>
			<jsp:forward page="modificarTabla_Entidades.jsp">
			<jsp:param name="usuario" value="<%= usuario %>"/>
			<jsp:param name="campo" value="<%= campo %>"/>
			<jsp:param name="propuesta" value="<%= propuesta %>"/>
			<jsp:param name="motivo" value="<%= motivo %>"/>
			</jsp:forward>
			<%
			} else {  //Si no, lo sacamos de la aplicacion
			%>
			<jsp:forward page="modificarTabla_Error.jsp">
			<jsp:param name="Error" value="Usuario no registrado"/>                
			</jsp:forward>
			<%
		}	
%>
</body>
</html>