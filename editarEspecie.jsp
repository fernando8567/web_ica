<%-- 
    Document   : editarEspecie
    Created on : 23/04/2026, 9:10:54 p. m.
    Author     : SALA-404
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="java.sql.*" %>

<%
String id = request.getParameter("id");
String nombreCientifico = "", nombresComunes = "", variedad = "", ciclo = "";

try (Connection con = ConexionBD.conectar()) {
    PreparedStatement ps = con.prepareStatement("SELECT * FROM ESPECIE WHERE ID_ESPECIE=?");
    ps.setInt(1, Integer.parseInt(id));
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        nombreCientifico = rs.getString("NOMBRE_CIENTIFICO");
        nombresComunes = rs.getString("NOMBRES_COMUNES");
        variedad = rs.getString("VARIEDAD");
        ciclo = rs.getString("CICLO");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Editar Especie</title>
<link rel="stylesheet" href="dashboard.css">
</head>
<body>
<div class="container">
<jsp:include page="menu.jsp" />

<div class="main">
<div class="topbar"><h1>Editar Especie</h1></div>

<div class="formulario">
<form action="actualizarEspecie" method="post">
    <input type="hidden" name="idEspecie" value="<%= id %>">
    <input type="text" name="nombreCientifico" value="<%= nombreCientifico %>" required>
    <input type="text" name="nombresComunes" value="<%= nombresComunes %>" required>
    <input type="text" name="variedad" value="<%= variedad %>">
    <input type="text" name="ciclo" value="<%= ciclo %>">
    <button type="submit">Actualizar</button>
</form>
</div>
</div>
</div>
</body>
</html>