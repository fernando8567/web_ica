<%-- 
    Document   : cambiarContrasena
    Created on : 23/04/2026, 7:15:02 p. m.
    Author     : SALA-404
--%>

%@ page contentType="text/html; charset=UTF-8" %>
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
<title>Cambiar Contraseña</title>
<link rel="stylesheet" href="dashboard.css">
</head>

<body>

<div class="container">

    <jsp:include page="menu.jsp" />

    <div class="main">

        <div class="topbar">
            <h1>Cambiar Contraseña</h1>
            <p>Administrador: <%= u.getUsuario() %></p>
        </div>

        <% if (request.getParameter("ok") != null) { %>
            <p style="color:green; font-weight:bold;">Contraseña actualizada correctamente</p>
        <% } %>

        <div class="tabla">
            <h2>Actualizar contraseña de usuario</h2>

            <form action="cambiarContrasena" method="post">
                <p>
                    <input type="text" name="usuarioCambiar" placeholder="Usuario al que desea cambiar contraseña" required>
                </p>

                <p>
                    <input type="password" name="nuevaContrasena" placeholder="Nueva contraseña" required>
                </p>

                <p>
                    <button type="submit">Actualizar Contraseña</button>
                </p>
            </form>

            <br>

            <a href="usuarios.jsp">
                <button>Volver a usuarios</button>
            </a>
        </div>

    </div>

</div>

</body>
</html>