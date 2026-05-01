<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="java.sql.*" %>

<%
String id = request.getParameter("id");

String idLote="", tipo="", fecha="", cantidad="";

try (Connection con = ConexionBD.conectar()) {

    PreparedStatement ps = con.prepareStatement(
        "SELECT ID_PRODUCCION, ID_LOTE, TIPO, " +
        "TO_CHAR(FECHA_RECOLECCION,'YYYY-MM-DD') FECHA, CANTIDAD_KG " +
        "FROM PRODUCCION WHERE ID_PRODUCCION=?"
    );

    ps.setInt(1, Integer.parseInt(id));
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        idLote = rs.getString("ID_LOTE");
        tipo = rs.getString("TIPO");
        fecha = rs.getString("FECHA");
        cantidad = rs.getString("CANTIDAD_KG");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Editar Producción</title>
<link rel="stylesheet" href="dashboard.css">
</head>

<body>

<div class="container">
<jsp:include page="menu.jsp" />

<div class="main">

<div class="topbar">
    <h1>Editar Producción</h1>
</div>

<div class="formulario">

<form action="actualizarProduccion" method="post">

    <input type="hidden" name="idProduccion" value="<%= id %>">

    <input type="number" name="idLote" value="<%= idLote %>" required>

    <select name="tipo" required>
        <option value="PROYECTADA" <%= "PROYECTADA".equals(tipo) ? "selected" : "" %>>PROYECTADA</option>
        <option value="REAL" <%= "REAL".equals(tipo) ? "selected" : "" %>>REAL</option>
    </select>

    <input type="date" name="fechaRecoleccion" value="<%= fecha %>" required>

    <input type="number" step="0.01" name="cantidadKg" value="<%= cantidad %>" required>

    <button type="submit">Actualizar</button>

</form>

</div>

</div>
</div>

</body>
</html>