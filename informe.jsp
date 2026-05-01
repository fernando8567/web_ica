<%-- 
    Document   : index.jsp
    Created on : 22/04/2026, 4:54:29 p. m.
    Author     : SALA-404
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="java.sql.*" %>

<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");

    if (u == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String idInforme = request.getParameter("id");

    String idLote = "";
    String idAsistente = "";
    String fecha = "";
    String estadoFenologico = "";
    String areaHa = "";
    String cantPlantas = "";

    StringBuilder detallePlagas = new StringBuilder();

    if (idInforme != null && !idInforme.trim().isEmpty()) {

        try (Connection con = ConexionBD.conectar()) {

            String sqlInforme =
                "SELECT ID_INFORME, ID_LOTE, ID_ASISTENTE, " +
                "TO_CHAR(FECHA, 'YYYY-MM-DD') AS FECHA, " +
                "ESTADO_FENOLOGICO, AREA_HA, CANT_PLANTAS " +
                "FROM INFORME_FITOSANITARIO " +
                "WHERE ID_INFORME = ?";

            PreparedStatement ps = con.prepareStatement(sqlInforme);
            ps.setInt(1, Integer.parseInt(idInforme));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                idLote = rs.getString("ID_LOTE");
                idAsistente = rs.getString("ID_ASISTENTE");
                fecha = rs.getString("FECHA");
                estadoFenologico = rs.getString("ESTADO_FENOLOGICO");
                areaHa = rs.getString("AREA_HA");
                cantPlantas = rs.getString("CANT_PLANTAS");
            }

            String sqlDetalle =
                "SELECT D.ID_DETALLE, D.ID_PLAGA, P.NOMBRE_CIENTIFICO, " +
                "D.PLANTAS_INFESTADAS, D.PORCENTAJE_INFESTACION " +
                "FROM DETALLE_INFORME_PLAGA D " +
                "LEFT JOIN PLAGA P ON D.ID_PLAGA = P.ID_PLAGA " +
                "WHERE D.ID_INFORME = ? " +
                "ORDER BY D.ID_DETALLE";

            PreparedStatement psDetalle = con.prepareStatement(sqlDetalle);
            psDetalle.setInt(1, Integer.parseInt(idInforme));

            ResultSet rsDetalle = psDetalle.executeQuery();

            while (rsDetalle.next()) {
                detallePlagas.append("<tr>");
                detallePlagas.append("<td>").append(rsDetalle.getString("ID_PLAGA")).append("</td>");
                detallePlagas.append("<td>").append(rsDetalle.getString("NOMBRE_CIENTIFICO") == null ? "Sin nombre" : rsDetalle.getString("NOMBRE_CIENTIFICO")).append("</td>");
                detallePlagas.append("<td>").append(rsDetalle.getString("PLANTAS_INFESTADAS")).append("</td>");
                detallePlagas.append("<td>").append(rsDetalle.getString("PORCENTAJE_INFESTACION")).append("%</td>");
                detallePlagas.append("</tr>");
            }

        } catch (Exception e) {
            out.println("<p style='color:red;'>Error al cargar informe: " + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Informe Fitosanitario ICA</title>
<link rel="stylesheet" href="dashboard.css">
</head>

<body>

<div class="container">

    <jsp:include page="menu.jsp" />

    <div class="main">

        <div class="topbar">
            <h1>Informe Fitosanitario ICA</h1>
            <p>Usuario: <%= u.getUsuario() %></p>
        </div>

        <div class="panel">

            <h2>Buscar informe</h2>

            <form action="informe.jsp" method="get">
                <input type="number" name="id" placeholder="Ingrese ID del informe" required>
                <button type="submit">Consultar</button>
            </form>

        </div>

        <% if (idInforme != null && !idInforme.trim().isEmpty()) { %>

        <div class="panel">

            <h2>Detalle del informe</h2>

            <p><strong>ID Informe:</strong> <%= idInforme %></p>
            <p><strong>ID Lote:</strong> <%= idLote %></p>
            <p><strong>ID Asistente:</strong> <%= idAsistente %></p>
            <p><strong>Fecha:</strong> <%= fecha %></p>
            <p><strong>Estado Fenológico:</strong> <%= estadoFenologico %></p>
            <p><strong>Área HA:</strong> <%= areaHa %></p>
            <p><strong>Cantidad de plantas:</strong> <%= cantPlantas %></p>

            <br>

            <h2>Detalle de plagas</h2>

            <table>
                <tr>
                    <th>ID Plaga</th>
                    <th>Nombre científico</th>
                    <th>Plantas infestadas</th>
                    <th>% Infestación</th>
                </tr>

                <%= detallePlagas.toString() %>
            </table>

            <br>

            <button onclick="window.print()">Imprimir / Exportar PDF</button>

        </div>

        <% } %>

    </div>

</div>

</body>
</html>