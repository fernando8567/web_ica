/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import conexion.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/guardarLugar")
public class GuardarLugarServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String codigo = request.getParameter("codigo");
        String productor = request.getParameter("productor");
        String asistente = request.getParameter("asistente");
        String predios = request.getParameter("predios");
        String area = request.getParameter("area");
        String estado = request.getParameter("estado");

        String sql = "INSERT INTO lugar_produccion (codigo_lugar, productor, asistente_tecnico, predios_vinculados, area_total, estado_ica) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, codigo);
            ps.setString(2, productor);
            ps.setString(3, asistente);
            ps.setString(4, predios);
            ps.setDouble(5, Double.parseDouble(area));
            ps.setString(6, estado);

            ps.executeUpdate();

            response.sendRedirect("lugarProduccion.jsp?ok=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al guardar lugar: " + e.getMessage());
        }
    }
}