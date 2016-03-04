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
* Clase que conecta con BBDD Oracle en Sita 2 y hace una consulta a una Tabla de dicha BBDD con Pool de Conexiones
* @file conexionOracleDes.java
* @author Maria TENA AINA
* @version 1.4
* @date Junio 2013
*/

public class conexionOracleDes {

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

          DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/conexOracleSita");

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


