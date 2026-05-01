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

@WebServlet("/guardarProductor")
public class GuardarProductorServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sql = "INSERT INTO PRODUCTOR "
                   + "(NRO_IDENTIDAD, NOMBRE, DIRECCION, TELEFONO, EMAIL, NRO_REGISTRO_ICA, ESTADO) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, request.getParameter("nroIdentidad"));
            ps.setString(2, request.getParameter("nombre"));
            ps.setString(3, request.getParameter("direccion"));
            ps.setString(4, request.getParameter("telefono"));
            ps.setString(5, request.getParameter("email"));
            ps.setString(6, request.getParameter("nroRegistroIca"));
            ps.setString(7, request.getParameter("estado"));

            ps.executeUpdate();

            response.sendRedirect("productores.jsp?ok=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al guardar productor: " + e.getMessage());
        }
    }
}