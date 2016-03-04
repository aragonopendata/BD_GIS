<%@ page language='java' contentType='text/html;charset=UTF-8'%>
<%@ page import="java.util.*, java.io.*, java.lang.*, java.sql.*, conexion.*" %>
 <html>
<body>
<jsp:useBean id="dbConn" class="conexion.conexionOracle" scope="request"/>
<%
// Jsp que conecta con BBDD Oracle y comprueba que existe el usuario en la tabla "carto.usuarios"
// y que la clave es correcta
// @documento: check.jsp
// @author: Idearium Consultores (a partir de versión previa de Maria TENA AINA)
// @fecha: Mayo 2013

    String usuario=request.getParameter("us").trim();//Quitamos espacios en blanco 
    String passw=request.getParameter("cl").trim();//Quitamos espacios en blanco
		
    boolean usuarioIn=false;
		boolean identidad=false;	
		
		Connection conn=null;//Objeto para la conexión a la BD
    Statement stmt=null;//Objeto para la ejecucion de sentencias
    ResultSet rs=null;//Objeto para guardar los resultados
	
		String encriptado="";
    String clavebdcif = "";
		String usuariobd = "";
		try {
		//Nos conectamos a la BD
		conn=dbConn.getConnection();
		//Creamos una sentencia a partir de la conexión, que refleje cambios y solo de lectura
		stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
		//Seleccionamos la tabla usuarios para comprobar clave
		rs=stmt.executeQuery("SELECT * FROM carto.usuarios");
		 //Comprobamos identificacion de usuario
		 while (!identidad && rs.next()){
				    usuariobd=rs.getString("USUARIO");
						String clavebd=rs.getString("CLAVE");
						clavebdcif=rs.getString("CLAVECIF");
						if (usuario.equalsIgnoreCase(usuariobd)) {usuarioIn=true;}
						if (passw.equals(clavebd)) {identidad=true;}
	    }
			rs.close();
			
			if (clavebdcif == null) {
				String clave = "1729301sszz";
				String texto =  new String(passw);
				int tamtext=texto.length();
				int tamclav=clave.length();
				int temp,p=0;
				
					// Se crea un array de enteros que contendran los numeros que corresponde a los caracteres en Ascii de los String Texto y la Clave
				int textoAscii[]= new int[tamtext];
				int claveAscii[]= new int[tamclav];

					// Se guardan los caracteres de cada String en numeros correspondientes al Ascii
				for(int i=0;i<tamtext;i++)
					textoAscii[i] = texto.charAt(i);

				for(int i=0;i<tamclav;i++)
					claveAscii[i] = clave.charAt(i);

					//Se procede al ENCRIPTADO
				for(int i=0;i<18;i++){
					p++;

					if(p >= tamclav)
						p=0;

					temp =(textoAscii[i%tamtext]+claveAscii[p])%24;
	/*
					 if (temp > 255)
					 temp=temp-255;
	*/

						//65 es el ascii de la A
					encriptado = encriptado + (char)(temp+65);
				}
				int datos=stmt.executeUpdate("UPDATE carto.usuarios SET CLAVECIF = '"+encriptado+"' WHERE USUARIO = '"+usuariobd+"'");
				clavebdcif = encriptado;
			}
			
			//Si la identificacion es correcta admitimos la propuesta de cambios
			if (usuarioIn && identidad) {
				out.println("OK;"+clavebdcif);
			} else {
					// prevencion ante ataques masivos, dormir un segundo
				Thread.sleep(500);
				out.println("-1");
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