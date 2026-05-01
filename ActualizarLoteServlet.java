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

@WebServlet("/actualizarLote")
public class ActualizarLoteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sql = "UPDATE LOTE SET ID_LUGAR=?, ID_ESPECIE=?, NUMERO=?, AREA_HA=?, FECHA_SIEMBRA=?, FECHA_ELIMINACION=? WHERE ID_LOTE=?";

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(request.getParameter("idLugar")));
            ps.setInt(2, Integer.parseInt(request.getParameter("idEspecie")));
            ps.setString(3, request.getParameter("numero"));
            ps.setDouble(4, Double.parseDouble(request.getParameter("areaHa")));
            ps.setDate(5, Date.valueOf(request.getParameter("fechaSiembra")));

            String fechaEliminacion = request.getParameter("fechaEliminacion");
            if (fechaEliminacion == null || fechaEliminacion.isEmpty()) {
                ps.setNull(6, Types.DATE);
            } else {
                ps.setDate(6, Date.valueOf(fechaEliminacion));
            }

            ps.setInt(7, Integer.parseInt(request.getParameter("idLote")));

            ps.executeUpdate();
            response.sendRedirect("lotes.jsp");

        } catch (Exception e) {
            response.getWriter().println("Error al actualizar lote: " + e.getMessage());
        }
    }
}