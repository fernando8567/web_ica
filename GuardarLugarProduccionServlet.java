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

@WebServlet("/guardarLugarProduccion")
public class GuardarLugarProduccionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sql = "INSERT INTO LUGAR_PRODUCCION "
                   + "(ID_PRODUCTOR, NOMBRE, DEPARTAMENTO, MUNICIPIO, VEREDA, DIRECCION, LAT, LON, RESULTADO_VISITA_ICA, FECHA_VISITA_ICA) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(request.getParameter("idProductor")));
            ps.setString(2, request.getParameter("nombre"));
            ps.setString(3, request.getParameter("departamento"));
            ps.setString(4, request.getParameter("municipio"));
            ps.setString(5, request.getParameter("vereda"));
            ps.setString(6, request.getParameter("direccion"));

            String lat = request.getParameter("lat");
            if (lat == null || lat.isEmpty()) {
                ps.setNull(7, Types.NUMERIC);
            } else {
                ps.setDouble(7, Double.parseDouble(lat));
            }

            String lon = request.getParameter("lon");
            if (lon == null || lon.isEmpty()) {
                ps.setNull(8, Types.NUMERIC);
            } else {
                ps.setDouble(8, Double.parseDouble(lon));
            }

            ps.setString(9, request.getParameter("resultadoVisitaIca"));

            String fecha = request.getParameter("fechaVisitaIca");
            if (fecha == null || fecha.isEmpty()) {
                ps.setNull(10, Types.DATE);
            } else {
                ps.setDate(10, Date.valueOf(fecha));
            }

            ps.executeUpdate();

            response.sendRedirect("lugarProduccion.jsp?ok=1");

        } catch (Exception e) {
            response.getWriter().println("Error al guardar lugar: " + e.getMessage());
        }
    }
}