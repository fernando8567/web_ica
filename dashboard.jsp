<%-- 
    Document   : dashboard.jsp
    Created on : 22/04/2026, 4:55:14 p. m.
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
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Dashboard</title>
<link rel="stylesheet" href="dashboard.css">
</head>

<body>

<div class="container">

    <jsp:include page="menu.jsp" />

    <div class="main">
        <div class="topbar">
            <h1>Dashboard Principal</h1>
            <p>Bienvenido, <%= u.getUsuario() %> - Rol: <%= u.getRol() %></p>
        </div>

        <div class="cards">
            <div class="card verde">
                <h3>Lugares Registrados</h3>
                <p>12</p>
            </div>

            <div class="card naranja">
                <h3>Lotes Activos</h3>
                <p>8</p>
            </div>

            <div class="card rojo">
                <h3>Inspecciones Pendientes</h3>
                <p>3</p>
            </div>

            <div class="card verde">
                <h3>Producción Registrada</h3>
                <p>25</p>
            </div>
        </div>

        <div class="tabla">
            <h2>Inspecciones Recientes</h2>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Lote</th>
                    <th>Asistente</th>
                    <th>Fecha</th>
                    <th>Estado Fenológico</th>
                </tr>

                <tr>
                    <td>1</td>
                    <td>Lote 1</td>
                    <td>Asistente 1</td>
                    <td>2026-04-23</td>
                    <td>Floración</td>
                </tr>
            </table>
        </div>

    </div>

</div>

</body>
</html>