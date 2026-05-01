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
import java.sql.Date;

@WebServlet("/guardarProduccion")
public class GuardarProduccionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sql = "INSERT INTO PRODUCCION (ID_LOTE, TIPO, FECHA_RECOLECCION, CANTIDAD_KG) "
                   + "VALUES (?, ?, ?, ?)";

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(request.getParameter("idLote")));
            ps.setString(2, request.getParameter("tipo"));
            ps.setDate(3, Date.valueOf(request.getParameter("fechaRecoleccion")));
            ps.setDouble(4, Double.parseDouble(request.getParameter("cantidadKg")));

            ps.executeUpdate();
            response.sendRedirect("produccion.jsp?ok=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al guardar producción: " + e.getMessage());
        }
    }
}