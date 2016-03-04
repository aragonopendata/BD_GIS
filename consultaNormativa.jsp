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
// Jsp que construye el html indicado de acuerdo a la informacion almacenada en base de datos
// @documento: consultaNormativa.jsp
// @author: idearium consultroes
// @fecha: Noviembre 2013

	String html = request.getParameter("html").trim();
	String tipo = html.substring(0, html.indexOf("/"));
	String tema = html.substring( html.indexOf("/")+1).replaceAll(".html", "");
	String fecha = request.getParameter("fecha");


    Connection conn=null;//Objeto para la conexión a la BD
    Statement stmt=null;//Objeto para la ejecucion de sentencias
    ResultSet rs=null;//Objeto para guardar los resultados
	try {
		//Nos conectamos a la BD
		conn=dbConn.getConnection();
		//Creamos una sentencia a partir de la conexión, que refleje cambios y solo de lectura
		stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
		String fecha_cond="";
		if (fecha !=null){
			fecha_cond = " AND "+fecha+" < fechabaja AND "+fecha+" > fechaalta";
		}
				//Seleccionamos la tabla
				rs=stmt.executeQuery("select normativa.CATEGO,DESCRIP,PUBLICACION,URL,TOOLTIP,NUM_CAT from carto.normativa ," +
					"carto.vista_normativa" +
					" where lower(normativa.tipo)=lower('"+tipo+"') and lower(normativa.tema)=lower('"+tema+
					"')  and vista_normativa.tipo=normativa.tipo and vista_normativa.tema =normativa.tema and vista_normativa.catego=normativa.catego "+fecha_cond+" order by id");
					//out.println("<html><head><link href=\"../../page.css\" rel=\"StyleSheet\" type=\"text/css\"></head>");
					out.println("<link href=\"../../page.css\" rel=\"StyleSheet\" type=\"text/css\">");
		
			if (tipo.equalsIgnoreCase("General")){
				out.println("<table cellpadding=\"2\" cellspacing=\"0\" cols=\"4\">");
				out.println("<tbody>");
				String categoria_anterior=null;
				String par_impar="impar";

				while ( rs.next() )
				{
					String categoria = rs.getString("CATEGO");
					
					if ((categoria_anterior ==null)||(!categoria.equalsIgnoreCase(categoria_anterior))){
						if (categoria_anterior != null){
							out.println("<tr>");
							out.println("<td colspan=\"4\">");
							out.println("	&nbsp;");
							out.println("</td>");
							out.println("</tr>");
						}
						categoria_anterior = categoria;
						out.println("<tr>");
						out.println("  <td class=\"itemBig\" rowspan=\""+rs.getObject("NUM_CAT")+"\" align=\"center\" width=\"100\">");
						out.println(categoria);
						out.println("</td>");
						par_impar="impar";
					}
					else{
						out.println("<tr>");
						par_impar = (par_impar.equalsIgnoreCase("impar")?"par":"impar");
					}
					out.println("<td class=\"item "+par_impar+"\">");
					out.println(rs.getString("DESCRIP")+"</td>");
					out.println("<td class=\"item "+par_impar+"\">");
					out.println(rs.getString("publicacion")+"</td>");
					
					out.println("<td class=\"item "+par_impar+"\" align=\"center\">");
					out.println("		<a target=\"_blank\" class=\"item\" href=\""+
							rs.getString("URL")
							+"\" title=\""+rs.getString("TOOLTIP")+"\"><img src=\"i/ico_link.png\" border=\"0\"/></a>");
					out.println("	</td>");
					out.println("	</tr>");


				}

			}
			else if (tipo.equalsIgnoreCase("Especifica")){
				String categoria_anterior=null;
				boolean derecha = false;
				String par_impar="impar";
				boolean cerrar_tabla = false;
				while(rs.next()){
					String categoria = rs.getString("CATEGO");
					if (categoria.startsWith("Apunte")||categoria.startsWith("Enlace")){
						derecha = true;
					}

					if (!derecha){
						if((categoria_anterior ==null)||(!categoria.equalsIgnoreCase(categoria_anterior))){
							
							if (categoria_anterior==null){
								out.println("<table cellpadding=\"2\" cellspacing=\"0\" cols=\"5\"><tbody>");
							}
							else{
								out.println("<tr><td colspan=\"4\">&nbsp;</td></tr>");
							}
							categoria_anterior=categoria;
							out.println("<tr><td class=\"itemBig\" width=\"100\" align=\"center\" rowspan=\""+rs.getObject("NUM_CAT")+"\">");
							
							out.println(categoria+"</td>");
							par_impar="impar";
							cerrar_tabla = true;
						}
						else{
							out.println("<tr>");
							par_impar = (par_impar.equalsIgnoreCase("impar")?"par":"impar");
						}
						out.println("<td class=\"item "+par_impar+"\" colspan=\"3\">");
						out.println(rs.getString("DESCRIP"));
						out.println("</td>");
						String publicacion = rs.getString("publicacion");
						if (publicacion != null){
							out.println("<td class=\"item "+par_impar+"\">");
							out.println(publicacion);
							out.println("</td>");
						}
						String url = rs.getString("URL");
						if (url != null){
							out.println("<td class=\"item "+par_impar+"\" align=\"center\">");
							out.println("<a target=\"_blank\" class=\"item\" title=\""+rs.getString("TOOLTIP")+"\" href=\""+url+
							"\"><img style=\"border: 0px solid ; width: 15px; height: 15px;\" src=\"i/ico_link.png\" /></a></td>");
						}
						out.println("</tr>");
					}
					else{ //terminos de la derecha
						if (cerrar_tabla){
							out.println("</tbody></table>");							
						}

						out.println("<table cellpadding=\"5\" cellspacing=\"0\" width=\"100%\" style=\"table-layout:fixed;\" cols=\"4\"><tbody>");
						out.println("	<tr>");
						out.println("<td colspan=\"3\" align=\"right\" class=\"item\">");
						out.println(categoria);
						out.println("</td>");
						out.println("<td align=\"center\" width=\"20px\">");
						out.println("<a target=\"_blank\" class=\"item\" href=\""+
								rs.getString("URL")+"\" title=\""+rs.getString("TOOLTIP")+"\"><img src=\"i/ico_link.png\" border=\"0\" /></a>");
						out.println("</td>");
						out.println("</tr>");
						cerrar_tabla = true;
					}

				}
			}
			else{
				//otroslinks
				out.println("<table width=\"100%\" cellpadding=\"5\" cellspacing=\"0\">");
				out.println("<tbody>");
				
				while(rs.next()){
					out.println("<tr>");
					out.println("<td align=\"right\" class=\"item\">");
					out.println(rs.getString("CATEGO"));
					out.println("</td>");
					out.println("<td align=\"left\" style=\"vertical-align:top\">");
					out.println("	<a target=\"_blank\" class=\"item\" href=\""+rs.getString("URL")+
							"\" title=\""+rs.getString("TOOLTIP")+"\"><img src=\"i/ico_link.png\" border=\"0\" /></a>");
					out.println("	</td>");
					out.println("</tr>");
				}
			}
			out.println("</tbody></table>");
			//out.println("</body></html>");

			rs.close();
	 } catch (SQLException e1) {
			e1.printStackTrace();
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