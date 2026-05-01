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

@WebServlet("/eliminarProduccion")
public class EliminarProduccionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(
                     "DELETE FROM PRODUCCION WHERE ID_PRODUCCION=?")) {

            ps.setInt(1, Integer.parseInt(request.getParameter("idProduccion")));
            ps.executeUpdate();

            response.sendRedirect("produccion.jsp");

        } catch (Exception e) {
            response.getWriter().println("Error al eliminar: " + e.getMessage());
        }
    }
}