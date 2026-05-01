<%-- 
    Document   : productores
    Created on : 28/04/2026, 5:47:56 p. m.
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
<title>Productores</title>
<link rel="stylesheet" href="dashboard.css">
</head>

<body>

<div class="container">

    <jsp:include page="menu.jsp" />

    <div class="main">

        <div class="topbar">
            <h1>Gestión de Productores</h1>
            <p>Usuario: <%= u.getUsuario() %></p>
        </div>

        <% if (request.getParameter("ok") != null) { %>
            <p style="color:green;">Productor guardado correctamente</p>
        <% } %>

        <div class="formulario">
            <form action="guardarProductor" method="post">

                <input type="text" name="nroIdentidad" placeholder="Nro Identidad" required>
                <input type="text" name="nombre" placeholder="Nombre" required>
                <input type="text" name="direccion" placeholder="Dirección">
                <input type="text" name="telefono" placeholder="Teléfono">
                <input type="email" name="email" placeholder="Email">
                <input type="text" name="nroRegistroIca" placeholder="Registro ICA">

                <select name="estado">
                    <option value="ACTIVO">ACTIVO</option>
                    <option value="INACTIVO">INACTIVO</option>
                </select>

                <button type="submit">Guardar Productor</button>

            </form>
        </div>

        <div class="tabla">
            <h2>Productores registrados</h2>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                </tr>

                <%
                    try (Connection con = ConexionBD.conectar()) {

                        String sql = "SELECT ID_PRODUCTOR, NOMBRE FROM PRODUCTOR";

                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                %>

                <tr>
                    <td><%= rs.getString("ID_PRODUCTOR") %></td>
                    <td><%= rs.getString("NOMBRE") %></td>
                </tr>

                <%
                        }
                    } catch (Exception e) {
                        out.println("Error: " + e.getMessage());
                    }
                %>

            </table>
        </div>

    </div>

</div>

</body>
</html>