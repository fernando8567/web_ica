/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author SALA-404
 */
package servlet;

import conexion.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Usuario;

import java.io.IOException;
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
        String accion = request.getParameter("accion");

        String sql = "SELECT usuario, rol FROM usuarios WHERE usuario = ? AND contrasena = ? AND rol = ?";

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario);
            ps.setString(2, contrasena);
            ps.setString(3, rol);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Usuario u = new Usuario(rs.getString("usuario"), rs.getString("rol"));

                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogueado", u);

                if ("admin".equals(u.getUsuario())
                        && "Inspector ICA".equals(u.getRol())
                        && "admin".equals(accion)) {

                    response.sendRedirect("usuarios.jsp");

                } else {
                    response.sendRedirect("dashboard.jsp");
                }

            } else {
                response.sendRedirect("index.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error en login: " + e.getMessage());
        }
    }
}