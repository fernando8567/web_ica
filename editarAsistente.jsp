<%-- 
    Document   : editarAsistente
    Created on : 14/05/2026, 9:06:10 p. m.
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
            "SELECT * FROM ASISTENTE_TECNICO " +
            "WHERE ID_ASISTENTE=?";

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

<title>Editar Asistente Técnico</title>

<link rel="stylesheet" href="dashboard.css">

<style>

.container{

    width:700px;

    margin:40px auto;

    background:white;

    padding:30px;

    border-radius:15px;

    box-shadow:0px 5px 15px rgba(0,0,0,0.2);
}

.container h1{

    color:#2e7d32;

    margin-bottom:25px;
}

.container input{

    width:100%;

    padding:12px;

    margin-top:10px;

    border:1px solid #ccc;

    border-radius:8px;
}

.container button{

    margin-top:20px;

    padding:12px 20px;

    border:none;

    border-radius:8px;

    background:#2e7d32;

    color:white;

    cursor:pointer;
}

</style>

</head>

<body>

<div class="container">

    <h1>Editar Asistente Técnico</h1>

    <form action="actualizarAsistente"
          method="post">

        <input type="hidden"
               name="id"
               value="<%= rs.getInt("ID_ASISTENTE") %>">

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

        <label>Tarjeta Profesional</label>

        <input type="text"
               name="tarjeta"
               value="<%= rs.getString("NRO_TARJETA_PROFESIONAL") %>">

        <label>Registro ICA</label>

        <input type="text"
               name="registroIca"
               value="<%= rs.getString("NRO_REGISTRO_ICA") %>">

        <label>Estado</label>

        <input type="text"
               name="estado"
               value="<%= rs.getString("ESTADO") %>">

        <button type="submit">

            Actualizar Asistente

        </button>

    </form>

    <br>

    <a href="asistentes.jsp">

        ← Volver

    </a>

</div>

</body>
</html>