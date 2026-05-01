<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="java.sql.*" %>

<%
String id = request.getParameter("id");

String idProductor="", nombre="", departamento="", municipio="", vereda="", direccion="", lat="", lon="", resultado="", fecha="";

try (Connection con = ConexionBD.conectar()) {

    PreparedStatement ps = con.prepareStatement(
        "SELECT ID_PRODUCTOR, NOMBRE, DEPARTAMENTO, MUNICIPIO, VEREDA, DIRECCION, LAT, LON, RESULTADO_VISITA_ICA, TO_CHAR(FECHA_VISITA_ICA,'YYYY-MM-DD') FECHA FROM LUGAR_PRODUCCION WHERE ID_LUGAR=?"
    );

    ps.setInt(1, Integer.parseInt(id));
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        idProductor = rs.getString("ID_PRODUCTOR");
        nombre = rs.getString("NOMBRE");
        departamento = rs.getString("DEPARTAMENTO");
        municipio = rs.getString("MUNICIPIO");
        vereda = rs.getString("VEREDA");
        direccion = rs.getString("DIRECCION");
        lat = rs.getString("LAT");
        lon = rs.getString("LON");
        resultado = rs.getString("RESULTADO_VISITA_ICA");
        fecha = rs.getString("FECHA");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Editar Lugar</title>
<link rel="stylesheet" href="dashboard.css">
</head>

<body>

<div class="container">
<jsp:include page="menu.jsp" />

<div class="main">

<div class="topbar">
<h1>Editar Lugar</h1>
</div>

<div class="formulario">

<form action="actualizarLugarProd" method="post">

<input type="hidden" name="idLugar" value="<%= id %>">

<input type="number" name="idProductor" value="<%= idProductor %>" required>
<input type="text" name="nombre" value="<%= nombre %>" required>
<input type="text" name="departamento" value="<%= departamento %>">
<input type="text" name="municipio" value="<%= municipio %>">
<input type="text" name="vereda" value="<%= vereda %>">
<input type="text" name="direccion" value="<%= direccion %>">
<input type="number" step="0.000001" name="lat" value="<%= lat %>">
<input type="number" step="0.000001" name="lon" value="<%= lon %>">
<input type="text" name="resultadoVisitaIca" value="<%= resultado %>">
<input type="date" name="fechaVisitaIca" value="<%= fecha %>">

<button type="submit">Actualizar</button>

</form>

</div>
</div>
</div>

</body>
</html>