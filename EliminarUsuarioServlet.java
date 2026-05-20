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

@WebServlet("/eliminarUsuario")
public class EliminarUsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        String usuarioAdmin =
                session != null
                        ? (String) session.getAttribute("usuario")
                        : null;

        String rolAdmin =
                session != null
                        ? (String) session.getAttribute("rol")
                        : null;

        if (!("admin".equals(usuarioAdmin)
                && "Inspector ICA".equals(rolAdmin))) {

            response.sendRedirect("index.jsp");
            return;
        }

        int idUsuario =
                Integer.parseInt(
                        request.getParameter("idUsuario")
                );

        String usuario =
                request.getParameter("usuario");

        String rol =
                request.getParameter("rol");

        try {

            // ELIMINAR EN SEGURIDAD

            try (Connection conSeg =
                         ConexionSeguridad.conectar()) {

                String sqlSeg =
                        "DELETE FROM USUARIOS " +
                        "WHERE ID_USUARIO = ?";

                PreparedStatement psSeg =
                        conSeg.prepareStatement(sqlSeg);

                psSeg.setInt(1, idUsuario);

                psSeg.executeUpdate();
            }

            // ELIMINAR EN P2

            try (Connection conP2 =
                         ConexionP2.conectar()) {

                if ("Productor".equals(rol)) {

                    String sqlProd =
                            "DELETE FROM PRODUCTOR " +
                            "WHERE NRO_IDENTIDAD = ?";

                    PreparedStatement psProd =
                            conP2.prepareStatement(sqlProd);

                    psProd.setString(1, usuario);

                    psProd.executeUpdate();
                }

                if ("Asistente Técnico".equals(rol)) {

                    String sqlAsis =
                            "DELETE FROM ASISTENTE_TECNICO " +
                            "WHERE NRO_IDENTIDAD = ?";

                    PreparedStatement psAsis =
                            conP2.prepareStatement(sqlAsis);

                    psAsis.setString(1, usuario);

                    psAsis.executeUpdate();
                }
            }

            response.sendRedirect(
                    "usuarios.jsp?eliminado=1"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                    "Error al eliminar usuario: "
                            + e.getMessage()
            );
        }
    }
}