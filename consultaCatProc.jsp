<%@page import="java.net.HttpURLConnection, java.net.URL, java.io.OutputStream, java.io.InputStream, java.util.Enumeration, java.util.Hashtable, java.io.StringReader" %><%@page contentType="text/xml" %><%
	String txtMateria = request.getParameter("MATERIA");
	String txtGrupo = request.getParameter("GRUPO");
	String txtKeyword = request.getParameter("KEYWORD");
	String txtOrgano = request.getParameter("ORGANO");
	String txtDepartamento = request.getParameter("DEPARTAMENTO");
	int numMateria = -1;
	int numGrupo = -1;
	InputStream inn = null;

	if (txtMateria != null) {
		try {
			numMateria = Integer.parseInt(txtMateria);
		} catch(Exception e) {
		}
	}

	if (txtGrupo != null) {
		try {
			numGrupo = Integer.parseInt(txtGrupo);
		} catch(Exception e) {
		}
	}

	try {
		String parametro = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>" +
			"<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ser=\"http://services.desfor.aragob.es\" > <soap:Header/>" +
			"<soap:Body>" +
			"  <ser:getProcedimientosResumen>" +
			"    <ser:idEntidad>0</ser:idEntidad>";

		if (numMateria != -1) {
			parametro += "    <ser:idMateria>" + numMateria + "</ser:idMateria>";
		}
		if (numGrupo != -1) {
			parametro += "    <ser:idGrupo>" + numGrupo + "</ser:idGrupo>";
		}
		if (txtKeyword != null) {
		  parametro += "   <ser:palClave>" + txtKeyword + "</ser:palClave>";
		}
		if (txtOrgano != null) {
		  parametro += "   <ser:idOrgano>" + txtOrgano + "</ser:idOrgano>";
		}
		if (txtDepartamento != null) {
		  parametro += "   <ser:idDepartamento>" + txtDepartamento + "</ser:idDepartamento>";
		}

		parametro += "  </ser:getProcedimientosResumen>" +
			"</soap:Body>" +
			"</soap:Envelope>";
		String p_url = "http://servicios3.aragon.es/desforws-web/services/DesforWebService";

		String contentType = "application/soap+xml; charset=iso-8859-1";
		JspWriter salida = out;

		//salida.println("Empiezo\n");

		URL url = new URL(p_url);

		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setDoOutput(true);

		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type", contentType);

			//Escribir en la conexión
		OutputStream outs = conn.getOutputStream();
		outs.write(parametro.getBytes());
		outs.flush();
		outs.close();

			//Verificar respuesta
		//salida.println("Enviando\n");

		int rc = conn.getResponseCode();

		if (rc == HttpURLConnection.HTTP_OK) {
			//salida.println("RECIBIDO OK\n");
				//Se lee la respuesta
			inn = conn.getInputStream();
		} else {
			salida.println("Ocurrio un error con el request POST: " + rc + ", " + conn.getResponseMessage());
			inn = conn.getErrorStream();
		}
		String strXML = "";
		if (inn != null) {
			//salida.println("Respondio el servicio web");

			StringBuffer outAux = new StringBuffer();
				byte[] b = new byte[4096];
				for (int n; (n = inn.read(b)) != -1;) {
					outAux.append(new String(b, 0, n));
				}
			//salida.println(outAux.toString());
			strXML = outAux.toString();
		}
		out.println(strXML);
	} catch(Exception e) {
		//e.printStackTrace();
		out.println("<?xml version='1.0' encoding='iso-8859-1'?><error>Fallo en los valores de los parametros</error>");
	} finally {
		if (inn != null) {
			try {
				inn.close();
			} catch (Exception exc) {
			}
		}
	}
%>
