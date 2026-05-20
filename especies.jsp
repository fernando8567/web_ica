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
<title>Gestión de Especies y Plagas</title>
<link rel="stylesheet" href="dashboard.css">

<style>

img{
    border-radius:10px;
    object-fit:cover;
}

.btn-link{
    text-decoration:none;
}

.btn-link button{
    cursor:pointer;
}

</style>

</head>

<body>

<div class="container">

    <jsp:include page="menu.jsp" />

    <div class="main">

        <div class="topbar">
            <h1>Gestión de Especies y Plagas</h1>
            <p>Usuario: <%= u.getUsuario() %></p>
        </div>

        <% if (request.getParameter("ok") != null) { %>
            <p style="color:green; font-weight:bold;">
                Especie guardada correctamente
            </p>
        <% } %>

        <% if (request.getParameter("plagaOk") != null) { %>
            <p style="color:green; font-weight:bold;">
                Plaga guardada correctamente
            </p>
        <% } %>

        <!-- FORMULARIO ESPECIE -->

        <div class="formulario">

            <h2>Registrar Especie</h2>

            <form action="guardarEspecie"
                  method="post"
                  enctype="multipart/form-data">

                <input type="text"
                       name="nombreCientifico"
                       placeholder="Nombre científico"
                       required>

                <input type="text"
                       name="nombresComunes"
                       placeholder="Nombres comunes"
                       required>

                <input type="text"
                       name="variedad"
                       placeholder="Variedad">

                <input type="text"
                       name="ciclo"
                       placeholder="Ciclo">

                <!-- PLAGA OPCIONAL -->

                <select name="idPlaga">

                    <option value="">
                        Sin plaga asociada
                    </option>

                    <%
                        try (Connection con = ConexionBD.conectar()) {

                            String sqlPlaga =
                                "SELECT ID_PLAGA, NOMBRE_CIENTIFICO " +
                                "FROM PLAGA ORDER BY ID_PLAGA";

                            PreparedStatement psPlaga =
                                con.prepareStatement(sqlPlaga);

                            ResultSet rsPlaga =
                                psPlaga.executeQuery();

                            while (rsPlaga.next()) {
                    %>

                    <option value="<%= rsPlaga.getString("ID_PLAGA") %>">

                        <%= rsPlaga.getString("ID_PLAGA") %>
                        -
                        <%= rsPlaga.getString("NOMBRE_CIENTIFICO") %>

                    </option>

                    <%
                            }

                        } catch (Exception e) {
                            out.println("<option>Error cargando plagas</option>");
                        }
                    %>

                </select>

                <input type="file"
                       name="foto"
                       accept="image/*">

                <button type="submit">
                    Guardar Especie
                </button>

            </form>

        </div>

        <!-- FORMULARIO PLAGA -->

        <div class="formulario">

            <h2>Registrar Plaga</h2>

            <form action="guardarPlaga"
                  method="post"
                  enctype="multipart/form-data">

                <input type="text"
                       name="nombreCientifico"
                       placeholder="Nombre científico de la plaga"
                       required>

                <input type="text"
                       name="nombresComunes"
                       placeholder="Nombres comunes de la plaga"
                       required>

                <input type="file"
                       name="foto"
                       accept="image/*">

                <button type="submit">
                    Guardar Plaga
                </button>

            </form>

        </div>

        <!-- TABLA ESPECIES -->

        <div class="tabla">

            <h2>Especies Registradas</h2>

            <table>

                <tr>
                    <th>ID</th>
                    <th>Nombre Científico</th>
                    <th>Nombres Comunes</th>
                    <th>Variedad</th>
                    <th>Ciclo</th>
                    <th>Plaga Asociada</th>
                    <th>Foto</th>
                    <th>Acciones</th>
                </tr>

                <%
                    try (Connection con = ConexionBD.conectar()) {

                        String sql =
                            "SELECT E.ID_ESPECIE, " +
                            "E.NOMBRE_CIENTIFICO, " +
                            "E.NOMBRES_COMUNES, " +
                            "E.VARIEDAD, " +
                            "E.CICLO, " +
                            "E.FOTO, " +
                            "P.NOMBRE_CIENTIFICO AS PLAGA " +
                            "FROM ESPECIE E " +
                            "LEFT JOIN ESPECIE_PLAGA EP " +
                            "ON E.ID_ESPECIE = EP.ID_ESPECIE " +
                            "LEFT JOIN PLAGA P " +
                            "ON EP.ID_PLAGA = P.ID_PLAGA " +
                            "ORDER BY E.ID_ESPECIE";

                        PreparedStatement ps =
                            con.prepareStatement(sql);

                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                %>

                <tr>

                    <td>
                        <%= rs.getString("ID_ESPECIE") %>
                    </td>

                    <td>
                        <%= rs.getString("NOMBRE_CIENTIFICO") %>
                    </td>

                    <td>
                        <%= rs.getString("NOMBRES_COMUNES") %>
                    </td>

                    <td>
                        <%= rs.getString("VARIEDAD") %>
                    </td>

                    <td>
                        <%= rs.getString("CICLO") %>
                    </td>

                    <td>
                        <%= rs.getString("PLAGA") == null
                            ? "Sin plaga"
                            : rs.getString("PLAGA") %>
                    </td>

                    <td>

                        <% if (rs.getString("FOTO") != null) { %>

                            <img src="uploads/<%= rs.getString("FOTO") %>"
                                 width="90"
                                 height="90">

                        <% } else { %>

                            Sin foto

                        <% } %>

                    </td>

                    <td>

                        <a class="btn-link"
                           href="editarEspecie.jsp?id=<%= rs.getString("ID_ESPECIE") %>">

                            <button type="button">
                                Modificar
                            </button>

                        </a>

                        <form action="eliminarEspecie"
                              method="post"
                              style="display:inline;">

                            <input type="hidden"
                                   name="idEspecie"
                                   value="<%= rs.getString("ID_ESPECIE") %>">

                            <button type="submit"
                                    onclick="return confirm('¿Eliminar especie?')">

                                Eliminar

                            </button>

                        </form>

                    </td>

                </tr>

                <%
                        }

                    } catch (Exception e) {

                        out.println(
                            "<tr><td colspan='8'>Error: "
                            + e.getMessage()
                            + "</td></tr>"
                        );
                    }
                %>

            </table>

        </div>

        <!-- TABLA PLAGAS -->

        <div class="tabla">

            <h2>Plagas Registradas</h2>

            <table>

                <tr>
                    <th>ID</th>
                    <th>Nombre Científico</th>
                    <th>Nombres Comunes</th>
                    <th>Foto</th>
                    <th>Acciones</th>
                </tr>

                <%
                    try (Connection con = ConexionBD.conectar()) {

                        String sql =
                            "SELECT ID_PLAGA, " +
                            "NOMBRE_CIENTIFICO, " +
                            "NOMBRES_COMUNES, " +
                            "FOTO " +
                            "FROM PLAGA " +
                            "ORDER BY ID_PLAGA";

                        PreparedStatement ps =
                            con.prepareStatement(sql);

                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                %>

                <tr>

                    <td>
                        <%= rs.getString("ID_PLAGA") %>
                    </td>

                    <td>
                        <%= rs.getString("NOMBRE_CIENTIFICO") %>
                    </td>

                    <td>
                        <%= rs.getString("NOMBRES_COMUNES") %>
                    </td>

                    <td>

                        <%
                            String foto = rs.getString("FOTO");

                            if(foto != null && !foto.isEmpty()){
                        %>

                            <img src="imagenes/plagas/<%= foto %>"
                                 width="100"
                                 height="90">

                        <%
                            } else {
                        %>

                            Sin foto

                        <%
                            }
                        %>

                    </td>

                    <td>

                        <a class="btn-link"
                           href="editarPlaga.jsp?id=<%= rs.getString("ID_PLAGA") %>">

                            <button type="button">
                                Modificar
                            </button>

                        </a>

                        <form action="eliminarPlaga"
                              method="post"
                              style="display:inline;">

                            <input type="hidden"
                                   name="idPlaga"
                                   value="<%= rs.getString("ID_PLAGA") %>">

                            <button type="submit"
                                    onclick="return confirm('¿Eliminar esta plaga?')">

                                Eliminar

                            </button>

                        </form>

                    </td>

                </tr>

                <%
                        }

                    } catch (Exception e) {

                        out.println(
                            "<tr><td colspan='5'>Error: "
                            + e.getMessage()
                            + "</td></tr>"
                        );
                    }
                %>

            </table>

        </div>

    </div>

</div>

</body>
</html>