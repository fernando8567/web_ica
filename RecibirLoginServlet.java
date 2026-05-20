/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.Usuario;

import java.io.IOException;

@WebServlet("/recibirLogin")
public class RecibirLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String rol = request.getParameter("rol");

        if (usuario == null || rol == null) {
            response.sendRedirect("http://localhost:8080/auth-service/index.jsp");
            return;
        }

        Usuario u = new Usuario(usuario, rol);

        HttpSession session = request.getSession();
        session.setAttribute("usuarioLogueado", u);

        response.sendRedirect("dashboard.jsp");
    }
}