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

@WebServlet("/actualizarEspecie")
public class ActualizarEspecieServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idEspecie = Integer.parseInt(request.getParameter("idEspecie"));
        String idPlaga = request.getParameter("idPlaga");

        String sqlEspecie =
            "UPDATE ESPECIE SET " +
            "NOMBRE_CIENTIFICO=?, " +
            "NOMBRES_COMUNES=?, " +
            "VARIEDAD=?, " +
            "CICLO=? " +
            "WHERE ID_ESPECIE=?";

        try (Connection con = ConexionBD.conectar()) {

            con.setAutoCommit(false);

            PreparedStatement ps = con.prepareStatement(sqlEspecie);

            ps.setString(1, request.getParameter("nombreCientifico"));
            ps.setString(2, request.getParameter("nombresComunes"));
            ps.setString(3, request.getParameter("variedad"));
            ps.setString(4, request.getParameter("ciclo"));
            ps.setInt(5, idEspecie);

            ps.executeUpdate();

            PreparedStatement psDeleteRelacion = con.prepareStatement(
                    "DELETE FROM ESPECIE_PLAGA WHERE ID_ESPECIE=?"
            );

            psDeleteRelacion.setInt(1, idEspecie);
            psDeleteRelacion.executeUpdate();

            if (idPlaga != null && !idPlaga.trim().isEmpty()) {
                PreparedStatement psRelacion = con.prepareStatement(
                        "INSERT INTO ESPECIE_PLAGA (ID_ESPECIE, ID_PLAGA) VALUES (?, ?)"
                );

                psRelacion.setInt(1, idEspecie);
                psRelacion.setInt(2, Integer.parseInt(idPlaga));

                psRelacion.executeUpdate();
            }

            con.commit();

            response.sendRedirect("especies.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al actualizar especie: " + e.getMessage());
        }
    }
}