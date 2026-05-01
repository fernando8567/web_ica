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

@WebServlet("/actualizarEspecie")
public class ActualizarEspecieServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sql = "UPDATE ESPECIE SET NOMBRE_CIENTIFICO=?, NOMBRES_COMUNES=?, VARIEDAD=?, CICLO=? WHERE ID_ESPECIE=?";

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, request.getParameter("nombreCientifico"));
            ps.setString(2, request.getParameter("nombresComunes"));
            ps.setString(3, request.getParameter("variedad"));
            ps.setString(4, request.getParameter("ciclo"));
            ps.setInt(5, Integer.parseInt(request.getParameter("idEspecie")));

            ps.executeUpdate();
            response.sendRedirect("especies.jsp");

        } catch (Exception e) {
            response.getWriter().println("Error al actualizar especie: " + e.getMessage());
        }
    }
}
