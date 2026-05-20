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

@WebServlet("/eliminarInforme")
public class EliminarInformeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String usuario =
                (String) request.getSession()
                .getAttribute("usuario");

        String rol =
                (String) request.getSession()
                .getAttribute("rol");

        // SOLO ADMIN ICA

        if(usuario == null
                ||
           rol == null
                ||
           !usuario.equals("admin")
                ||
           !rol.equals("Inspector ICA")) {

            response.sendRedirect("index.jsp");
            return;
        }

        int idInforme =
                Integer.parseInt(
                        request.getParameter("idInforme")
                );

        try(Connection con =
                    ConexionBD.conectar()) {

            // BORRAR DETALLE

            String sqlDetalle =
                    "DELETE FROM DETALLE_INFORME_PLAGA " +
                    "WHERE ID_INFORME=?";

            PreparedStatement psDetalle =
                    con.prepareStatement(sqlDetalle);

            psDetalle.setInt(1, idInforme);

            psDetalle.executeUpdate();

            // BORRAR INFORME

            String sqlInforme =
                    "DELETE FROM INFORME_FITOSANITARIO " +
                    "WHERE ID_INFORME=?";

            PreparedStatement psInforme =
                    con.prepareStatement(sqlInforme);

            psInforme.setInt(1, idInforme);

            psInforme.executeUpdate();

            response.sendRedirect(
                    "informe.jsp?eliminado=1"
            );

        } catch(Exception e){

            e.printStackTrace();

            response.getWriter().println(
                    "Error eliminando informe: "
                    + e.getMessage()
            );
        }
    }
}