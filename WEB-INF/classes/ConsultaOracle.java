import javax.servlet.*;
import javax.sql.DataSource;
import javax.servlet.http.*;
import javax.sql.*;
import javax.naming.*;
import java.io.*;
import java.sql.*;

import org.apache.commons.dbcp.BasicDataSource;

/**
* @file ConsultaOracle.java
* @author Maria TENA AINA
* @version 1.4
* @date 
* @description Clase que conecta con BBDD Oracle y hace una consulta a una Tabla de dicha BBDD con Pool de Conexiones
*/


// Para compilar esta clase hace falta:
//  commons-pool-1.4.jar
//  commons-dbcp-1.3.jar
//  j2ee.jar (for the javax.sql classes)


public class ConsultaOracle extends HttpServlet {

  private DataSource ds = null;
  
	public void init(ServletConfig config) throws ServletException {
    
    try {
      // recuperamos el contexto inicial y la referencia a la fuente de datos
      Context ctx = new InitialContext();
      ds = (DataSource) ctx.lookup("java:comp/env/jdbc/conexOracleBoz");
    }
    
		catch (Exception e) {
      throw new ServletException("Imposible recuperar jdbc/conexOracleBoz",e);
    }
		  
	}

  public void doGet(HttpServletRequest req, HttpServletResponse res)
    throws ServletException, IOException {

		//DataSource dataSource = setupDataSource();
		Connection conexion = null; //Objeto para la conexión a la BD
    Statement sentencia = null; //Objeto para la ejecutar una sentencia
    ResultSet resultados = null;//Objeto para guardar los resultados
    
    //La salida será una página HTML
    res.setContentType("text/html");
    PrintWriter out = res.getWriter();
		
    try {
				//Nos conectamos a la BD
				conexion = ds.getConnection();
				//Creamos una sentencia a partir de la conexión, que refleje cambios y que sea solo lectura.
				sentencia=conexion.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
				
			  //Cogemos todos los datos de la tabla
			  String tabla = req.getParameter("tabla");
				resultados=sentencia.executeQuery("SELECT * FROM " + tabla);
			  //Escribimos la cabecera de la página
				out.println("<html>\n <body>");
        //Mostramos las distintas noticias
				while(resultados.next()) { 
									out.println(resultados.getString("contenido")+"<br>");
									}//Fin while
	
				//Escribimos el final de la página
				out.println("</body>");
				out.println("</html>");

	} catch (SQLException e1) {
				out.println("Fallo en SQL: "+e1.getMessage());
	
				} 

	finally {
		try {
			if (conexion!=null)
				conexion.close();
		} catch (SQLException e2) {
		out.println("Fallo al desconectar SQL: "+e2.getMessage());
		}
		try {
			if (sentencia!=null)
				sentencia.close();
		} catch (SQLException e3) {
		out.println("Fallo al cerrar sentencia SQL: "+e3.getMessage());
		}
		try {
			if (resultados!=null)
				resultados.close();
		} catch (SQLException e4) {
		out.println("Fallo al cerrar resultados SQL: "+e4.getMessage());
		}
	}

  }//fin método doGet

  public void doPost(HttpServletRequest req, HttpServletResponse res)
    throws ServletException, IOException {
    doGet(req, res);
  }
}


