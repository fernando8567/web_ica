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

String nombreCientifico = "";
String nombresComunes = "";
String variedad = "";
String ciclo = "";
String idPlagaActual = "";

try (Connection con = ConexionBD.conectar()) {

    String sql =
        "SELECT E.NOMBRE_CIENTIFICO, E.NOMBRES_COMUNES, E.VARIEDAD, E.CICLO, EP.ID_PLAGA " +
        "FROM ESPECIE E " +
        "LEFT JOIN ESPECIE_PLAGA EP ON E.ID_ESPECIE = EP.ID_ESPECIE " +
        "WHERE E.ID_ESPECIE=?";

    PreparedStatement ps = con.prepareStatement(sql);

    ps.setInt(1, Integer.parseInt(id));

    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        nombreCientifico = rs.getString("NOMBRE_CIENTIFICO");
        nombresComunes = rs.getString("NOMBRES_COMUNES");
        variedad = rs.getString("VARIEDAD");
        ciclo = rs.getString("CICLO");
        idPlagaActual = rs.getString("ID_PLAGA");
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

<div class="topbar">
    <h1>Editar Especie</h1>
</div>

<div class="formulario">

<form action="actualizarEspecie" method="post">

    <input type="hidden" name="idEspecie" value="<%= id %>">

    <input type="text" name="nombreCientifico" value="<%= nombreCientifico %>" required>

    <input type="text" name="nombresComunes" value="<%= nombresComunes %>" required>

    <input type="text" name="variedad" value="<%= variedad %>">

    <input type="text" name="ciclo" value="<%= ciclo %>">

    <select name="idPlaga">
        <option value="">Sin plaga asociada</option>

        <%
            try (Connection con = ConexionBD.conectar()) {

                String sqlPlaga =
                    "SELECT ID_PLAGA, NOMBRE_CIENTIFICO FROM PLAGA ORDER BY ID_PLAGA";

                PreparedStatement psPlaga = con.prepareStatement(sqlPlaga);

                ResultSet rsPlaga = psPlaga.executeQuery();

                while (rsPlaga.next()) {

                    String idPlaga = rsPlaga.getString("ID_PLAGA");
        %>

        <option value="<%= idPlaga %>" <%= idPlaga.equals(idPlagaActual) ? "selected" : "" %>>
            <%= idPlaga %> - <%= rsPlaga.getString("NOMBRE_CIENTIFICO") %>
        </option>

        <%
                }
            }
        %>

    </select>

    <button type="submit">Actualizar</button>

</form>

</div>

</div>

</div>

</body>
</html>