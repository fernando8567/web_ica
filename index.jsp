<%-- 
    Document   : index
    Created on : 12/05/2026, 8:16:57 p. m.
    Author     : SALA-404
--%>

<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Sistema ICA</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family: Arial, Helvetica, sans-serif;
}

body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;

    background:
        linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)),
        url('https://images.unsplash.com/photo-1500937386664-56d1dfef3854?q=80&w=1600&auto=format&fit=crop');

    background-size:cover;
    background-position:center;
}

.login-container{
    width:420px;

    background:rgba(255,255,255,0.95);

    padding:40px;

    border-radius:18px;

    box-shadow:0px 8px 25px rgba(0,0,0,0.3);
}

.logo{
    text-align:center;
    margin-bottom:20px;
}

.logo h1{
    color:#2e7d32;
    font-size:32px;
}

.logo p{
    color:#555;
    margin-top:8px;
}

form{
    display:flex;
    flex-direction:column;
}

input, select{

    margin-bottom:15px;

    padding:14px;

    border:none;

    border-radius:10px;

    background:#f1f1f1;

    font-size:15px;
}

input:focus,
select:focus{
    outline:none;
    border:2px solid #2e7d32;
}

.btn{

    background:#2e7d32;

    color:white;

    border:none;

    padding:14px;

    border-radius:10px;

    font-size:16px;

    cursor:pointer;

    transition:0.3s;
}

.btn:hover{
    background:#1b5e20;
}

.error{
    background:#ffebee;
    color:#c62828;
    padding:10px;
    border-radius:8px;
    margin-bottom:15px;
    text-align:center;
}

.admin-link{
    text-align:center;
    margin-top:15px;
}

.admin-link a{
    color:#2e7d32;
    text-decoration:none;
    font-weight:bold;
    transition:0.3s;
}

.admin-link a:hover{
    color:#1b5e20;
}

.footer{
    text-align:center;
    margin-top:20px;
    color:#777;
    font-size:13px;
}

</style>

</head>

<body>

<div class="login-container">

    <div class="logo">
        <h1>ICA</h1>
        <p>Sistema de Inspección Fitosanitaria</p>
    </div>

    <% if (request.getParameter("error") != null) { %>

        <div class="error">
            Usuario o contraseña incorrectos
        </div>

    <% } %>

    <form action="login" method="post">

        <input type="text"
               name="usuario"
               placeholder="Usuario"
               required>

        <input type="password"
               name="contrasena"
               placeholder="Contraseña"
               required>

        <select name="rol" required>

            <option value="">Seleccione un rol</option>

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

        <button type="submit"
                class="btn"
                name="accion"
                value="ingresar">

            Iniciar Sesión

        </button>

    </form>

    <div class="admin-link">

        <a href="usuarios.jsp">
            Administrar usuarios
        </a>

    </div>

    <div class="footer">
        Instituto Colombiano Agropecuario - ICA
    </div>

</div>

</body>
</html>