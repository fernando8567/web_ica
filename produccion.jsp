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
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Módulo de Producción</title>
<link rel="stylesheet" href="dashboard.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>

<div class="container">
    <jsp:include page="menu.jsp" />

    <div class="main">
        <div class="topbar">
            <h1>Módulo de Producción</h1>
            <p>Usuario: <%= u.getUsuario() %></p>
        </div>

        <% if (request.getParameter("ok") != null) { %>
            <p style="color:green; font-weight:bold;">Producción guardada correctamente</p>
        <% } %>

        <div class="formulario">
            <h2>Registrar Producción</h2>

            <form action="guardarProduccion" method="post">
                <input type="number" name="idLote" placeholder="ID Lote" required>

                <select name="tipo" required>
                    <option value="">Tipo de producción</option>
                    <option value="PROYECTADA">PROYECTADA</option>
                    <option value="REAL">REAL</option>
                </select>

                <input type="date" name="fechaRecoleccion" required>
                <input type="number" step="0.01" name="cantidadKg" placeholder="Cantidad KG" required>

                <button type="submit">Guardar Producción</button>
            </form>
        </div>

        <div class="tabla">
            <h2>Producción registrada</h2>

            <table>
                <tr>
                    <th>ID</th>
                    <th>ID Lote</th>
                    <th>Tipo</th>
                    <th>Fecha</th>
                    <th>Cantidad KG</th>
                    <th>Acciones</th>
                </tr>

                <%
                    try (Connection con = ConexionBD.conectar()) {
                        String sql = "SELECT ID_PRODUCCION, ID_LOTE, TIPO, " +
                                     "TO_CHAR(FECHA_RECOLECCION, 'YYYY-MM-DD') AS FECHA, " +
                                     "CANTIDAD_KG FROM PRODUCCION ORDER BY ID_PRODUCCION";

                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                %>

                <tr>
                    <td><%= rs.getString("ID_PRODUCCION") %></td>
                    <td><%= rs.getString("ID_LOTE") %></td>
                    <td><%= rs.getString("TIPO") %></td>
                    <td><%= rs.getString("FECHA") %></td>
                    <td><%= rs.getString("CANTIDAD_KG") %></td>

                    <td>
                        <a href="editarProduccion.jsp?id=<%= rs.getString("ID_PRODUCCION") %>">
                            <button>Modificar</button>
                        </a>

                        <form action="eliminarProduccion" method="post" style="display:inline;">
                            <input type="hidden" name="idProduccion" value="<%= rs.getString("ID_PRODUCCION") %>">
                            <button type="submit" onclick="return confirm('¿Eliminar producción?')">
                                Eliminar
                            </button>
                        </form>
                    </td>
                </tr>

                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </table>
        </div>

        <div class="panel">
            <h2>Gráfica de Producción</h2>
            <canvas id="graficaProduccion"></canvas>
        </div>

    </div>
</div>

<script>
const ctx = document.getElementById('graficaProduccion').getContext('2d');

new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ['Lote 1', 'Lote 2', 'Lote 3'],
        datasets: [{
            label: 'Producción (KG)',
            data: [1200, 900, 1500],
            backgroundColor: ['#4caf50', '#f9a825', '#e53935']
        }]
    },
    options: {
        responsive: true
    }
});
</script>

</body>
</html>