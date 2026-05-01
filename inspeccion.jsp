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

    int nuevoIdInforme = 1;

    try (Connection con = ConexionBD.conectar()) {
        String sqlId = "SELECT NVL(MAX(ID_INFORME), 0) + 1 AS NUEVO_ID FROM INFORME_FITOSANITARIO";
        PreparedStatement psId = con.prepareStatement(sqlId);
        ResultSet rsId = psId.executeQuery();

        if (rsId.next()) {
            nuevoIdInforme = rsId.getInt("NUEVO_ID");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error al calcular ID informe: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Inspección Fitosanitaria</title>
<link rel="stylesheet" href="dashboard.css">
</head>

<body>

<div class="container">

    <jsp:include page="menu.jsp" />

    <div class="main">

        <div class="topbar">
            <h1>Inspección Fitosanitaria</h1>
            <p>Usuario: <%= u.getUsuario() %></p>
        </div>

        <% if (request.getParameter("ok") != null) { %>
            <p style="color:green; font-weight:bold;">Inspección guardada correctamente</p>
        <% } %>

        <div class="formulario">
            <h2>Registrar informe fitosanitario</h2>

            <form action="guardarInspeccion" method="post" enctype="multipart/form-data">

                <input type="number" name="idInforme" value="<%= nuevoIdInforme %>" readonly>

                <input type="number" name="idLote" placeholder="ID Lote" required>

                <input type="number" name="idAsistente" placeholder="ID Asistente" required>

                <input type="date" name="fecha" required>

                <input type="text" name="estadoFenologico" placeholder="Estado fenológico" required>

                <input type="number" step="0.01" name="areaHa" placeholder="Área HA" required>

                <input type="number" name="cantPlantas" placeholder="Cantidad de plantas" required>

                <input type="file" name="foto" accept="image/*">

                <button type="submit">Guardar Inspección</button>

            </form>
        </div>

        <div class="tabla">
            <h2>Inspecciones registradas</h2>

            <table>
                <tr>
                    <th>ID Informe</th>
                    <th>ID Lote</th>
                    <th>ID Asistente</th>
                    <th>Fecha</th>
                    <th>Estado Fenológico</th>
                    <th>Área HA</th>
                    <th>Cant. Plantas</th>
                    <th>Foto</th>
                    <th>Acciones</th>
                </tr>

                <%
                    try (Connection con = ConexionBD.conectar()) {

                        String sql =
                            "SELECT ID_INFORME, ID_LOTE, ID_ASISTENTE, " +
                            "TO_CHAR(FECHA, 'YYYY-MM-DD') AS FECHA, " +
                            "ESTADO_FENOLOGICO, AREA_HA, CANT_PLANTAS, FOTO " +
                            "FROM INFORME_FITOSANITARIO " +
                            "ORDER BY ID_INFORME";

                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                %>

                <tr>
                    <td><%= rs.getString("ID_INFORME") %></td>
                    <td><%= rs.getString("ID_LOTE") %></td>
                    <td><%= rs.getString("ID_ASISTENTE") %></td>
                    <td><%= rs.getString("FECHA") %></td>
                    <td><%= rs.getString("ESTADO_FENOLOGICO") %></td>
                    <td><%= rs.getString("AREA_HA") %></td>
                    <td><%= rs.getString("CANT_PLANTAS") %></td>

                    <td>
                        <% if (rs.getString("FOTO") != null) { %>
                            <img src="uploads/<%= rs.getString("FOTO") %>" width="90">
                        <% } else { %>
                            Sin foto
                        <% } %>
                    </td>

                    <td>
                        <a href="editarInspeccion.jsp?id=<%= rs.getString("ID_INFORME") %>">
                            <button>Modificar</button>
                        </a>

                        <a href="informe.jsp?id=<%= rs.getString("ID_INFORME") %>">
                            <button>Ver Informe</button>
                        </a>

                        <form action="eliminarInspeccion" method="post" style="display:inline;">
                            <input type="hidden" name="idInforme" value="<%= rs.getString("ID_INFORME") %>">

                            <button type="submit" onclick="return confirm('¿Eliminar inspección?')">
                                Eliminar
                            </button>
                        </form>
                    </td>
                </tr>

                <%
                        }

                    } catch (Exception e) {
                        out.println("<tr><td colspan='9'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>

            </table>
        </div>

    </div>

</div>

</body>
</html>