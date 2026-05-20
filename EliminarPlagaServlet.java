/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import conexion.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/eliminarPlaga")
public class EliminarPlagaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idPlaga = Integer.parseInt(request.getParameter("idPlaga"));

        try (Connection con = ConexionBD.conectar()) {

            con.setAutoCommit(false);

            PreparedStatement psRelacion = con.prepareStatement(
                "DELETE FROM ESPECIE_PLAGA WHERE ID_PLAGA = ?"
            );
            psRelacion.setInt(1, idPlaga);
            psRelacion.executeUpdate();

            PreparedStatement psDetalle = con.prepareStatement(
                "DELETE FROM DETALLE_INFORME_PLAGA WHERE ID_PLAGA = ?"
            );
            psDetalle.setInt(1, idPlaga);
            psDetalle.executeUpdate();

            PreparedStatement psPlaga = con.prepareStatement(
                "DELETE FROM PLAGA WHERE ID_PLAGA = ?"
            );
            psPlaga.setInt(1, idPlaga);
            psPlaga.executeUpdate();

            con.commit();

            response.sendRedirect("especies.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al eliminar plaga: " + e.getMessage());
        }
    }
}