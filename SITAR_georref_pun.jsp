<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>Resultados de la georreferenciación</TITLE>

</HEAD>
<BODY>
<CENTER>

<%@ page contentType="application/vnd.ms-excel"%>
<%response.setContentType("application/vnd.ms-excel");%>

<%String resultsTable = request.getParameter("resultsTable");%>

<%=resultsTable%>

</CENTER>
</BODY>
</HTML>

