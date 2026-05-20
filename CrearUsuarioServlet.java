/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import conexion.ConexionSeguridad;
import conexion.ConexionP2;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/crearUsuario")
public class CrearUsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        String usuarioAdmin = session != null ? (String) session.getAttribute("usuario") : null;
        String rolAdmin = session != null ? (String) session.getAttribute("rol") : null;

        if (!("admin".equals(usuarioAdmin) && "Inspector ICA".equals(rolAdmin))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");
        String rol = request.getParameter("rol");

        String direccionProductor = request.getParameter("direccionProductor");
        String telefonoProductor = request.getParameter("telefonoProductor");
        String emailProductor = request.getParameter("emailProductor");
        String registroIcaProductor = request.getParameter("registroIcaProductor");

        String direccionAsistente = request.getParameter("direccionAsistente");
        String telefonoAsistente = request.getParameter("telefonoAsistente");
        String emailAsistente = request.getParameter("emailAsistente");
        String tarjetaProfesional = request.getParameter("tarjetaProfesional");
        String registroIcaAsistente = request.getParameter("registroIcaAsistente");

        try {
            try (Connection conSeg = ConexionSeguridad.conectar()) {
                String sqlUsuario = "INSERT INTO USUARIOS (USUARIO, CONTRASENA, ROL) VALUES (?, ?, ?)";

                PreparedStatement psUsuario = conSeg.prepareStatement(sqlUsuario);
                psUsuario.setString(1, usuario);
                psUsuario.setString(2, contrasena);
                psUsuario.setString(3, rol);
                psUsuario.executeUpdate();
            }

            try (Connection conP2 = ConexionP2.conectar()) {

                if ("Productor".equals(rol)) {
                    String sqlProductor =
                            "INSERT INTO PRODUCTOR " +
                            "(NRO_IDENTIDAD, NOMBRE, DIRECCION, TELEFONO, EMAIL, NRO_REGISTRO_ICA, ESTADO) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?)";

                    PreparedStatement psProductor = conP2.prepareStatement(sqlProductor);
                    psProductor.setString(1, usuario);
                    psProductor.setString(2, usuario);
                    psProductor.setString(3, direccionProductor);
                    psProductor.setString(4, telefonoProductor);
                    psProductor.setString(5, emailProductor);
                    psProductor.setString(6, registroIcaProductor);
                    psProductor.setString(7, "ACTIVO");
                    psProductor.executeUpdate();
                }

                if ("Asistente Técnico".equals(rol)) {
                    String sqlAsistente =
                            "INSERT INTO ASISTENTE_TECNICO " +
                            "(NRO_IDENTIDAD, NOMBRE, DIRECCION, TELEFONO, EMAIL, NRO_TARJETA_PROFESIONAL, NRO_REGISTRO_ICA, ESTADO) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

                    PreparedStatement psAsistente = conP2.prepareStatement(sqlAsistente);
                    psAsistente.setString(1, usuario);
                    psAsistente.setString(2, usuario);
                    psAsistente.setString(3, direccionAsistente);
                    psAsistente.setString(4, telefonoAsistente);
                    psAsistente.setString(5, emailAsistente);
                    psAsistente.setString(6, tarjetaProfesional);
                    psAsistente.setString(7, registroIcaAsistente);
                    psAsistente.setString(8, "ACTIVO");
                    psAsistente.executeUpdate();
                }
            }

            response.sendRedirect("usuarios.jsp?ok=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al crear usuario: " + e.getMessage());
        }
    }
}