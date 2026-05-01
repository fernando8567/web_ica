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

@WebServlet("/actualizarProduccion")
public class ActualizarProduccionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sql = "UPDATE PRODUCCION SET ID_LOTE=?, TIPO=?, FECHA_RECOLECCION=?, CANTIDAD_KG=? WHERE ID_PRODUCCION=?";

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(request.getParameter("idLote")));
            ps.setString(2, request.getParameter("tipo"));
            ps.setDate(3, Date.valueOf(request.getParameter("fechaRecoleccion")));
            ps.setDouble(4, Double.parseDouble(request.getParameter("cantidadKg")));
            ps.setInt(5, Integer.parseInt(request.getParameter("idProduccion")));

            ps.executeUpdate();

            response.sendRedirect("produccion.jsp");

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}