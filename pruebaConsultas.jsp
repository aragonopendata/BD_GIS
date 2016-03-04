<%@page language='java' contentType='text/html;charset=iso-8859-1'%>
<%@page import="java.util.*,java.io.*,java.lang.*,java.sql.*"%>
<%@page import="javax.servlet.*,javax.sql.DataSource,javax.servlet.http.*"%>

<%@page import="org.apache.commons.dbcp.BasicDataSource"%>

    
   <jsp:forward page="consultaOracle">
      <jsp:param name="tabla" value="carto.t_web_sitar_noticias"/>                
   </jsp:forward>
    
        
    

