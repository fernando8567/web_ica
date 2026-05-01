<%-- 
    Document   : editarInspeccion
    Created on : 23/04/2026, 9:21:20 p. m.
    Author     : SALA-404
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="java.sql.*" %>

<%
String id = request.getParameter("id");
String idLote="", idAsistente="", fecha="", estado="", areaHa="", cantPlantas="";

try (Connection con = ConexionBD.conectar()) {
    PreparedStatement ps = con.prepareStatement(
        "SELECT ID_INFORME, ID_LOTE, ID_ASISTENTE, TO_CHAR(FECHA,'YYYY-MM-DD') FECHA, " +
        "ESTADO_FENOLOGICO, AREA_HA, CANT_PLANTAS FROM INFORME_FITOSANITARIO WHERE ID_INFORME=?"
    );
    ps.setInt(1, Integer.parseInt(id));
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        idLote = rs.getString("ID_LOTE");
        idAsistente = rs.getString("ID_ASISTENTE");
        fecha = rs.getString("FECHA");
        estado = rs.getString("ESTADO_FENOLOGICO");
        areaHa = rs.getString("AREA_HA");
        cantPlantas = rs.getString("CANT_PLANTAS");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Editar Inspección</title>
<link rel="stylesheet" href="dashboard.css">
</head>
<body>
<div class="container">
<jsp:include page="menu.jsp" />

<div class="main">
<div class="topbar"><h1>Editar Inspección</h1></div>

<div class="formulario">
<form action="actualizarInspeccion" method="post">
    <input type="hidden" name="idInforme" value="<%= id %>">
    <input type="number" name="idLote" value="<%= idLote %>" required>
    <input type="number" name="idAsistente" value="<%= idAsistente %>" required>
    <input type="date" name="fecha" value="<%= fecha %>" required>
    <input type="text" name="estadoFenologico" value="<%= estado %>" required>
    <input type="number" step="0.01" name="areaHa" value="<%= areaHa %>" required>
    <input type="number" name="cantPlantas" value="<%= cantPlantas %>" required>
    <button type="submit">Actualizar</button>
</form>
</div>
</div>
</div>
</body>
</html>
