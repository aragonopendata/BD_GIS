<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%
// Formulario que llama a "modificarTabla_Chequeo.jsp" y le pasa como variables
// login y password para comprobar la identidad del usuario
// @documento: modificarTabla_Formulario.jsp
// @author: Maria TENA AINA
// @fecha: Octubre 2012
// @metodo: POST
%>

<html>
  <head>
    <title></title>
  </head>
  <body>
    <h2>Formulario modificación tablas:</h2>
    <form method="post" action="modificarTabla_Chequeo.jsp">
		<table border=1 width="450" bgcolor="silver">
	    <tr height="50">
       <th colspan="2"><h3>Identificación de usuario:<h3></th>
      </tr>
		 <tr height="50">
			<td>Usuario: <input type="text" name="usuario" value="" size="30"/></td>
		 	<td>Clave: <input type="password" name="clave" value="" size="30"/></td>
		 </tr>
		 <tr height="50">
       <th colspan="2"><h3>Cambios propuestos:<h3></th>
      </tr>
		 <tr height="50">
		  <td>Campo: <select name="campo">
														<option value="identidad">Identidad</option>
														<option value="fuente">Fuente</option>
														<option value="cmunine">Municipio</option>
														<option value="etiqueta">Etiqueta</option>
														<option value="localidad">Localidad</option>
														<option value="fonetica">Fonetica</option>
														<option value="nivel">Nivel</option>
														<option value="observacio">Observaciones</option>
														<option value="xutm">Coordenada x</option>
														<option value="yutm">Coordenada y</option>
														</select></td>
		  <td>Propuesta: <input type="text" name="propuesta" value="" size="30"/></td>
		 </tr>
		 <tr height="50"><td colspan="2">Motivo cambios: <textarea rows="4" cols="52" name="motivo"></textarea></td></tr>
      <tr height="50">
			<td align="center" colspan="2">
				<input type="submit" value="Envíar cambios" />
				<input type="reset" value="Limpiar formulario"/>
			</td>
		 </tr>
    </table>
		</form>
  </body>
</html>
