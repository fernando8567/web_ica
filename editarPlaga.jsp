<%-- 
    Document   : editarPlaga
    Created on : 14/05/2026, 7:50:42 p. m.
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
            "SELECT * FROM PLAGA WHERE ID_PLAGA = ?";

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

<title>Editar Plaga</title>

<link rel="stylesheet" href="dashboard.css">

<style>

.container-editar{

    width:600px;

    margin:40px auto;

    background:white;

    padding:30px;

    border-radius:15px;

    box-shadow:0px 5px 15px rgba(0,0,0,0.2);
}

.container-editar h1{

    color:#2e7d32;

    margin-bottom:25px;
}

.container-editar input{

    width:100%;

    padding:12px;

    margin-top:10px;

    border:1px solid #ccc;

    border-radius:8px;
}

.container-editar button{

    margin-top:20px;

    padding:12px 20px;

    border:none;

    border-radius:8px;

    background:#2e7d32;

    color:white;

    cursor:pointer;
}

.container-editar button:hover{

    background:#1b5e20;
}

.imagen{

    margin-top:20px;
}

.imagen img{

    border-radius:12px;

    object-fit:cover;
}

</style>

</head>

<body>

<div class="container-editar">

    <h1>Editar Plaga</h1>

    <form action="actualizarPlaga"
          method="post"
          enctype="multipart/form-data">

        <input type="hidden"
               name="id"
               value="<%= rs.getString("ID_PLAGA") %>">

        <label>
            Nombre científico
        </label>

        <input type="text"
               name="nombreCientifico"
               value="<%= rs.getString("NOMBRE_CIENTIFICO") %>"
               required>

        <label>
            Nombres comunes
        </label>

        <input type="text"
               name="nombresComunes"
               value="<%= rs.getString("NOMBRES_COMUNES") %>"
               required>

        <div class="imagen">

            <p><strong>Foto actual:</strong></p>

            <%
                String foto =
                        rs.getString("FOTO");

                if(foto != null && !foto.isEmpty()){
            %>

                <img src="imagenes/plagas/<%= foto %>"
                     width="250"
                     height="180">

            <%
                } else {
            %>

                <p>Sin foto</p>

            <%
                }
            %>

        </div>

        <br>

        <label>
            Nueva foto
        </label>

        <input type="file"
               name="foto"
               accept="image/*">

        <button type="submit">
            Actualizar Plaga
        </button>

    </form>

    <br>

    <a href="especies.jsp">
        ← Volver
    </a>

</div>

</body>
</html>