<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.*"%>
<%@page import = "conexion.*" %>
<%@page import="java.text.DecimalFormat"%>


<%!
public static ArrayList<String> getEnlaceAragopedia(String esquema, String dato){ //El arraylist que devuelve tiene el formato [nameAragopedia, shortUriAragopedia, typeAragopedia, uriAragopedia]
	ArrayList<String> devolver = new ArrayList<String>();
	ArrayList<String> aragon = new ArrayList<String>(Arrays.asList("Aragón", "Aragón", "Aragón", "http://opendata.aragon.es/recurso/territorio/ComunidadAutonoma/Aragón"));
	
	
	
	if (esquema.length()<=0){
		//Devolvemos todo de aragón
		return aragon;
	}
	else if (esquema==null){
		//Devolvemos todo de aragón
		return aragon;
	}
	else if (dato==null){
		//Devolvemos todo de aragón
		return aragon;
	}
	else{
		if (dato.length()<=0){
		//Devolvemos todo de aragón
		return aragon;
		}
		else{
		esquema=esquema.toLowerCase();
		if (esquema.equals("comarca")){
			ArrayList<String> comarcas = new ArrayList<String>(Arrays.asList("Alto Gállego", 
				"Andorra-Sierra de Arcos", "Aranda", "Bajo Aragón", "Bajo Aragón-Caspe/ Baix Aragó-Casp", 
				"Bajo Cinca/Baix Cinca", "Bajo Martín", "Campo de Belchite", "Campo de Borja", "Campo de Cariñena", 
				"Campo de Daroca", "Cinca Medio", "Cinco Villas", "Comunidad de Calatayud", "Comunidad de Teruel", 
				"Cuencas Mineras", "D.C. Zaragoza", "Gúdar-Javalambre", "Hoya de Huesca/Plana de Uesca", "Jiloca", 
				"La Jacetania", "La Litera/La Llitera", "La Ribagorza", "Los Monegros", "Maestrazgo", "Matarraña/Matarranya", 
				"Ribera Alta del Ebro", "Ribera Baja del Ebro", "Sierra de Albarracín", "Sobrarbe", "Somontano de Barbastro", 
				"Tarazona y el Moncayo", "Valdejalón",
				"Hoya de Huesca / Plana de Uesca", "Bajo Cinca / Baix Cinca", "La Litera / La Llitera", "Bajo Aragón-Caspe / Baix Aragó-Casp",
				"Matarraña / Matarranya"));
			if (comarcas.contains(dato)){
			if (dato.equals("Hoya de Huesca / Plana de Uesca")){
				dato = "Hoya de Huesca/Plana de Uesca";
			}
			else if (dato.equals("Bajo Cinca / Baix Cinca")){
				dato = "Bajo Cinca/Baix Cinca";
			}
			else if (dato.equals("La Litera / La Llitera")){
				dato = "La Litera/La Llitera";
			}
			else if (dato.equals("Bajo Aragón-Caspe / Baix Aragó-Casp")){
				dato = "Bajo Aragón-Caspe/ Baix Aragó-Casp";
			}
			else if (dato.equals("Matarraña / Matarranya")){
				dato = "Matarraña/Matarranya";
			}
			devolver.add(dato);
			devolver.add(dato.replace(" ", "_"));
			devolver.add("Comarca");
			devolver.add("http://opendata.aragon.es/recurso/territorio/Comarca/"+dato.replace(" ", "_"));
			}
			else {
			//Devolvemos todo de aragón
			return aragon;
			}
		}
		else if (esquema.equals("provincia")){
					
			ArrayList<String> provincias = new ArrayList<String>(Arrays.asList("Huesca", "Zaragoza", "Teruel"));
			if (provincias.contains(dato)){
			devolver.add(dato);
			devolver.add(dato);
			devolver.add("Provincia");
			devolver.add("http://opendata.aragon.es/recurso/territorio/Provincia/"+dato.replace(" ", "_"));
			}
			else{
			//Devolvemos todo de aragón
			return aragon;
			}

		}
		else{
			//Devolvemos todo de aragón
			return aragon;
		}
		}
	}
	
	return aragon;
}
	
	
public static String transformaTemporal(String fechaIGEAR){
	fechaIGEAR = fechaIGEAR.replace("-", "");
	if ((fechaIGEAR.length()<4) || (fechaIGEAR.length()>8)){
		return "";
	}
	else if (fechaIGEAR.length()==4) {
		return fechaIGEAR.substring(0, 4);
	}
	else if (fechaIGEAR.length()==6) {	
		return fechaIGEAR.substring(0, 4)+"-"+fechaIGEAR.substring(4, 6);
	}
	else if (fechaIGEAR.length()==8) {
		return fechaIGEAR.substring(0, 4)+"-"+fechaIGEAR.substring(4, 6)+"-"+fechaIGEAR.substring(6, 8);	
	}
	else {
		return "";
	}
}
%>

<!-- Creamos un bean a la clase que hace la conexion con la BD -->
<jsp:useBean id="dbConn" class="conexion.conexionOracle" scope="request"/>
<!-- Llamamos al metodo que ejecuta la consulta -->

<script language="javascript">

	function enviar(fichero){
		window.open(fichero," " ,"width= 300 ,height= 400 ");
	}

</script>

<%
	ResultSet rset;
	String title="";
	String description="";
	String accessURL;

	String fichero = "";
	String nombres="";
	String identificador = "";
	Connection conn=null;//Objeto para la conexion a la BD
	Statement stmt=null;//Objeto para la ejecucion de sentencias
	ResultSet rs=null;//Objeto para guardar los resultados
	
	
	//Esta es la lista negra con los id de dataset que no queremos que se metan
	ArrayList<String> listaNegra = new ArrayList<String>();
	listaNegra.add("cartografia-de-saneamiento-de-las-infraestructuras-del-ciclo-del-agua_vica_saneamiento");
	listaNegra.add("cartografia-de-abastecimiento-de-las-infraestructuras-del-ciclo-del-agua_vica_abastecimiento");
	
	try {
		//Nos conectamos a la BD
		conn=dbConn.getConnection();
	//Creamos una sentencia a partir de la conexión, que refleje cambios y solo de lectura
		stmt=conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		//rset = stmt.executeQuery("SELECT a.path,a.coleccion,A.name,a.fecha,a.escala,a.tam_pixel,a.descargas,a.tamano,a.descripcion, b.categoria, b.tipo, b.fecha_m, b.fecha_i, b.licencia, b.idioma, b.descrip, a.etiqueta, b.fecha_i, b.calidad, b.organismo, b.url_org, b.frecuencia, b.cobertura, a.detalle, b.diccionario FROM carto.t01_productos A,carto.t01_coleccion B  where (A.esquema= 'provincia' or A.esquema= 'aragon') AND a.coleccion=b.coleccion");

		fichero = fichero + "<rdf:RDF xmlns:foaf=\"http://xmlns.com/foaf/0.1/\" xmlns:owl=\"http://www.w3.org/2002/07/owl#\"\n" + "  xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n" + "  xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" + "  xmlns:dcat=\"http://www.w3.org/ns/dcat#\"\n" + "  xmlns:dct=\"http://purl.org/dc/terms/\">\n\n";
		
		


		//Poner aqui los distintos esquemas
		String[] esquemas = {"comarca","aragon", "provincia"};
		for (int j=0;j<=esquemas.length;j++){
			//rset = stmt.executeQuery("SELECT a.path,a.coleccion,a.name,a.fecha,a.escala,a.descargas,a.tamano,a.descripcion, b.categoria, b.tipo, b.fecha_m, b.fecha_i, b.licencia, b.idioma, b.descrip, a.etiqueta, b.calidad, b.organismo, b.url_org, b.frecuencia, b.cobertura, a.detalle, b.diccionario FROM carto.t01_productos a,carto.t01_coleccion b  where (a.esquema= '" + esquemas[j] + "' AND a.coleccion=b.coleccion)");
			//rset = stmt.executeQuery("SELECT a.path,a.coleccion,a.name,a.fecha,a.escala,a.descargas,a.tamano,a.descripcion, b.categoria, b.tipo, b.fecha_m, b.fecha_i, b.licencia, b.idioma, b.descrip, a.etiqueta, b.calidad, b.organismo, b.url_org, b.frecuencia, b.cobertura, a.detalle, b.diccionario, a.esquema, a.d_comarca, a.provincia, a.fecha_ini, a.fecha_fin FROM carto.t01_productos a,carto.t01_coleccion b  where (a.esquema= '" + esquemas[j] + "' AND a.coleccion=b.coleccion)");
			//rset = stmt.executeQuery("SELECT a.path,a.coleccion,a.name,a.fecha,a.escala,a.descargas,a.tamano,a.descripcion, b.categoria, b.tipo, b.fecha_m, b.fecha_i, b.licencia, b.idioma, b.descrip, a.etiqueta, b.calidad, a.organismo, b.url_org, b.frecuencia, b.cobertura, a.detalle, b.diccionario, a.esquema, a.d_comarca, a.provincia, a.fecha_ini, a.fecha_fin FROM carto.t01_productos a,carto.t01_coleccion b  where (a.esquema= '" + esquemas[j] + "' AND a.coleccion=b.coleccion)");
			rset = stmt.executeQuery("SELECT a.path,a.coleccion,a.name,a.fecha,a.escala,a.descargas,a.tamano,a.descripcion, b.categoria, b.tipo, b.fecha_m, b.fecha_i, b.licencia, b.idioma, b.descrip, a.etiqueta, a.calidad, a.organismo, b.url_org, b.frecuencia, b.cobertura, a.detalle, a.diccionario, a.esquema, a.d_comarca, a.provincia, a.fecha_ini, a.fecha_fin FROM carto.t01_productos a,carto.t01_coleccion b  where (a.esquema= '" + esquemas[j] + "' AND a.coleccion=b.coleccion)");
			
			//fichero = fichero + "j es " +j+" y su valor es "+esquemas[j];
			int cont =0;
			while (rset.next()) {
				/*if (rset.getString("esquema")!=null){
					fichero = fichero+"\n\tEl esquema es "+rset.getString("esquema")+" y el name "+rset.getString("name")+" la descripcion "+ rset.getString("descripcion") +" categoria " +rset.getString("categoria")+"\n";
				}
				else{
					fichero = fichero +"\n\tEl esquema es "+rset.getString("esquema")+" y el name "+rset.getString("name")+"\n";
				}*/
				if (rset.getString("descripcion")!=null && rset.getString("name")!=null && rset.getString("categoria")!=null) {
					
					//Dependen de parametro "organizacion"
					String organizacion = "";
					String descrip = "";
					String organizacionUrl = "";
					//Dependen del parametro "frecuencia"
					String frecuenciaValue = "";
					String frecuenciaLabel = "";
					//Dependen del parametro "tema"
					String tema = "";
					String temaId = "";
					String temaDes = "";
					String cobertura_espacial = "";
					String detalle = "";
					String escala = "";
					String diccionario = "";
					String calidad = "";
					String idioma = "";
					String licencia = "";
					String path = "";
					java.util.Date fecha_m = new java.util.Date();
					java.util.Date fecha_i = new java.util.Date();
					String esquema = "";
					String comarca = "";
					String provincia = "";
					//boolean provincia;
					String temporalFrom = "";
					String temporalUntil = "";
					
					tema = rset.getString("categoria");
					temaId = tema.toLowerCase().replace(" ", "-").replace("á", "a").replace("é", "e").replace("í", "i").replace("ó", "o").replace("ú", "u").replace("Á", "A").replace("É", "E").replace("Í", "I").replace("Ó", "O").replace("Ú", "U");
					temaDes = rset.getString("categoria");
					if (rset.getString("esquema") != null) {
						esquema = rset.getString("esquema");
					}
					if (rset.getString("d_comarca") != null) {
						comarca = rset.getString("d_comarca");
					}
					//if (rset.getBoolean("provincia")!= null){
					provincia = rset.getString("provincia");
					//}
					//if (rset.getString("fecha_ini")){
					temporalFrom = rset.getString("fecha_ini");
					//}
					//if (rset.getString("fecha_fin")){
					temporalUntil = rset.getString("fecha_fin");
					//}
					if (rset.getString("cobertura") != null) {
						cobertura_espacial = rset.getString("cobertura");
					}
					if (rset.getString("path") != null) {
						path = rset.getString("path");
					}
					if (rset.getString("detalle") != null) {
						detalle = rset.getString("detalle").trim();
					}
					if (rset.getString("escala") != null) {
						escala = rset.getString("escala").trim();
					}
					if (rset.getString("diccionario") != null)  {
						diccionario = rset.getString("diccionario").trim();
					}
					if (rset.getString("calidad") != null) {
						calidad = rset.getString("calidad").trim();
					}
					if (rset.getString("idioma") != null) {
						idioma = rset.getString("idioma").trim();
					}
					if (rset.getString("licencia") != null) {
						licencia = rset.getString("licencia").trim();
					}
					if (rset.getString("fecha_m") != null) {
						fecha_m = rset.getDate("fecha_m");
					}

					if (rset.getString("fecha_i") != null) {
						fecha_i = rset.getDate("fecha_i");
					}
					
					descrip = rset.getString("descrip");
					//Si existen, se guardan
					if (rset.getString("organismo") != null) {
						organizacion = rset.getString("organismo");
						
					} 
					else {
						organizacion = "Instituto Geográfico de Aragón";
					}
					if (rset.getString("url_org") != null) {
						organizacionUrl = rset.getString("url_org");
					} 
					else {
						organizacionUrl = "http://igear.aragon.es";
					}
					//Por defecto es anual
					String frecuencia = rset.getString("frecuencia");
					if (frecuencia != null) {
						if (frecuencia.equalsIgnoreCase("Diariamente")) {
							frecuenciaValue = "Diaria";
							frecuenciaLabel = "Diaria";
						}
						else if (frecuencia
							.equalsIgnoreCase("Mensualmente")) {
							frecuenciaValue = "Mensual";
							frecuenciaLabel = "Mensual";
						}
						else {
							frecuenciaValue = "Anual";
							frecuenciaLabel = "Anual";
						}
					} 
					else {
						frecuenciaValue = "Anual";
						frecuenciaLabel = "Anual";
					}
					//***********************************************************

					//TamaÃ±o******************************************************
					String tamanio = "";
					tamanio = rset.getString("tamano");

					//Tipo*****************************************************
					String formato = rset.getString("descargas");
					String formatoValue = "";
					String formatoLabel = "";
					//*********************************************************

					String[] tags;
					String aboutUrl = "";
					String etiquetasString = "";

					//ID = Descripcion + nombre de archivo (sin tildes, espacios o signos de puntuación)
					identificador = rset.getString("descripcion").replace("á", "a").replace("é", "e").replace("í", "i").replace("ó", "o").replace("ú", "u").replace("Á", "A").replace("É", "E").replace("Í", "I").replace("Ó", "O").replace("Ú", "U").replace("ñ","ny");
					identificador = identificador.trim().toLowerCase().replace(":", "-").replace(")", "").replace(",", "").replace("(", "").replace(".", "").replace(" ", "-")+ "_"+ rset.getString("name").toLowerCase().replace(" ", "-");
					identificador = identificador.replace("--", "-");

					if (identificador.length() > 100) {
						identificador = identificador.substring(0, 99);
					}
					//Se obtenian de la descripcion. Ahora tienen su propio campo

					if (rset.getString("ETIQUETA") != null) {
						etiquetasString = rset.getString("ETIQUETA");
					}

					tags = etiquetasString.split(",");
					aboutUrl = rset.getString("path");
					title = rset.getString("descripcion");
					description = rset.getString("detalle");

					//-----------------------------------------------------------
				  //fichero = fichero+"La condicion es " + (!esquemas[j].equalsIgnoreCase("comarca") || (esquemas[j].equalsIgnoreCase("comarca") && (!identificador.endsWith("_d16") && (formato != null && formato.equalsIgnoreCase(".zip"))))) ;
					//fichero = fichero+"La condicion es " + ((!identificador.endsWith("_d16") && (formato != null && formato.contains(".zip")))) ;
					//fichero = fichero+"\nel identificador "+identificador+" y la condicion "+(!identificador.endsWith("_d16"));
					//fichero = fichero+"\nlo del formato es "+formato+ " " + (formato != null && formato.contains(".zip"));
					//if (!esquemas[j].equalsIgnoreCase("comarca") || (esquemas[j].equalsIgnoreCase("comarca") && (!identificador.endsWith("_d16") && (formato != null && formato.equalsIgnoreCase(".zip"))))) {
					if ((!esquemas[j].equalsIgnoreCase("comarca") || (esquemas[j].equalsIgnoreCase("comarca") && (!identificador.endsWith("_d16") && (formato != null && (formato.contains(".zip") && !formato.contains("pdf.zip")))))) && (listaNegra.indexOf(identificador) <0 )) {


						nombres = nombres + identificador + ".rdf\n";
						//nombres = nombres + rset.getString("descripcion")  + "/" + rset.getString("name") + "\n";
						fichero = fichero +"\t<dcat:Dataset rdf:about=\"" + aboutUrl+ "\">\n" + "\t\t<dct:identifier>"+ identificador + "</dct:identifier>\n"+ "\t\t<dct:description>"+ description.replace("&", "&amp;")+ "</dct:description>\n";

						for (int i = 0; i < tags.length; i++) {
							if (tags[i].length() > 3) {
								fichero = fichero + "\t\t<dcat:keyword xml:lang=\"es\">" + tags[i].trim() + "</dcat:keyword>\n";
							}
						}
						fichero = fichero + "\t\t<dct:title>" + title+ "</dct:title>\n"+ "\t\t<dct:modified>" + fecha_m+ "</dct:modified>\n"+ "\t\t<dct:issued>" + fecha_i+ "</dct:issued>\n";
						
						
						/*if (identificador.equals("inaga-localizacion-expedientes-en-participacion-publica_inaga_loc_participacionpublica")){
							fichero = fichero + "\t\tel organismo es ASDx "+descrip+" asdfsdfsdf";
						}*/
						
						//Organización, Hay tres posibilidades diferentes a fecha de 12/06/2015: Dirección General de Urbanismo. Gobierno de Aragón,  Dpto. Agricultura, Ganadería y Medioambiente o Instituto Geográfico de Aragón
						if (organizacion.equals("Dirección General de Urbanismo. Gobierno de Aragón")) {
							fichero = fichero+ "\t\t<dct:organization>direccion_general_de_urbanismo</dct:organization>\n";
						} 
						else if (organizacion.equals("Dpto. Agricultura, Ganadería y Medioambiente")) {
							fichero = fichero + "\t\t<dct:organization>instituto_aragones_de_gestion_ambiental</dct:organization>\n";
						} 
						else if (organizacion.equals("INAGA. Instituto Aragonés de Gestión Ambiental")) {
							fichero = fichero + "\t\t<dct:organization>instituto_aragones_de_gestion_ambiental</dct:organization>\n";
						}
						else if (organizacion.equals("Dirección General de Sostenibilidad")) {
							fichero = fichero + "\t\t<dct:organization>direccion_general_de_sostenibilidad</dct:organization>\n";
						} 
						else if (organizacion
							.equals("Instituto Geográfico de Aragón")) {
							fichero = fichero + "\t\t<dct:organization>instituto_geografico_de_aragon</dct:organization>\n";
						}
						//Publicador
						fichero = fichero+ "\t\t<dct:publisher>\n"+ "\t\t\t<foaf:Organization>\n"+ "\t\t\t\t<dct:title>"+ organizacion+ "</dct:title>\n"+ "\t\t\t\t<foaf:homepage rdf:resource=\""+ organizacionUrl + "\"/>\n"+ "\t\t\t</foaf:Organization>\n"+ "\t\t</dct:publisher>\n";

						//Periodicidad
						fichero = fichero+ "\t\t<dct:accrualPeriodicity>\n"+ "\t\t\t<dct:Frequency>\n"+ "\t\t\t\t<rdf:value>"+ frecuenciaValue + "</rdf:value>\n"+ "\t\t\t\t<rdfs:label>"+ frecuenciaLabel + "</rdfs:label>\n"+ "\t\t\t</dct:Frequency>\n"+ "\t\t</dct:accrualPeriodicity>\n";

						if (escala.equalsIgnoreCase("0")) {
							escala = "";
						} 
						else {
							escala = "Escala: 1:" + escala;
						}
						/*fichero = fichero
							+ "\t\t<dct:spatial>" + cobertura_espacial + "</dct:spatial>\n"
							+ "\t\t<dct:temporal></dct:temporal>\n"*/
						if (temporalFrom != null) {
							fichero = fichero+ "\t\t<dct:temporalFrom>"+ transformaTemporal(temporalFrom)+ "</dct:temporalFrom>\n";
						}
						if (temporalUntil != null) {
							fichero = fichero+ "\t\t<dct:temporalUntil>"+ transformaTemporal(temporalUntil)+ "</dct:temporalUntil>\n";
						}
						fichero = fichero+ "\t\t<dct:language>"+ idioma.toUpperCase()+ "</dct:language>\n"+ "\t\t<dct:license rdf:resource=\"cc-by\"></dct:license>\n"+ "\t\t<dcat:granularity>" + escala+ "</dcat:granularity>\n";
						
						
						
						if ((organizacion.equals("Dpto. Agricultura, Ganadería y Medioambiente")) || (organizacion.equals("INAGA. Instituto Aragonés de Gestión Ambiental"))) {
							
							
							if (!(calidad.toUpperCase().equals("NO"))){
								fichero = fichero + "\t\t<dcat:dataQuality>" + calidad + "</dcat:dataQuality>\n";
							}
							if (!(diccionario.toUpperCase().equals("NO"))){
								fichero = fichero + "\t\t<dcat:dataDictionary>" + diccionario + "</dcat:dataDictionary>\n";
							}
						}
						else {
							if (calidad.length() > 0) {
								if (!(calidad.toUpperCase().equals("NO"))){
									fichero = fichero + "\t\t<dcat:dataQuality>La calidad de datos se encuentra en la siguiente url</dcat:dataQuality>\n";
									fichero = fichero + "\t\t<dcat:urlQuality>" + calidad + "</dcat:urlQuality>\n";
								}
							}
							if (diccionario.length() > 0) {
								if (!(diccionario.toUpperCase().equals("NO"))){
									fichero = fichero + "\t\t<dcat:dataDictionary>El diccionario del dato se encuentra en la siguiente url</dcat:dataDictionary>\n";
									fichero = fichero + "\t\t<dcat:urlDictionary>" + diccionario + "</dcat:urlDictionary>\n";
								}
							}
						}
						//Aragopedia
						ArrayList<String> enlacesAragopegia = new ArrayList<String>();
						if (esquema.toLowerCase().equals("comarca")) {
							enlacesAragopegia = getEnlaceAragopedia(esquema, comarca);
						}
						if (esquema.toLowerCase().equals("provincia")) {
							enlacesAragopegia = getEnlaceAragopedia(esquema, provincia);
						}
						if (esquema.equals("aragon")) {
							enlacesAragopegia = getEnlaceAragopedia(esquema, "");
						}
						fichero = fichero + "\t\t<dcat:name_aragopedia>" + enlacesAragopegia.get(0) + "</dcat:name_aragopedia>\n";
						fichero = fichero + "\t\t<dcat:short_uri_aragopedia>" + enlacesAragopegia.get(1) + "</dcat:short_uri_aragopedia>\n";
						fichero = fichero + "\t\t<dcat:type_aragopedia>" + enlacesAragopegia.get(2) + "</dcat:type_aragopedia>\n";
						fichero = fichero + "\t\t<dcat:uri_aragopedia>" + enlacesAragopegia.get(3) + "</dcat:uri_aragopedia>\n";

						//Borrar si no tienen recursos o es solo PDF
						if (formato == null|| formato.equalsIgnoreCase(".pdf")) {
							fichero = fichero + "\t\t<dct:status>true</dct:status>\n";
						}
						//Tema
						fichero = fichero + "\t\t<dcat:theme>\n" + "\t\t\t<rdf:Description>\n" + "\t\t\t\t<rdfs:label>" + tema + "</rdfs:label>\n" + "\t\t\t\t<dct:identifier>" + temaId + "</dct:identifier>\n" + "\t\t\t\t<dct:description>" + temaDes + "</dct:description>\n" + "\t\t\t</rdf:Description>\n" + "\t\t</dcat:theme>\n";
						if (formato != null) {
							String[] formatos = formato.split(",");
							String[] tamanoArray = (tamanio == null ? null : tamanio.split(","));
							Boolean esPDF = false;
							for (int i = 0; i < formatos.length; i++) {
								String tamanioValue = "";
								String tamanioLabel = "";
								esPDF = false;
								formatos[i] = formatos[i].substring(1);
								formatoValue = "";
								if (formatos[i].equalsIgnoreCase("pdf")) {
									formatoValue = "application/pdf";
									esPDF = true;
								}
								//fichero = fichero +"\n\tEl formato "+i+"-esimo tiene como valor "+formatos[i]+"\n";
								if (formatos[i].equalsIgnoreCase("shp.zip")) {
									formatoValue = "application/zip";
								}
								if (formatos[i].equalsIgnoreCase("dwg.zip")) {
									formatoValue = "application/zip";
								}
								if (formatos[i].equalsIgnoreCase("xml")) {
									formatoValue = "";
								}
								if (formatos[i].equalsIgnoreCase("gml.zip")) {
									formatoValue = "application/zip";
								}
								if (formatos[i].equalsIgnoreCase("dxf.zip")) {
									formatoValue = "application/zip";
								}
								if (formatos[i].equalsIgnoreCase("geojson.zip")) {
									formatoValue = "application/zip";
								}
								if (formatos[i].equalsIgnoreCase("kmz")) {
									formatoValue = "";
								}
								if (formatos[i].equalsIgnoreCase("dxf.zip")) {
									formatoValue = "application/zip";
								}
								if (formatoValue.equalsIgnoreCase("")) {
									if (formatos[i].contains("zip")) {
									formatoValue = "application/zip";
									} else {
									formatoValue = "";//OJO. Se usa cuando no hay uno definido
									}
								}

								/*DecimalFormat dec = new DecimalFormat("###.##");
								if (tamanio!=null && !tamanio.equalsIgnoreCase("") && tamanoArray!= null && tamanoArray.length==formatos.length){
									tamanioValue = tamanoArray[0];

									//Obtencion de bytes (SI es posible)
									try{
										//Forzamos el formateo por si los datos estan mal metidos
										if (tamanioValue.charAt(tamanioValue.length()-2)!=' '){
											String numero = tamanioValue.substring(0, tamanioValue.length()-2);
											String unidad = tamanioValue.substring(tamanioValue.length()-2);
											tamanioValue = numero.trim()+" "+unidad.trim();
										}
										String[] tamanioSplit = tamanioValue.split(" ");
										if (tamanioSplit.length >0){
											Float tamanioFloat = Float.parseFloat(tamanioSplit[0]);
											if (tamanioSplit[1].equalsIgnoreCase("Mb")){
											tamanioFloat = tamanioFloat * 1024 *1024;
											tamanioValue = String.valueOf(dec.format(tamanioFloat));
											}
											if (tamanioSplit[1].equalsIgnoreCase("Kb")){
											tamanioFloat = tamanioFloat * 1024;
											tamanioValue = String.valueOf(tamanioFloat);
											}
										}
										}
											catch(Exception e){
										}
									tamanioLabel = tamanoArray[i];
								}*/

								if (formatos[i].contains(".")) {
									formatoLabel = formatos[i].split("\\.")[0].toUpperCase();
								} 
								else {
									formatoLabel = formatos[i].toUpperCase();
								}

								accessURL = rset.getString("path") + rset.getString("name") + "." + formatos[i];
								//distribucion
								if (!esPDF) {
									DecimalFormat df = new DecimalFormat("0");
									fichero = fichero + "\t\t<dcat:distribution>\n" + "\t\t\t<dcat:Distribution>\n" + "\t\t\t\t<rdfs:label>" + title + "</rdfs:label>\n" + "\t\t\t\t<dct:description>" + description + "</dct:description>\n" + "\t\t\t\t<rdf:type rdf:resource=\"http://vocab.deri.ie/dcat#Download\"/>\n" + "\t\t\t\t<dcat:accessURL rdf:resource=\"" + accessURL + "\"></dcat:accessURL>\n" + "\t\t\t\t<dcat:size>\n" + "\t\t\t\t\t<rdf:Description>\n" + "\t\t\t\t\t\t<dcat:bytes>" + tamanioValue + "</dcat:bytes>\n" + "\t\t\t\t\t\t <rdfs:label>" + tamanioLabel + "</rdfs:label>\n" + "\t\t\t\t\t</rdf:Description>\n" + "\t\t\t\t</dcat:size>\n" + "\t\t\t\t<dct:format>\n" + "\t\t\t\t\t<dct:IMT>\n" + "\t\t\t\t\t\t<rdf:value>" + formatoValue + "</rdf:value>\n" + "\t\t\t\t\t\t<rdfs:label>" + formatoLabel + "</rdfs:label>\n" + "\t\t\t\t\t</dct:IMT>\n" + "\t\t\t\t</dct:format>\n" + "\t\t\t</dcat:Distribution>\n" + "\t\t</dcat:distribution>\n";
								}
							}
						}
						
						
						fichero = fichero + "\t</dcat:Dataset>\n";
						cont = cont + 1;
					}
					//Final
				}
			}
			//fichero = fichero + "\n\tDSASe han encontrado " + cont+ " registrps en " + esquemas[j] + "\n";
		}
	} 
	catch (Exception s) {
		System.out.println(s);
	}
	fichero = fichero + " </rdf:RDF>\n";
	String hola = "HOLAADIOS";
	session.setAttribute("fichero_en_sesion", hola);
%>

<textarea style="background:#ccc" rows="50" cols="140">
	<%=fichero%>
</textarea>
</br>
<span>Ficheros obtenidos: </span>
<textarea style="background:#ccc" rows="50" cols="140">
	<%=nombres%>
</textarea>
<button style="float:right" type="button" onclick="enviar('mostrar.jsp?id=<%=identificador%>')">Descargar</button>
<!-- <button type="button" onclick="enviar('mostrar.jsp')">Descargar</button>  -->


