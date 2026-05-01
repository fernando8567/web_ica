<%-- 
    Document   : index.jsp
    Created on : 22/04/2026, 4:54:29 p. m.
    Author     : SALA-404
--%>

<%@ page import="modelo.Usuario" %>
<%
    Usuario usuarioMenu = (Usuario) session.getAttribute("usuarioLogueado");

    String rolMenu = "";
    String userMenu = "";

    if (usuarioMenu != null) {
        rolMenu = usuarioMenu.getRol();
        userMenu = usuarioMenu.getUsuario();
    }
%>

<div class="sidebar">
    <h2>AgroControl</h2>
    <ul>
        <li><a href="dashboard.jsp">? Dashboard</a></li>
        <li><a href="productores.jsp">??? Productores</a></li>
        <li><a href="lugarProduccion.jsp">? Lugar Producción</a></li>
        <li><a href="especies.jsp">? Especies</a></li>
        <li><a href="lotes.jsp">? Lotes</a></li>
        <li><a href="informe.jsp">? Informe ICA</a></li>
        <li><a href="inspeccion.jsp">? Inspección</a></li>
        <li><a href="produccion.jsp">? Producción</a></li>

        <% if ("admin".equals(userMenu) && "Inspector ICA".equals(rolMenu)) { %>
            <li><a href="usuarios.jsp">? Nuevo Usuario</a></li>
            <li><a href="cambiarContrasena.jsp">? Cambiar contraseña</a></li>
        <% } %>

        <li><a href="logout">? Cerrar sesión</a></li>
    </ul>
</div>