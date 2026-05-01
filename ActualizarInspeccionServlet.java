/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import conexion.ConexionBD;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.sql.*;

@WebServlet("/actualizarInspeccion")
public class ActualizarInspeccionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sql = "UPDATE INFORME_FITOSANITARIO SET ID_LOTE=?, ID_ASISTENTE=?, FECHA=?, ESTADO_FENOLOGICO=?, AREA_HA=?, CANT_PLANTAS=? WHERE ID_INFORME=?";

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(request.getParameter("idLote")));
            ps.setInt(2, Integer.parseInt(request.getParameter("idAsistente")));
            ps.setDate(3, Date.valueOf(request.getParameter("fecha")));
            ps.setString(4, request.getParameter("estadoFenologico"));
            ps.setDouble(5, Double.parseDouble(request.getParameter("areaHa")));
            ps.setInt(6, Integer.parseInt(request.getParameter("cantPlantas")));
            ps.setInt(7, Integer.parseInt(request.getParameter("idInforme")));

            ps.executeUpdate();
            response.sendRedirect("informe.jsp?id=" + request.getParameter("idInforme"));

        } catch (Exception e) {
            response.getWriter().println("Error al actualizar inspección: " + e.getMessage());
        }
    }
}
