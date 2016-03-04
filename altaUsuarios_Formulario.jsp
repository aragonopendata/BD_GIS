<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%
// Formulario que llama a "altaUsuarios.jsp" y le pasa como variables
// nombre, email, login y password para crear un nuevo usuario
// @documento: altaUsuarios_Formulario.jsp
// @author: Maria TENA AINA
// @fecha: Octubre 2012
// @metodo: POST
%>

<html>
  <head>
    <title></title>
  </head>
  <body>
    <h1>Registro de Usuarios</h1>
     <form method="post" action="altaUsuarios.jsp">
      Nombre: <input type="text" name="nombre" value="" />
      Email: <input type="text" name="email" value="" />
      Login: <input type="text" name="usuario" value="" />
      Password: <input type="password" name="clave" value="" />      
      <input type="submit" value="Registrarse" />
     </form>
  </body>
</html>
