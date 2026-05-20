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

@WebServlet("/actualizarAsistente")
public class ActualizarAsistenteServlet
        extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        int id =
                Integer.parseInt(
                        request.getParameter("id")
                );

        String nombre =
                request.getParameter("nombre");

        String direccion =
                request.getParameter("direccion");

        String telefono =
                request.getParameter("telefono");

        String email =
                request.getParameter("email");

        String tarjeta =
                request.getParameter("tarjeta");

        String registroIca =
                request.getParameter("registroIca");

        String estado =
                request.getParameter("estado");

        try(Connection con =
                    ConexionBD.conectar()) {

            String sql =
                    "UPDATE ASISTENTE_TECNICO " +
                    "SET NOMBRE=?, " +
                    "DIRECCION=?, " +
                    "TELEFONO=?, " +
                    "EMAIL=?, " +
                    "NRO_TARJETA_PROFESIONAL=?, " +
                    "NRO_REGISTRO_ICA=?, " +
                    "ESTADO=? " +
                    "WHERE ID_ASISTENTE=?";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, nombre);
            ps.setString(2, direccion);
            ps.setString(3, telefono);
            ps.setString(4, email);
            ps.setString(5, tarjeta);
            ps.setString(6, registroIca);
            ps.setString(7, estado);

            ps.setInt(8, id);

            ps.executeUpdate();

            response.sendRedirect(
                    "asistentes.jsp"
            );

        } catch(Exception e){

            e.printStackTrace();

            response.getWriter().println(
                    "Error: " + e.getMessage()
            );
        }
    }
}