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
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Gestión de Lotes</title>
<link rel="stylesheet" href="dashboard.css">
</head>
<body>

<div class="container">
    <jsp:include page="menu.jsp" />

    <div class="main">
        <div class="topbar">
            <h1>Gestión de Lotes</h1>
            <p>Usuario: <%= u.getUsuario() %></p>
        </div>

        <% if (request.getParameter("ok") != null) { %>
            <p style="color:green; font-weight:bold;">Lote guardado correctamente</p>
        <% } %>

        <div class="formulario">
            <h2>Registrar lote</h2>

            <form action="guardarLote" method="post" enctype="multipart/form-data">
                <input type="number" name="idLugar" placeholder="ID Lugar" required>
                <input type="number" name="idEspecie" placeholder="ID Especie" required>
                <input type="text" name="numero" placeholder="Número del lote" required>
                <input type="number" step="0.01" name="areaHa" placeholder="Área HA" required>
                <input type="date" name="fechaSiembra" required>
                <input type="date" name="fechaEliminacion">
                <input type="file" name="foto" accept="image/*">

                <button type="submit">Guardar Lote</button>
            </form>
        </div>

        <div class="tabla">
            <h2>Lotes registrados</h2>

            <table>
                <tr>
                    <th>ID</th>
                    <th>ID Lugar</th>
                    <th>ID Especie</th>
                    <th>Número</th>
                    <th>Área</th>
                    <th>Foto</th>
                    <th>Acciones</th>
                </tr>

                <%
                    try (Connection con = ConexionBD.conectar()) {
                        String sql = "SELECT ID_LOTE, ID_LUGAR, ID_ESPECIE, NUMERO, AREA_HA, FOTO FROM LOTE ORDER BY ID_LOTE";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("ID_LOTE") %></td>
                    <td><%= rs.getString("ID_LUGAR") %></td>
                    <td><%= rs.getString("ID_ESPECIE") %></td>
                    <td><%= rs.getString("NUMERO") %></td>
                    <td><%= rs.getString("AREA_HA") %></td>
                    <td>
                        <% if (rs.getString("FOTO") != null) { %>
                            <img src="uploads/<%= rs.getString("FOTO") %>" width="90">
                        <% } else { %>
                            Sin foto
                        <% } %>
                    </td>
                    <td>
                    <a href="editarLote.jsp?id=<%= rs.getString("ID_LOTE") %>">
                    <button>Modificar</button>
                    </a>

                    <form action="eliminarLote" method="post" style="display:inline;">
                    <input type="hidden" name="idLote" value="<%= rs.getString("ID_LOTE") %>">
                    <button type="submit" onclick="return confirm('¿Eliminar lote?')">Eliminar</button>
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
    </div>
</div>

</body>
</html>