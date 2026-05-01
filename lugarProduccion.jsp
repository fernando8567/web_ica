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
<title>Lugar de Producción</title>
<link rel="stylesheet" href="dashboard.css">
</head>

<body>

<div class="container">

    <jsp:include page="menu.jsp" />

    <div class="main">

        <div class="topbar">
            <h1>Lugar de Producción</h1>
            <p>Usuario: <%= u.getUsuario() %></p>
        </div>

        <% if (request.getParameter("ok") != null) { %>
            <p style="color:green; font-weight:bold;">Lugar guardado correctamente</p>
        <% } %>

        <!-- FORMULARIO -->
        <div class="formulario">
            <h2>Registrar Lugar de Producción</h2>

            <form action="guardarLugarProduccion" method="post">

                <input type="number" name="idProductor" placeholder="ID Productor" required>

                <input type="text" name="nombre" placeholder="Nombre del lugar" required>

                <input type="text" name="departamento" placeholder="Departamento">
                <input type="text" name="municipio" placeholder="Municipio">
                <input type="text" name="vereda" placeholder="Vereda">

                <input type="text" name="direccion" placeholder="Dirección">

                <input type="number" step="0.000001" name="lat" placeholder="Latitud">
                <input type="number" step="0.000001" name="lon" placeholder="Longitud">

                <input type="text" name="resultadoVisitaIca" placeholder="Resultado visita ICA">

                <input type="date" name="fechaVisitaIca">

                <button type="submit">Guardar Lugar</button>

            </form>
        </div>

        <!-- TABLA -->
        <div class="tabla">
            <h2>Lugares registrados</h2>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Productor</th>
                    <th>Nombre</th>
                    <th>Departamento</th>
                    <th>Municipio</th>
                    <th>Acciones</th>
                </tr>

                <%
                    try (Connection con = ConexionBD.conectar()) {

                        String sql = "SELECT ID_LUGAR, ID_PRODUCTOR, NOMBRE, DEPARTAMENTO, MUNICIPIO FROM LUGAR_PRODUCCION ORDER BY ID_LUGAR";

                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                %>

                <tr>
                    <td><%= rs.getString("ID_LUGAR") %></td>
                    <td><%= rs.getString("ID_PRODUCTOR") %></td>
                    <td><%= rs.getString("NOMBRE") %></td>
                    <td><%= rs.getString("DEPARTAMENTO") %></td>
                    <td><%= rs.getString("MUNICIPIO") %></td>

                    <td>
                        <a href="editarLugarProduccion.jsp?id=<%= rs.getString("ID_LUGAR") %>">
                            <button>Modificar</button>
                        </a>

                        <form action="eliminarLugarProduccion" method="post" style="display:inline;">
                            <input type="hidden" name="idLugar" value="<%= rs.getString("ID_LUGAR") %>">

                            <button type="submit" onclick="return confirm('¿Eliminar lugar?')">
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

    </div>

</div>

</body>
</html>