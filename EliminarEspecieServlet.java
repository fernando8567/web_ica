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

@WebServlet("/eliminarEspecie")
public class EliminarEspecieServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement("DELETE FROM ESPECIE WHERE ID_ESPECIE=?")) {

            ps.setInt(1, Integer.parseInt(request.getParameter("idEspecie")));
            ps.executeUpdate();
            response.sendRedirect("especies.jsp");

        } catch (Exception e) {
            response.getWriter().println("No se puede eliminar especie: " + e.getMessage());
        }
    }
}
