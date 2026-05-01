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

@WebServlet("/eliminarInspeccion")
public class EliminarInspeccionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idInforme = Integer.parseInt(request.getParameter("idInforme"));

        try (Connection con = ConexionBD.conectar()) {
            con.setAutoCommit(false);

            PreparedStatement psDetalle = con.prepareStatement("DELETE FROM DETALLE_INFORME_PLAGA WHERE ID_INFORME=?");
            psDetalle.setInt(1, idInforme);
            psDetalle.executeUpdate();

            PreparedStatement psInforme = con.prepareStatement("DELETE FROM INFORME_FITOSANITARIO WHERE ID_INFORME=?");
            psInforme.setInt(1, idInforme);
            psInforme.executeUpdate();

            con.commit();
            response.sendRedirect("inspeccion.jsp");

        } catch (Exception e) {
            response.getWriter().println("No se puede eliminar inspección: " + e.getMessage());
        }
    }
}