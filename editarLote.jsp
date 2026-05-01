<%-- 
    Document   : editarLote
    Created on : 23/04/2026, 9:13:43 p. m.
    Author     : SALA-404
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="java.sql.*" %>

<%
String id = request.getParameter("id");
String idLugar="", idEspecie="", numero="", areaHa="", fechaSiembra="", fechaEliminacion="";

try (Connection con = ConexionBD.conectar()) {
    PreparedStatement ps = con.prepareStatement(
        "SELECT ID_LOTE, ID_LUGAR, ID_ESPECIE, NUMERO, AREA_HA, " +
        "TO_CHAR(FECHA_SIEMBRA,'YYYY-MM-DD') FECHA_SIEMBRA, " +
        "TO_CHAR(FECHA_ELIMINACION,'YYYY-MM-DD') FECHA_ELIMINACION FROM LOTE WHERE ID_LOTE=?"
    );
    ps.setInt(1, Integer.parseInt(id));
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        idLugar = rs.getString("ID_LUGAR");
        idEspecie = rs.getString("ID_ESPECIE");
        numero = rs.getString("NUMERO");
        areaHa = rs.getString("AREA_HA");
        fechaSiembra = rs.getString("FECHA_SIEMBRA");
        fechaEliminacion = rs.getString("FECHA_ELIMINACION");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Editar Lote</title>
<link rel="stylesheet" href="dashboard.css">
</head>
<body>
<div class="container">
<jsp:include page="menu.jsp" />

<div class="main">
<div class="topbar"><h1>Editar Lote</h1></div>

<div class="formulario">
<form action="actualizarLote" method="post">
    <input type="hidden" name="idLote" value="<%= id %>">
    <input type="number" name="idLugar" value="<%= idLugar %>" required>
    <input type="number" name="idEspecie" value="<%= idEspecie %>" required>
    <input type="text" name="numero" value="<%= numero %>" required>
    <input type="number" step="0.01" name="areaHa" value="<%= areaHa %>" required>
    <input type="date" name="fechaSiembra" value="<%= fechaSiembra %>" required>
    <input type="date" name="fechaEliminacion" value="<%= fechaEliminacion == null ? "" : fechaEliminacion %>">
    <button type="submit">Actualizar</button>
</form>
</div>
</div>
</div>
</body>
</html>
