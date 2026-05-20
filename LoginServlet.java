/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import conexion.ConexionSeguridad;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");
        String rol = request.getParameter("rol");

        String sql =
                "SELECT USUARIO, ROL " +
                "FROM USUARIOS " +
                "WHERE USUARIO = ? " +
                "AND CONTRASENA = ? " +
                "AND ROL = ?";

        try (Connection con = ConexionSeguridad.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario);
            ps.setString(2, contrasena);
            ps.setString(3, rol);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                // SESION AUTH-SERVICE
                HttpSession session = request.getSession();

                session.setAttribute("usuario", rs.getString("USUARIO"));
                session.setAttribute("rol", rs.getString("ROL"));

                String usuarioUrl =
                        URLEncoder.encode(
                                rs.getString("USUARIO"),
                                StandardCharsets.UTF_8.toString()
                        );

                String rolUrl =
                        URLEncoder.encode(
                                rs.getString("ROL"),
                                StandardCharsets.UTF_8.toString()
                        );

                response.sendRedirect(
                        "http://localhost:8080/web_ica/recibirLogin?usuario="
                                + usuarioUrl
                                + "&rol="
                                + rolUrl
                );

            } else {

                response.sendRedirect("index.jsp?error=1");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                    "Error en login: " + e.getMessage()
            );
        }
    }
}