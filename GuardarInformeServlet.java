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
import java.sql.ResultSet;

@WebServlet("/guardarInforme")
public class GuardarInformeServlet
        extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        int idLote =
                Integer.parseInt(
                        request.getParameter("idLote")
                );

        int idAsistente =
                Integer.parseInt(
                        request.getParameter("idAsistente")
                );

        int idPlaga =
                Integer.parseInt(
                        request.getParameter("idPlaga")
                );

        String estadoFenologico =
                request.getParameter("estadoFenologico");

        double areaHa =
                Double.parseDouble(
                        request.getParameter("areaHa")
                );

        int cantPlantas =
                Integer.parseInt(
                        request.getParameter("cantPlantas")
                );

        int plantasInfestadas =
                Integer.parseInt(
                        request.getParameter("plantasInfestadas")
                );

        try(Connection con =
                    ConexionBD.conectar()) {

            // NUEVO ID INFORME

            int idInforme = 1;

            String sqlMax =
                    "SELECT NVL(MAX(ID_INFORME),0)+1 " +
                    "FROM INFORME_FITOSANITARIO";

            PreparedStatement psMax =
                    con.prepareStatement(sqlMax);

            ResultSet rsMax =
                    psMax.executeQuery();

            if(rsMax.next()) {

                idInforme =
                        rsMax.getInt(1);
            }

            // INSERTAR INFORME

            String sqlInforme =

                    "INSERT INTO INFORME_FITOSANITARIO " +

                    "(ID_INFORME, " +
                    "ID_LOTE, " +
                    "ID_ASISTENTE, " +
                    "FECHA, " +
                    "ESTADO_FENOLOGICO, " +
                    "AREA_HA, " +
                    "CANT_PLANTAS) " +

                    "VALUES (?, ?, ?, SYSDATE, ?, ?, ?)";

            PreparedStatement psInforme =
                    con.prepareStatement(sqlInforme);

            psInforme.setInt(1, idInforme);

            psInforme.setInt(2, idLote);

            psInforme.setInt(3, idAsistente);

            psInforme.setString(4, estadoFenologico);

            psInforme.setDouble(5, areaHa);

            psInforme.setInt(6, cantPlantas);

            psInforme.executeUpdate();

            // PORCENTAJE

            double porcentaje =

                    ((double) plantasInfestadas
                            / cantPlantas) * 100;

            // NUEVO ID DETALLE

            int idDetalle = 1;

            String sqlDetalleMax =
                    "SELECT NVL(MAX(ID_DETALLE),0)+1 " +
                    "FROM DETALLE_INFORME_PLAGA";

            PreparedStatement psDetalleMax =
                    con.prepareStatement(sqlDetalleMax);

            ResultSet rsDetalleMax =
                    psDetalleMax.executeQuery();

            if(rsDetalleMax.next()) {

                idDetalle =
                        rsDetalleMax.getInt(1);
            }

            // INSERTAR DETALLE

            String sqlDetalle =

                    "INSERT INTO DETALLE_INFORME_PLAGA " +

                    "(ID_DETALLE, " +
                    "ID_INFORME, " +
                    "ID_PLAGA, " +
                    "PLANTAS_INFESTADAS, " +
                    "PORCENTAJE_INFESTACION) " +

                    "VALUES (?, ?, ?, ?, ?)";

            PreparedStatement psDetalle =
                    con.prepareStatement(sqlDetalle);

            psDetalle.setInt(1, idDetalle);

            psDetalle.setInt(2, idInforme);

            psDetalle.setInt(3, idPlaga);

            psDetalle.setInt(4, plantasInfestadas);

            psDetalle.setDouble(5, porcentaje);

            psDetalle.executeUpdate();

            response.sendRedirect(
                    "informe.jsp"
            );

        } catch(Exception e){

            e.printStackTrace();

            response.getWriter().println(
                    "Error: " + e.getMessage()
            );
        }
    }
}