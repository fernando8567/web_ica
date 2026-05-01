<%-- 
    Document   : index.jsp
    Created on : 22/04/2026, 4:54:29 p. m.
    Author     : SALA-404
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="modelo.Usuario" %>

<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");

    if (u == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    if (!("admin".equals(u.getUsuario()) && "Inspector ICA".equals(u.getRol()))) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Usuarios</title>
<link rel="stylesheet" href="dashboard.css">
</head>

<body>

<div class="container">

    <jsp:include page="menu.jsp" />

    <div class="main">

        <div class="topbar">
            <h1>Gestión de Usuarios</h1>
            <p>Administrador: <%= u.getUsuario() %></p>
        </div>

        <% if (request.getParameter("ok") != null) { %>
            <p style="color:green; font-weight:bold;">Usuario creado correctamente</p>
        <% } %>

        <div class="tabla">
            <h2>Crear nuevo usuario</h2>

            <form action="crearUsuario" method="post">
                <p>
                    <input type="text" name="usuario" placeholder="Usuario" required>
                </p>

                <p>
                    <input type="password" name="contrasena" placeholder="Contraseña" required>
                </p>

                <p>
                    <select name="rol" required>
                        <option value="">Seleccione rol</option>
                        <option value="Productor">Productor</option>
                        <option value="Asistente Técnico">Asistente Técnico</option>
                        <option value="Inspector ICA">Inspector ICA</option>
                    </select>
                </p>

                <p>
                    <button type="submit">Guardar Usuario</button>
                </p>
            </form>

            <br>

            <a href="cambiarContrasena.jsp">
                <button>Cambiar contraseña</button>
            </a>
        </div>

    </div>

</div>

</body>
</html>