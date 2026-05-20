<%-- 
    Document   : usuarios
    Created on : 12/05/2026, 8:30:06 p. m.
    Author     : SALA-404
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="conexion.ConexionSeguridad" %>
<%@ page import="java.sql.*" %>

<%
    String usuarioSesion =
            (String) session.getAttribute("usuario");

    String rolSesion =
            (String) session.getAttribute("rol");

    if (usuarioSesion == null || rolSesion == null) {

        response.sendRedirect("index.jsp");
        return;
    }

    if (!("admin".equals(usuarioSesion)
            && "Inspector ICA".equals(rolSesion))) {

        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Administrar Usuarios</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family: Arial, Helvetica, sans-serif;
}

body{
    background:#eef1f3;
    padding:30px;
}

.container{
    max-width:1100px;
    margin:auto;
    background:white;
    padding:30px;
    border-radius:15px;
    box-shadow:0px 6px 18px rgba(0,0,0,0.2);
}

h1{
    color:#2e7d32;
    margin-bottom:20px;
}

h2{
    margin-top:20px;
    color:#1b5e20;
}

form{
    margin-bottom:25px;
}

input, select{

    width:100%;

    padding:12px;

    margin-top:10px;

    border-radius:8px;

    border:1px solid #ccc;
}

button{

    margin-top:15px;

    padding:12px 18px;

    border:none;

    border-radius:8px;

    background:#2e7d32;

    color:white;

    cursor:pointer;
}

button:hover{
    background:#1b5e20;
}

table{
    width:100%;
    border-collapse:collapse;
    margin-top:20px;
}

th{
    background:#2e7d32;
    color:white;
    padding:12px;
}

td{
    padding:12px;
    border-bottom:1px solid #ddd;
}

.msg{
    background:#e8f5e9;
    color:#2e7d32;
    padding:10px;
    border-radius:8px;
    margin-bottom:15px;
}

#camposProductor,
#camposAsistente{
    margin-top:15px;
    padding:15px;
    border:1px solid #ddd;
    border-radius:10px;
    background:#fafafa;
    display:none;
}

</style>

<script>

function mostrarCampos(){

    let rol =
            document.getElementById("rol").value;

    let camposProductor =
            document.getElementById("camposProductor");

    let camposAsistente =
            document.getElementById("camposAsistente");

    camposProductor.style.display = "none";
    camposAsistente.style.display = "none";

    if(rol === "Productor"){

        camposProductor.style.display = "block";
    }

    if(rol === "Asistente Técnico"){

        camposAsistente.style.display = "block";
    }
}

</script>

</head>

<body>

<div class="container">

    <h1>Administración de Usuarios</h1>

    <p>
        Administrador:
        <strong><%= usuarioSesion %></strong>
    </p>

    <br>

    <% if (request.getParameter("ok") != null) { %>

        <div class="msg">
            Usuario creado correctamente
        </div>

    <% } %>

    <% if (request.getParameter("eliminado") != null) { %>

        <div class="msg">
            Usuario eliminado correctamente
        </div>

    <% } %>

    <h2>Crear Usuario</h2>

    <form action="crearUsuario" method="post">

        <input type="text"
               name="usuario"
               placeholder="Usuario"
               required>

        <input type="password"
               name="contrasena"
               placeholder="Contraseña"
               required>

        <select name="rol"
                id="rol"
                onchange="mostrarCampos()"
                required>

            <option value="">Seleccione rol</option>

            <option value="Productor">
                Productor
            </option>

            <option value="Asistente Técnico">
                Asistente Técnico
            </option>

            <option value="Inspector ICA">
                Inspector ICA
            </option>

        </select>

        <!-- PRODUCTOR -->

        <div id="camposProductor">

            <h3>Datos del Productor</h3>

            <input type="text"
                   name="direccionProductor"
                   placeholder="Dirección">

            <input type="text"
                   name="telefonoProductor"
                   placeholder="Teléfono">

            <input type="email"
                   name="emailProductor"
                   placeholder="Email">

            <input type="text"
                   name="registroIcaProductor"
                   placeholder="Nro Registro ICA">

        </div>

        <!-- ASISTENTE -->

        <div id="camposAsistente">

            <h3>Datos del Asistente Técnico</h3>

            <input type="text"
                   name="direccionAsistente"
                   placeholder="Dirección">

            <input type="text"
                   name="telefonoAsistente"
                   placeholder="Teléfono">

            <input type="email"
                   name="emailAsistente"
                   placeholder="Email">

            <input type="text"
                   name="tarjetaProfesional"
                   placeholder="Nro Tarjeta Profesional">

            <input type="text"
                   name="registroIcaAsistente"
                   placeholder="Nro Registro ICA">

        </div>

        <button type="submit">
            Crear Usuario
        </button>

    </form>

    <!-- TABLA -->

    <h2>Usuarios Registrados</h2>

    <table>

        <tr>
            <th>ID</th>
            <th>Usuario</th>
            <th>Rol</th>
            <th>Acciones</th>
        </tr>

        <%
            try (Connection con = ConexionSeguridad.conectar()) {

                String sql =
                        "SELECT ID_USUARIO, USUARIO, ROL " +
                        "FROM USUARIOS " +
                        "ORDER BY ID_USUARIO";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ResultSet rs =
                        ps.executeQuery();

                while (rs.next()) {
        %>

        <tr>

            <td>
                <%= rs.getString("ID_USUARIO") %>
            </td>

            <td>
                <%= rs.getString("USUARIO") %>
            </td>

            <td>
                <%= rs.getString("ROL") %>
            </td>

            <td>

                <form action="eliminarUsuario"
                      method="post"
                      style="display:inline;">

                    <input type="hidden"
                           name="idUsuario"
                           value="<%= rs.getString("ID_USUARIO") %>">

                    <input type="hidden"
                           name="usuario"
                           value="<%= rs.getString("USUARIO") %>">

                    <input type="hidden"
                           name="rol"
                           value="<%= rs.getString("ROL") %>">

                    <button type="submit"
                            onclick="return confirm('¿Eliminar usuario?')">

                        Eliminar

                    </button>

                </form>

            </td>

        </tr>

        <%
                }

            } catch (Exception e) {

                out.println(
                        "<tr><td colspan='4'>Error: "
                                + e.getMessage()
                                + "</td></tr>"
                );
            }
        %>

    </table>

    <br>

    <a href="index.jsp">
        Volver al login
    </a>

</div>

</body>
</html>