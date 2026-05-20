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

@WebServlet("/actualizarInforme")
public class ActualizarInformeServlet
        extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        int idInforme =
                Integer.parseInt(
                        request.getParameter("idInforme")
                );

        String estado =
                request.getParameter("estadoFenologico");

        double area =
                Double.parseDouble(
                        request.getParameter("areaHa")
                );

        int plantas =
                Integer.parseInt(
                        request.getParameter("cantPlantas")
                );

        int infestadas =
                Integer.parseInt(
                        request.getParameter("plantasInfestadas")
                );

        String observaciones =
                request.getParameter("observaciones");

        double porcentaje =
                ((double) infestadas / plantas) * 100;

        try(Connection con =
                    ConexionBD.conectar()) {

            String sqlInforme =

                    "UPDATE INFORME_FITOSANITARIO " +

                    "SET ESTADO_FENOLOGICO=?, " +

                    "AREA_HA=?, " +

                    "CANT_PLANTAS=?, " +

                    "OBSERVACIONES=? " +

                    "WHERE ID_INFORME=?";

            PreparedStatement psInforme =
                    con.prepareStatement(sqlInforme);

            psInforme.setString(1, estado);
            psInforme.setDouble(2, area);
            psInforme.setInt(3, plantas);
            psInforme.setString(4, observaciones);
            psInforme.setInt(5, idInforme);

            psInforme.executeUpdate();

            String sqlDetalle =

                    "UPDATE DETALLE_INFORME_PLAGA " +

                    "SET PLANTAS_INFESTADAS=?, " +

                    "PORCENTAJE_INFESTACION=? " +

                    "WHERE ID_INFORME=?";

            PreparedStatement psDetalle =
                    con.prepareStatement(sqlDetalle);

            psDetalle.setInt(1, infestadas);
            psDetalle.setDouble(2, porcentaje);
            psDetalle.setInt(3, idInforme);

            psDetalle.executeUpdate();

            response.sendRedirect("informe.jsp");

        } catch(Exception e){

            e.printStackTrace();
        }
    }
}