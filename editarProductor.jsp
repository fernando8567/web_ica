<%-- 
    Document   : editarProductor
    Created on : 14/05/2026, 8:46:09 p. m.
    Author     : SALA-404
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="java.sql.*" %>

<%

    int id =
            Integer.parseInt(
                    request.getParameter("id")
            );

    Connection con =
            ConexionBD.conectar();

    String sql =
            "SELECT * FROM PRODUCTOR WHERE ID_PRODUCTOR=?";

    PreparedStatement ps =
            con.prepareStatement(sql);

    ps.setInt(1, id);

    ResultSet rs =
            ps.executeQuery();

    rs.next();

%>

<!DOCTYPE html>
<html lang="es">

<head>

<meta charset="UTF-8">

<title>Editar Productor</title>

<link rel="stylesheet" href="dashboard.css">

<style>

.contenedor{

    width:700px;

    margin:40px auto;

    background:white;

    padding:30px;

    border-radius:15px;

    box-shadow:0px 5px 15px rgba(0,0,0,0.2);
}

.contenedor h1{

    color:#2e7d32;

    margin-bottom:25px;
}

.contenedor input{

    width:100%;

    padding:12px;

    margin-top:10px;

    border:1px solid #ccc;

    border-radius:8px;
}

.contenedor button{

    margin-top:20px;

    padding:12px 20px;

    border:none;

    border-radius:8px;

    background:#2e7d32;

    color:white;

    cursor:pointer;
}

.contenedor button:hover{

    background:#1b5e20;
}

</style>

</head>

<body>

<div class="contenedor">

    <h1>Editar Productor</h1>

    <form action="actualizarProductor"
          method="post">

        <input type="hidden"
               name="id"
               value="<%= rs.getInt("ID_PRODUCTOR") %>">

        <label>Nombre</label>

        <input type="text"
               name="nombre"
               value="<%= rs.getString("NOMBRE") %>"
               required>

        <label>Dirección</label>

        <input type="text"
               name="direccion"
               value="<%= rs.getString("DIRECCION") %>">

        <label>Teléfono</label>

        <input type="text"
               name="telefono"
               value="<%= rs.getString("TELEFONO") %>">

        <label>Email</label>

        <input type="email"
               name="email"
               value="<%= rs.getString("EMAIL") %>">

        <label>Registro ICA</label>

        <input type="text"
               name="registroIca"
               value="<%= rs.getString("NRO_REGISTRO_ICA") %>">

        <label>Estado</label>

        <input type="text"
               name="estado"
               value="<%= rs.getString("ESTADO") %>">

        <button type="submit">

            Actualizar Productor

        </button>

    </form>

    <br>

    <a href="productores.jsp">

        ← Volver

    </a>

</div>

</body>
</html>