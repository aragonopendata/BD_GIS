<%@ page language='java' contentType='text/html;charset=UTF-8'%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.xml.parsers.*"%>
<%@ page import="org.w3c.dom.*"%>
<%@ page import = "conexion.*" %>

<jsp:useBean id="dbConn" scope="request" class="conexion.conexionOracle"/>

<%
// Jsp que conecta con BBDD Oracle y muestra por pantalla los registros que existen en la tabla "wms_base.t_web_sitar_noticias"
// @documento: consultaOracle.jsp
// @author: Maria TENA AINA
// @fecha: Diciembre 2011
Connection conn=null;//Objeto para la conexión a la BD
Statement stmt=null;//Objeto para la ejecucion de sentencias
ResultSet rs=null;//Objeto para guardar los resultados

	
		
		
	String codtema_rq=request.getParameter("CODTEMA");
	String codmap=request.getParameter("CODMAP");

	String tempo=request.getParameter("TEMPO");
String codmun=request.getParameter("CODMUN");
String bbox=request.getParameter("BBOX");
String width=request.getParameter("WIDTH");
String height=request.getParameter("HEIGHT");
String layers=request.getParameter("LAYERS");
if ((bbox != null)&&(bbox.length()>0) &&(height != null)&&(height.length()>0) &&(width != null)&&(width.length()>0) &&(layers != null)&&(layers.length()>0)){ // ArcXML
String arcxml_request ="";
String sb ="";
try{

	StringTokenizer token = new StringTokenizer(bbox,",");
String capa = layers.substring(0,layers.lastIndexOf("_"));
String arcxml_query="TEMPO="+layers.substring(layers.lastIndexOf("_")+1); 
 arcxml_request ="<ARCXML version=\"1.1\">"+
										"<REQUEST>"+
									"<GET_IMAGE>"+
									"<PROPERTIES>"+
									"<ENVELOPE minx=\""+token.nextToken().trim()+"\" miny=\""+token.nextToken().trim()+"\" maxx=\""+token.nextToken().trim()+"\" maxy=\""+token.nextToken().trim()+"\"/>"+
									"<IMAGESIZE height=\""+height+"\" width=\""+width+"\"/>"+
									"<LAYERLIST>\""+
									"<LAYERDEF id=\""+capa+"\" visible=\"true\" > <QUERY where=\""+arcxml_query+"\" ></QUERY> </LAYERDEF>"+
									"</LAYERLIST>"+	
				"</PROPERTIES>"+				
									"</GET_IMAGE>"+
									"</REQUEST>"+
									"</ARCXML>";
			//out.println(arcxml_request);
			URL url = new URL("http://idearagon.aragon.es/servlet/com.esri.esrimap.Esrimap?ServiceName=SITA&Form=False&ClientVersion=4.0");
			HttpURLConnection connection = (HttpURLConnection)url.openConnection();
			connection.setRequestMethod("POST");
			connection.setDoOutput(true);
			connection.setRequestProperty("Content-Type", "text/xml"); 
			connection.setRequestProperty("charset", "utf-8");
			connection.setRequestProperty("Content-Length", "" + Integer.toString(arcxml_request.getBytes().length));
			connection.connect();
			OutputStreamWriter wr = new OutputStreamWriter(connection.getOutputStream());
			wr.write(arcxml_request);
			wr.flush();

			//read the result from the server
			BufferedReader rd  = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			
			String line;
			while ((line = rd.readLine()) != null)
			{
				sb+=line + '\n';
			}

			//System.out.println(sb.toString());
			connection.disconnect();
		}
		catch(MalformedURLException ex){
			out.println("Error en la consulta "+arcxml_request);
		}
		catch(java.net.SocketTimeoutException ex){
			out.println("Tiempo máximo de respuesta agotado "+arcxml_request);
		}
		catch(IOException ex){
			out.println("Error en la consulta "+arcxml_request);
		}
			try{
			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(new ByteArrayInputStream(sb.getBytes()));
			doc.getDocumentElement().normalize();
			URL url = new URL(((Element)doc.getElementsByTagName("OUTPUT").item(0)).getAttribute("url"));
			//out.println(url);
			
			
			        

			
			
		ByteArrayOutputStream bis = new ByteArrayOutputStream();
InputStream input = null;
response.setContentType("image/png"); 
 
  input = url.openStream ();
  byte[] bytebuff = new byte[4096]; 
  int n;

  while ( (n = input.read(bytebuff)) > 0 ) {
    bis.write(bytebuff, 0, n);
  }
 
byte[] imagen = bis.toByteArray();
response.setContentLength(imagen.length);
 OutputStream output = response.getOutputStream();
output.write(imagen);
	 output.close();		
		}
		catch (Exception ex){
			out.println("Error al procesar el resultado de ArcIMS ");
			
		}
}
else{
try {
//Nos conectamos a la BD
	conn=dbConn.getConnection();
	//Creamos una sentencia a partir de la conexión, que refleje cambios y solo de lectura
	stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//Seleccionamos la tabla
	if (/*(codtema !=null)&&(codtema.length()>0)&&*/(codmap !=null)&&(codmap.length()>0)){ 
		int idx = codmap.indexOf("_");
		String codtema = codmap.substring(0,idx);
		codmap = codmap.substring(idx+1);
		/*out.println("tema:"+codtema);
		out.println("map:"+codmap);*/
		if ((tempo !=null)&&(tempo.length()>0)){ //valores
		// fecha
		String cond_mun="";
		if ((codmun !=null)&&(codmun.length()>0)){
				cond_mun = " AND codmun IN ("+codmun+")";
			}
			String  query = "(SELECT codmun,valor FROM wms_base.PROAPP1_IAESMAP_MAP_VALORES where codtema='"+codtema+"' AND  codmap='"+codmap+"' AND  tempo="+tempo+cond_mun+") UNION "+
			"(SELECT codmun,valor FROM carto.VALORES where codtema='"+codtema+"' AND  codmap='"+codmap+"' AND  tempo="+tempo+cond_mun+")";
			
			rs=stmt.executeQuery(query);
			out.println("{\"valores\":[");	
			if (rs.next()){
				out.println("{\"codmun\":\""+rs.getString("codmun")+"\",");	
				out.println("\"valor\":"+rs.getDouble("valor")+"}");	
			}		
			while (rs.next()){
				out.println(",{\"codmun\":\""+rs.getString("codmun")+"\",");	
				out.println("\"valor\":"+rs.getDouble("valor")+"}");	
			}
			out.println("]}");
		
		}
		else{
		// fecha
			rs=stmt.executeQuery("select * from ((SELECT distinct tempo FROM wms_base.PROAPP1_IAESMAP_MAP_VALORES where codtema='"+codtema+"' AND  codmap='"+codmap+"' ) UNION "+
			"(SELECT distinct tempo FROM carto.VALORES where codtema='"+codtema+"' AND  codmap='"+codmap+"' )) order by tempo");
			out.println("{\"fechas\":[");	
			if (rs.next()){
				out.println(rs.getString("tempo"));	
			}		
			while (rs.next()){
				out.println(","+rs.getString("tempo"));	
			}
			out.println("]}");
		}
	}
	else if ((codtema_rq !=null)&&(codtema_rq.length()>0)){ // devolver el tema correspondiente
	rs=stmt.executeQuery("SELECT t.tema FROM carto.SITA t where t.codtema='"+codtema_rq+"'");
		if (rs.next()){
		out.println(new Integer(rs.getString("tema"))-1);
		}
	
	}
	else{  //temas, indicadores y unidades (no devolvemos los del nivel de Aragón)
		rs=stmt.executeQuery("SELECT * FROM ((SELECT m.codtema, m.codmap, m.titulo, m.unidad, m.url_info, m.fuente, m.metodo_div,t.tema,substr(m.titulo,1,instr(m.titulo,'.',-2)+1) as orden FROM wms_base.PROAPP1_IAESMAP_MAP_MAPAS m,  carto.SITA t where t.codtema=m.codtema and t.codmap=m.codmap and m.codmap not like '%A') "+
		" UNION (SELECT m.codtema, m.codmap, m.titulo, m.unidad, m.url_info, m.fuente, m.metodo_div,t.tema,substr(m.titulo,1,instr(m.titulo,'.',-2)+1) as orden FROM carto.MAPAS m,  carto.SITA t where t.codtema=m.codtema and t.codmap=m.codmap and m.codmap not like '%A'))"+
		" order by tema, substr(titulo,1,instr(titulo,'.',-2)+1),codmap,codtema");
		//rs=stmt.executeQuery("SELECT m.*,t.tema,substr(m.titulo,1,instr(m.titulo,'.',-2)+1) as orden FROM carto.MAPAS m,  carto.SITA t where t.codtema=m.codtema and t.codmap=m.codmap and m.codmap not like '%A' order by tema, substr(m.titulo,1,instr(m.titulo,'.',-2)+1),m.codmap,m.codtema");
		
		ArrayList temas = new ArrayList();
		ArrayList indicadores = new ArrayList();
	
		out.println("{\"temas\":[");		
		boolean primero = true;
		while (rs.next()){
	//	out.println("***"+rs.getString("titulo"));
			String titulo = rs.getString("titulo");
			//out.println("****"+titulo);
			int idx = titulo.lastIndexOf(".");
			if (idx == titulo.length() -1){
				idx = titulo.substring(0,idx).lastIndexOf(".");
				//out.println("****"+idx);
			}
			/*if (idx <0){
			idx=0;
			}*/
			String nombreInd = titulo.substring(0,idx);
			String nombreEsq = titulo.substring(idx+1);
			
			String codTema = rs.getString("codtema");
			int tema = new Integer(rs.getString("tema"))-1;
			String[] temas_names = new String[]{"Poblaci&#243;n", "Econom&#237;a", "Territorio", "Accesibilidad"};
			if (temas.indexOf(tema)<0){
				if (temas.size()>0){
					out.println("]}]},");
				}
				temas.add(tema);
			    out.println("{\"codTema\":\""+tema+"\",");
				out.println("\"nomTema\":\""+temas_names[tema]+"\",");
				out.println("\"indicadores\":[");
				indicadores = new ArrayList();
			}
			
			String codMap = codTema+"_"+rs.getString("codMap");
			String codEsquema = codMap.substring(codMap.length() -1);
			String codInd = codMap.substring(0,codMap.length() -1);
			if (indicadores.indexOf(codInd)<0){
				if (indicadores.size()>0){
					out.println("]},");
				}
				indicadores.add(codInd);
				out.println("{\"codInd\":\""+codInd+"\",");
				out.println("\"nomInd\":\""+nombreInd+"\",");
				
				out.println("\"esquemas\":[");
			}
			else if (indicadores.indexOf(codInd)!= indicadores.size()-1){
			out.println("************ERROR*********Indicador con distinto título para los distintos esquemas: "+codInd);
			return;
			
			}
			else{
			out.println(",");
			}
			out.println("{\"codEsq\":\""+codEsquema+"\",");
			out.println("\"nomEsq\":\""+nombreEsq+"\",");
			out.println("\"unidad\":\""+rs.getString("unidad")+"\",");
			out.println("\"titulo\":\""+titulo+"\",");
			out.println("\"url\":\""+rs.getString("url_info")+"\",");
			out.println("\"fuente\":\""+rs.getString("fuente")+"\"");
			
			 out.println("}");
			 
	    }
		 out.println("]}]}]}");
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
}	  
%>

    

