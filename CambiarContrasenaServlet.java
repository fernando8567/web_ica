/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import conexion.ConexionBD;
import modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/cambiarContrasena")
public class CambiarContrasenaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario u = (Usuario) session.getAttribute("usuarioLogueado");

        if (u == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String nueva = request.getParameter("nuevaContrasena");

        String sql = "UPDATE usuarios SET contrasena = ? WHERE usuario = ?";

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nueva);
            ps.setString(2, u.getUsuario());

            ps.executeUpdate();

            response.sendRedirect("cambiarContrasena.jsp?ok=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al cambiar contraseña: " + e.getMessage());
        }
    }
}