<%-- 
    Document   : index.jsp
    Created on : 22/04/2026, 4:54:29 p. m.
    Author     : SALA-404
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="java.sql.*" %>

<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");

    if (u == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String usuarioSesion = (String) session.getAttribute("usuario");
    String rolSesion = (String) session.getAttribute("rol");
%>

<!DOCTYPE html>
<html lang="es">

<head>
<meta charset="UTF-8">
<title>Informe Fitosanitario ICA</title>

<link rel="stylesheet" href="dashboard.css">

<style>
.formulario, .tabla {
    background: white;
    padding: 25px;
    border-radius: 15px;
    margin-top: 25px;
    box-shadow: 0px 5px 15px rgba(0,0,0,0.1);
}

input, select, textarea {
    width: 100%;
    padding: 12px;
    margin-top: 10px;
    border-radius: 8px;
    border: 1px solid #ccc;
}

button {
    margin-top: 20px;
    padding: 12px 18px;
    border: none;
    border-radius: 8px;
    background: #2e7d32;
    color: white;
    cursor: pointer;
}

button:hover {
    background: #1b5e20;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

th {
    background: #2e7d32;
    color: white;
    padding: 12px;
}

td {
    padding: 12px;
    border-bottom: 1px solid #ddd;
    text-align: center;
}

.buscar {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
}

.buscar input {
    flex: 1;
}

.alerta-baja {
    background: #c8e6c9;
    color: #1b5e20;
    font-weight: bold;
}

.alerta-media {
    background: #fff9c4;
    color: #f57f17;
    font-weight: bold;
}

.alerta-alta {
    background: #ffcdd2;
    color: #b71c1c;
    font-weight: bold;
}
</style>
</head>

<body>

<div class="container">

    <jsp:include page="menu.jsp" />

    <div class="main">

        <div class="topbar">
            <h1>Informe Fitosanitario ICA</h1>
            <p>
                Usuario: <strong><%= u.getUsuario() %></strong>
            </p>
        </div>

        <!-- FORMULARIO -->
        <div class="formulario">

            <h2>Registrar Informe</h2>

            <form action="guardarInforme" method="post">

                <!-- LOTE -->
                <label>Lote</label>
                <select name="idLote" required>
                    <option value="">Seleccione lote</option>

                    <%
                        try (Connection con = ConexionBD.conectar()) {
                            String sql = "SELECT ID_LOTE, NUMERO FROM LOTE";
                            PreparedStatement ps = con.prepareStatement(sql);
                            ResultSet rs = ps.executeQuery();

                            while (rs.next()) {
                    %>

                    <option value="<%= rs.getInt("ID_LOTE") %>">
                        Lote <%= rs.getString("NUMERO") %>
                    </option>

                    <%
                            }
                        }
                    %>
                </select>

                <!-- ASISTENTE -->
                <label>Asistente Técnico</label>
                <select name="idAsistente" required>
                    <option value="">Seleccione asistente</option>

                    <%
                        try (Connection con = ConexionBD.conectar()) {
                            String sql = "SELECT ID_ASISTENTE, NOMBRE FROM ASISTENTE_TECNICO";
                            PreparedStatement ps = con.prepareStatement(sql);
                            ResultSet rs = ps.executeQuery();

                            while (rs.next()) {
                    %>

                    <option value="<%= rs.getInt("ID_ASISTENTE") %>">
                        <%= rs.getString("NOMBRE") %>
                    </option>

                    <%
                            }
                        }
                    %>
                </select>

                <!-- PLAGA -->
                <label>Plaga</label>
                <select name="idPlaga" required>
                    <option value="">Seleccione plaga</option>

                    <%
                        try (Connection con = ConexionBD.conectar()) {
                            String sql = "SELECT ID_PLAGA, NOMBRE_CIENTIFICO FROM PLAGA";
                            PreparedStatement ps = con.prepareStatement(sql);
                            ResultSet rs = ps.executeQuery();

                            while (rs.next()) {
                    %>

                    <option value="<%= rs.getInt("ID_PLAGA") %>">
                        <%= rs.getString("NOMBRE_CIENTIFICO") %>
                    </option>

                    <%
                            }
                        }
                    %>
                </select>

                <label>Estado Fenológico</label>
                <input type="text" name="estadoFenologico" required>

                <label>Área (HA)</label>
                <input type="number" step="0.01" name="areaHa" required>

                <label>Cantidad Plantas</label>
                <input type="number" name="cantPlantas" required>

                <label>Plantas Infestadas</label>
                <input type="number" name="plantasInfestadas" required>

                <label>Observaciones ICA</label>
                <textarea name="observaciones" rows="4"></textarea>

                <button type="submit">Guardar Informe</button>

            </form>
        </div>

        <!-- TABLA -->
        <div class="tabla">

            <h2>Informes Registrados</h2>

            <!-- BUSCADOR -->
            <form method="get" class="buscar">
                <input type="text" name="buscar"
                    placeholder="Buscar productor, lote, plaga o municipio"
                    value="<%= request.getParameter("buscar") == null ? "" : request.getParameter("buscar") %>">

                <button type="submit">Buscar</button>
            </form>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Productor</th>
                    <th>Lugar Producción</th>
                    <th>Municipio</th>
                    <th>Lote</th>
                    <th>Especie</th>
                    <th>Asistente</th>
                    <th>Fecha</th>
                    <th>Estado</th>
                    <th>Área</th>
                    <th>Plantas</th>
                    <th>Plaga</th>
                    <th>Infestadas</th>
                    <th>% Infestación</th>
                    <th>Nivel Alerta</th>
                    <th>Observaciones</th>
                    <th>Acciones</th>
                </tr>

                <%
                    try (Connection con = ConexionBD.conectar()) {

                        String buscar = request.getParameter("buscar");

                        String sql =
                            "SELECT I.ID_INFORME, PR.NOMBRE PRODUCTOR, LP.NOMBRE LUGAR, " +
                            "LP.MUNICIPIO, L.NUMERO LOTE, E.NOMBRE_CIENTIFICO ESPECIE, " +
                            "A.NOMBRE ASISTENTE, I.FECHA, I.ESTADO_FENOLOGICO, I.AREA_HA, " +
                            "I.CANT_PLANTAS, PL.NOMBRE_CIENTIFICO PLAGA, D.PLANTAS_INFESTADAS, " +
                            "D.PORCENTAJE_INFESTACION, I.OBSERVACIONES " +
                            "FROM INFORME_FITOSANITARIO I " +
                            "INNER JOIN LOTE L ON I.ID_LOTE = L.ID_LOTE " +
                            "INNER JOIN ESPECIE E ON L.ID_ESPECIE = E.ID_ESPECIE " +
                            "INNER JOIN LUGAR_PRODUCCION LP ON L.ID_LUGAR = LP.ID_LUGAR " +
                            "INNER JOIN PRODUCTOR PR ON LP.ID_PRODUCTOR = PR.ID_PRODUCTOR " +
                            "INNER JOIN ASISTENTE_TECNICO A ON I.ID_ASISTENTE = A.ID_ASISTENTE " +
                            "INNER JOIN DETALLE_INFORME_PLAGA D ON I.ID_INFORME = D.ID_INFORME " +
                            "INNER JOIN PLAGA PL ON D.ID_PLAGA = PL.ID_PLAGA ";

                        if (buscar != null && !buscar.trim().isEmpty()) {
                            sql += "WHERE UPPER(PR.NOMBRE) LIKE ? " +
                                   "OR UPPER(L.NUMERO) LIKE ? " +
                                   "OR UPPER(PL.NOMBRE_CIENTIFICO) LIKE ? " +
                                   "OR UPPER(LP.MUNICIPIO) LIKE ? ";
                        }

                        sql += "ORDER BY I.ID_INFORME DESC";

                        PreparedStatement ps = con.prepareStatement(sql);

                        if (buscar != null && !buscar.trim().isEmpty()) {
                            String filtro = "%" + buscar.toUpperCase() + "%";
                            ps.setString(1, filtro);
                            ps.setString(2, filtro);
                            ps.setString(3, filtro);
                            ps.setString(4, filtro);
                        }

                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {

                            double porcentaje = rs.getDouble("PORCENTAJE_INFESTACION");
                %>

                <tr>
                    <td><%= rs.getInt("ID_INFORME") %></td>
                    <td><%= rs.getString("PRODUCTOR") %></td>
                    <td><%= rs.getString("LUGAR") %></td>
                    <td><%= rs.getString("MUNICIPIO") %></td>
                    <td><%= rs.getString("LOTE") %></td>
                    <td><%= rs.getString("ESPECIE") %></td>
                    <td><%= rs.getString("ASISTENTE") %></td>
                    <td><%= rs.getDate("FECHA") %></td>
                    <td><%= rs.getString("ESTADO_FENOLOGICO") %></td>
                    <td><%= rs.getDouble("AREA_HA") %></td>
                    <td><%= rs.getInt("CANT_PLANTAS") %></td>
                    <td><%= rs.getString("PLAGA") %></td>
                    <td><%= rs.getInt("PLANTAS_INFESTADAS") %></td>
                    <td><%= porcentaje %>%</td>

                    <td class="<%= porcentaje <= 10 ? "alerta-baja"
                            : porcentaje <= 30 ? "alerta-media"
                            : "alerta-alta" %>">

                        <%= (porcentaje <= 10) ? "BAJO"
                            : (porcentaje <= 30) ? "MEDIO"
                            : "ALTO" %>

                    </td>

                    <td><%= rs.getString("OBSERVACIONES") %></td>

                    <td>

                        <a href="editarInforme.jsp?id=<%= rs.getInt("ID_INFORME") %>">
                            <button type="button">Modificar</button>
                        </a>

                        <a href="generarPdfInforme?id=<%= rs.getInt("ID_INFORME") %>" target="_blank">
                            <button type="button">PDF</button>
                        </a>

                        <%
                            if ("admin".equals(usuarioSesion)
                                && "Inspector ICA".equals(rolSesion)) {
                        %>

                        <form action="eliminarInforme" method="post" style="display:inline;">
                            <input type="hidden" name="idInforme" value="<%= rs.getInt("ID_INFORME") %>">
                            <button type="submit"
                                onclick="return confirm('¿Eliminar informe?')">
                                Eliminar
                            </button>
                        </form>

                        <%
                            }
                        %>

                    </td>
                </tr>

                <%
                        }
                    }
                %>

            </table>
        </div>
    </div>
</div>

</body>
</html>