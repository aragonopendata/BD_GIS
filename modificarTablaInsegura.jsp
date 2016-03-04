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
		String motivo=request.getParameter("motivo");
		
		//Variables que recogeran la propuesta de cambios 
		String nombre_p=request.getParameter("nombre_p").trim();//Quitamos espacios en blanco
		String xutm_p=request.getParameter("xutm_p").trim();//Quitamos espacios en blanco
		String yutm_p=request.getParameter("yutm_p").trim();//Quitamos espacios en blanco
		String cmunine_p=request.getParameter("cmunine_p").trim();//Quitamos espacios en blanco
		String observac_p=request.getParameter("observac_p").trim();//Quitamos espacios en blanco
		String id_p=request.getParameter("id_p").trim();//Quitamos espacios en blanco
		
		//Variables que recogeran los datos originales
		String fuente=request.getParameter("fuente").trim();//Quitamos espacios en blanco
		String nombre=request.getParameter("nombre").trim();//Quitamos espacios en blanco
		String xutm=request.getParameter("xutm").trim();//Quitamos espacios en blanco
		String yutm=request.getParameter("yutm").trim();//Quitamos espacios en blanco
		String cmunine=request.getParameter("cmunine").trim();//Quitamos espacios en blanco
		String observacio=request.getParameter("observacio").trim();//Quitamos espacios en blanco
		String organismo=request.getParameter("organismo").trim();//Quitamos espacios en blanco
		String id=request.getParameter("id").trim();//Quitamos espacios en blanco
		
		Calendar c = new GregorianCalendar(); 
		String fecha = Integer.toString(c.get(Calendar.YEAR))+"/"+Integer.toString(c.get(Calendar.MONTH)+1)+"/"+Integer.toString(c.get(Calendar.DATE));
		
		String registroAdd=null;
		
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
		/*
		//Seleccionamos la tabla usuarios para comprobar clave
		rs=stmt.executeQuery("SELECT * FROM carto.usuarios");
		 //Comprobamos identificacion de usuario
		 while (!identidad && rs.next()){
				    String usuariobd=rs.getString("USUARIO");
						String clavebd=rs.getString("CLAVE");
						if (usuario.equalsIgnoreCase(usuariobd)) {usuarioIn=true;}
						if (clave.equals(clavebd)) {identidad=true;}
	    }
			rs.close();
			*/
				//hacemos que siempre la dé por válida
			usuarioIn=true;
			identidad=true;

			//Si la identificacion es correcta admitimos la propuesta de cambios
			if (usuarioIn && identidad) {
				//Seleccionamos la tabla cambios para registrar propuesta de cambios
				rs = stmt.executeQuery("SELECT * FROM carto.t08_cambios_sinlogin ORDER BY OBJECTID");
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
				int datos=stmt.executeUpdate("INSERT INTO carto.t08_cambios_sinlogin (OBJECTID,CMUNINE_P,NOMBRE_P,OBSERVAC_P,XUTM_P,YUTM_P,MOTIVO_CAM,USUARIO,CLAVE,F_PROPUEST,IDENTIDAD_P) VALUES ('"+registroAdd+"','"+cmunine_p+"','"+nombre_p+"','"+observac_p+"',"+xutm_p+","+yutm_p+",'"+motivo+"','"+usuario+"','"+clave+"','"+fecha+"','"+id_p+"')");
			  datos=stmt.executeUpdate("UPDATE carto.t08_cambios_sinlogin SET FUENTE = '"+fuente+"' WHERE OBJECTID = '"+registroAdd+"'");
				datos=stmt.executeUpdate("UPDATE carto.t08_cambios_sinlogin SET NOMBRE = '"+nombre+"' WHERE OBJECTID = '"+registroAdd+"'");
				datos=stmt.executeUpdate("UPDATE carto.t08_cambios_sinlogin SET XUTM = "+xutm+" WHERE OBJECTID = '"+registroAdd+"'");
				datos=stmt.executeUpdate("UPDATE carto.t08_cambios_sinlogin SET YUTM = "+yutm+" WHERE OBJECTID = '"+registroAdd+"'");
				datos=stmt.executeUpdate("UPDATE carto.t08_cambios_sinlogin SET CMUNINE = '"+cmunine+"' WHERE OBJECTID = '"+registroAdd+"'");
				datos=stmt.executeUpdate("UPDATE carto.t08_cambios_sinlogin SET OBSERVACIO = '"+observacio+"' WHERE OBJECTID = '"+registroAdd+"'");
				datos=stmt.executeUpdate("UPDATE carto.t08_cambios_sinlogin SET IDENTIDAD = '"+id+"' WHERE OBJECTID = '"+registroAdd+"'");
				datos=stmt.executeUpdate("UPDATE carto.t08_cambios_sinlogin SET ORGANISMO = '"+organismo+"' WHERE OBJECTID = '"+registroAdd+"'");
			  rs.close();
			}
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