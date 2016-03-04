package conexion;

import javax.servlet.*;
import javax.sql.DataSource;
import javax.servlet.http.*;
import javax.sql.*;
import javax.naming.*;
import java.io.*;
import java.sql.*;
import java.sql.Connection;


/**
* Clase que conecta con BBDD Oracle y hace una consulta a una Tabla de dicha BBDD con Pool de Conexiones
* @author Maria TENA AINA
* @version 1.4
*/

public class conexionOracle {

    public static Connection getConnection() throws Exception
    {
          return getPooledConnection();
    }

    public static Connection getPooledConnection() throws Exception{
       Connection conn = null;

        try{
          Context ctx = new InitialContext();
          if(ctx == null )
              throw new Exception("No Context");

          DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/conexOracleBoz");

          if (ds != null) {
             conn = ds.getConnection();
            return conn;
          }else{
              return null;
          }

        }catch(Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}


