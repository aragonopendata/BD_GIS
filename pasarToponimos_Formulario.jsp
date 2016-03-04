<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%
// Formulario que llama a "pasarToponimos.jsp" y le pasa como variable un texto
// @documento: pasarToponimos_Formulario.jsp
// @author: Maria TENA AINA
// @fecha: Octubre 2012
%>

<html>
  <head>
    <title></title>
  </head>
  <body>
    <h1>Escribir texto</h1>
  <form>
      Texto: <input type="text" name="texto" value="" />
      <input type="submit" value="Buscar cadena fonética" />
	</form>
  
<%
    if ( request.getParameter("texto") != null ) {
%>
<%@ include file="pasarToponimos.jsp" %>
<%
    }
%>
	
  </body>
</html>
