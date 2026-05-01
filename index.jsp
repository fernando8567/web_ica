<%-- 
    Document   : index.jsp
    Created on : 22/04/2026, 4:54:29 p. m.
    Author     : SALA-404
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Sistema de Inspección Fitosanitaria</title>
<link rel="stylesheet" href="styles.css">
</head>
<body>

<section class="login">
    <div class="login-box">
        <h2>Sistema de Inspección Fitosanitaria</h2>

        <% if (request.getParameter("error") != null) { %>
            <p style="color:red; margin-bottom:10px;">Credenciales incorrectas</p>
        <% } %>

        <form action="login" method="post">

    <input type="text" name="usuario" placeholder="Usuario" required>
    <input type="password" name="contrasena" placeholder="Contraseña" required>

    <select name="rol" required>
        <option value="">Seleccione un rol</option>
        <option value="Productor">Productor</option>
        <option value="Asistente Técnico">Asistente Técnico</option>
        <option value="Inspector ICA">Inspector ICA</option>
    </select>

    <button type="submit" name="accion" value="ingresar">Ingresar</button>

    <button type="submit" name="accion" value="admin">
        Administrador
    </button>

    </form>
    </div>
</section>

</body>
</html>