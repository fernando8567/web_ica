<%-- 
    Document   : asistentes
    Created on : 7/05/2026, 5:24:53 p. m.
    Author     : SALA-404
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="java.sql.*" %>

<%
    Usuario u =
            (Usuario) session.getAttribute("usuarioLogueado");

    if (u == null) {

        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

<meta charset="UTF-8">

<title>Gestión de Asistentes Técnicos</title>

<link rel="stylesheet" href="dashboard.css">

<style>

.tabla{
    margin-top:30px;
}

table{
    width:100%;
    border-collapse:collapse;
    background:white;
    border-radius:12px;
    overflow:hidden;
    box-shadow:0px 5px 15px rgba(0,0,0,0.1);
}

th{
    background:#2e7d32;
    color:white;
    padding:14px;
    text-align:center;
}

td{
    padding:12px;
    border-bottom:1px solid #ddd;
    text-align:center;
}

tr:hover{
    background:#f5f5f5;
}

button{

    padding:10px 15px;

    border:none;

    border-radius:8px;

    background:#2e7d32;

    color:white;

    cursor:pointer;
}

button:hover{
    background:#1b5e20;
}

.topbar{
    margin-bottom:20px;
}

.buscador{
    margin-bottom:25px;
}

.buscador input{

    width:350px;

    padding:12px;

    border-radius:8px;

    border:1px solid #ccc;
}

.card-total{

    background:white;

    padding:20px;

    border-radius:12px;

    margin-bottom:20px;

    box-shadow:0px 5px 15px rgba(0,0,0,0.1);
}

</style>

</head>

<body>

<div class="container">

    <jsp:include page="menu.jsp" />

    <div class="main">

        <div class="topbar">

            <h1>Gestión de Asistentes Técnicos</h1>

            <p>

                Usuario:
                <strong>
                    <%= u.getUsuario() %>
                </strong>

            </p>

        </div>

        <!-- TOTAL -->

        <div class="card-total">

            <%
                try(Connection con =
                            ConexionBD.conectar()) {

                    String sqlTotal =
                            "SELECT COUNT(*) TOTAL " +
                            "FROM ASISTENTE_TECNICO";

                    PreparedStatement psTotal =
                            con.prepareStatement(sqlTotal);

                    ResultSet rsTotal =
                            psTotal.executeQuery();

                    rsTotal.next();
            %>

                <h3>

                    Total asistentes técnicos:
                    <%= rsTotal.getInt("TOTAL") %>

                </h3>

            <%
                } catch(Exception e){

                    out.println("Error");
                }
            %>

        </div>

        <!-- BUSCADOR -->

        <div class="buscador">

            <form method="get"
                  action="asistentes.jsp">

                <input type="text"
                       name="buscar"
                       placeholder="Buscar por nombre, cédula o registro ICA">

                <button type="submit">

                    Buscar

                </button>

            </form>

        </div>

        <!-- TABLA -->

        <div class="tabla">

            <table>

                <tr>

                    <th>ID</th>

                    <th>Identidad</th>

                    <th>Nombre</th>

                    <th>Dirección</th>

                    <th>Teléfono</th>

                    <th>Correo</th>

                    <th>Tarjeta Profesional</th>

                    <th>Registro ICA</th>

                    <th>Estado</th>

                    <th>Acciones</th>

                </tr>

                <%

                    String buscar =
                            request.getParameter("buscar");

                    try(Connection con =
                                ConexionBD.conectar()) {

                        String sql;

                        PreparedStatement ps;

                        // BUSQUEDA

                        if (buscar != null
                                && !buscar.trim().isEmpty()) {

                            sql =
                                "SELECT * FROM ASISTENTE_TECNICO " +
                                "WHERE " +
                                "UPPER(NOMBRE) LIKE UPPER(?) " +
                                "OR UPPER(NRO_IDENTIDAD) LIKE UPPER(?) " +
                                "OR UPPER(NRO_REGISTRO_ICA) LIKE UPPER(?) " +
                                "ORDER BY ID_ASISTENTE";

                            ps =
                                con.prepareStatement(sql);

                            ps.setString(1,
                                    "%" + buscar + "%");

                            ps.setString(2,
                                    "%" + buscar + "%");

                            ps.setString(3,
                                    "%" + buscar + "%");

                        }

                        // TODOS

                        else {

                            sql =
                                "SELECT * FROM ASISTENTE_TECNICO " +
                                "ORDER BY ID_ASISTENTE";

                            ps =
                                con.prepareStatement(sql);
                        }

                        ResultSet rs =
                                ps.executeQuery();

                        boolean existe = false;

                        while (rs.next()) {

                            existe = true;

                %>

                <tr>

                    <td>
                        <%= rs.getInt("ID_ASISTENTE") %>
                    </td>

                    <td>
                        <%= rs.getString("NRO_IDENTIDAD") %>
                    </td>

                    <td>
                        <%= rs.getString("NOMBRE") %>
                    </td>

                    <td>
                        <%= rs.getString("DIRECCION") %>
                    </td>

                    <td>
                        <%= rs.getString("TELEFONO") %>
                    </td>

                    <td>
                        <%= rs.getString("EMAIL") %>
                    </td>

                    <td>
                        <%= rs.getString("NRO_TARJETA_PROFESIONAL") %>
                    </td>

                    <td>
                        <%= rs.getString("NRO_REGISTRO_ICA") %>
                    </td>

                    <td>
                        <%= rs.getString("ESTADO") %>
                    </td>

                    <td>

                        <a href="editarAsistente.jsp?id=<%= rs.getInt("ID_ASISTENTE") %>">

                            <button type="button">

                                Modificar

                            </button>

                        </a>

                    </td>

                </tr>

                <%

                        }

                        // SI NO ENCUENTRA

                        if(!existe){
                %>

                    <tr>

                        <td colspan="10">

                            No se encontraron asistentes técnicos

                        </td>

                    </tr>

                <%
                        }

                    } catch(Exception e){

                        out.println(
                            "<tr><td colspan='10'>Error: "
                            + e.getMessage()
                            + "</td></tr>"
                        );
                    }

                %>

            </table>

        </div>

    </div>

</div>

</body>
</html>