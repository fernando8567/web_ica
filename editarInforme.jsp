<%-- 
    Document   : editarInforme
    Created on : 19/05/2026, 7:57:14 p. m.
    Author     : SALA-404
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="java.sql.*" %>

<%
    int idInforme =
            Integer.parseInt(
                    request.getParameter("id")
            );

    Connection con =
            ConexionBD.conectar();

    String sql =

        "SELECT I.*, " +

        "D.ID_PLAGA, " +

        "D.PLANTAS_INFESTADAS, " +

        "D.PORCENTAJE_INFESTACION " +

        "FROM INFORME_FITOSANITARIO I " +

        "INNER JOIN DETALLE_INFORME_PLAGA D " +

        "ON I.ID_INFORME = D.ID_INFORME " +

        "WHERE I.ID_INFORME=?";

    PreparedStatement ps =
            con.prepareStatement(sql);

    ps.setInt(1, idInforme);

    ResultSet rs =
            ps.executeQuery();

    rs.next();
%>

<!DOCTYPE html>
<html lang="es">

<head>

<meta charset="UTF-8">

<title>Editar Informe</title>

<link rel="stylesheet" href="dashboard.css">

<style>

.formulario{

    background:white;

    padding:30px;

    border-radius:15px;

    box-shadow:0px 5px 15px rgba(0,0,0,0.1);

    margin-top:20px;
}

input,
textarea{

    width:100%;

    padding:12px;

    margin-top:10px;

    border-radius:8px;

    border:1px solid #ccc;
}

button{

    margin-top:20px;

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

</style>

</head>

<body>

<div class="container">

    <jsp:include page="menu.jsp" />

    <div class="main">

        <div class="topbar">

            <h1>Modificar Informe ICA</h1>

        </div>

        <div class="formulario">

            <form action="actualizarInforme"
                  method="post">

                <input type="hidden"
                       name="idInforme"
                       value="<%= rs.getInt("ID_INFORME") %>">

                <label>Estado Fenológico</label>

                <input type="text"
                       name="estadoFenologico"
                       value="<%= rs.getString("ESTADO_FENOLOGICO") %>"
                       required>

                <label>Área HA</label>

                <input type="number"
                       step="0.01"
                       name="areaHa"
                       value="<%= rs.getDouble("AREA_HA") %>"
                       required>

                <label>Cantidad Plantas</label>

                <input type="number"
                       name="cantPlantas"
                       value="<%= rs.getInt("CANT_PLANTAS") %>"
                       required>

                <label>Plantas Infestadas</label>

                <input type="number"
                       name="plantasInfestadas"
                       value="<%= rs.getInt("PLANTAS_INFESTADAS") %>"
                       required>

                <label>Observaciones</label>

                <textarea name="observaciones"
                          rows="4"><%= rs.getString("OBSERVACIONES") %></textarea>

                <button type="submit">

                    Actualizar Informe

                </button>

            </form>

        </div>

    </div>

</div>

</body>
</html>