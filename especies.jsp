<%-- 
    Document   : especie
    Created on : 23/04/2026, 8:15:27 p. m.
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
<title>Gestión de Especies</title>
<link rel="stylesheet" href="dashboard.css">
</head>
<body>

<div class="container">
    <jsp:include page="menu.jsp" />

    <div class="main">
        <div class="topbar">
            <h1>Gestión de Especies</h1>
            <p>Usuario: <%= u.getUsuario() %></p>
        </div>

        <% if (request.getParameter("ok") != null) { %>
            <p style="color:green; font-weight:bold;">Especie guardada correctamente</p>
        <% } %>

        <div class="formulario">
            <h2>Registrar especie</h2>

            <form action="guardarEspecie" method="post" enctype="multipart/form-data">
                <input type="text" name="nombreCientifico" placeholder="Nombre científico" required>
                <input type="text" name="nombresComunes" placeholder="Nombres comunes" required>
                <input type="text" name="variedad" placeholder="Variedad">
                <input type="text" name="ciclo" placeholder="Ciclo">
                <input type="file" name="foto" accept="image/*">

                <button type="submit">Guardar Especie</button>
            </form>
        </div>

        <div class="tabla">
            <h2>Especies registradas</h2>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Nombre científico</th>
                    <th>Nombres comunes</th>
                    <th>Variedad</th>
                    <th>Ciclo</th>
                    <th>Foto</th>
                    <th>Acciones</th>
                </tr>

                <%
                    try (Connection con = ConexionBD.conectar()) {
                        String sql = "SELECT ID_ESPECIE, NOMBRE_CIENTIFICO, NOMBRES_COMUNES, VARIEDAD, CICLO, FOTO FROM ESPECIE ORDER BY ID_ESPECIE";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                %>

                <tr>
                    <td><%= rs.getString("ID_ESPECIE") %></td>
                    <td><%= rs.getString("NOMBRE_CIENTIFICO") %></td>
                    <td><%= rs.getString("NOMBRES_COMUNES") %></td>
                    <td><%= rs.getString("VARIEDAD") %></td>
                    <td><%= rs.getString("CICLO") %></td>
                    <td>
                        <% if (rs.getString("FOTO") != null) { %>
                            <img src="uploads/<%= rs.getString("FOTO") %>" width="90">
                        <% } else { %>
                            Sin foto
                        <% } %>
                    </td>
                    <td>
                    <a href="editarEspecie.jsp?id=<%= rs.getString("ID_ESPECIE") %>">
                    <button>Modificar</button>
                    </a>

                    <form action="eliminarEspecie" method="post" style="display:inline;">
                    <input type="hidden" name="idEspecie" value="<%= rs.getString("ID_ESPECIE") %>">
                    <button type="submit" onclick="return confirm('¿Eliminar especie?')">Eliminar</button>
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