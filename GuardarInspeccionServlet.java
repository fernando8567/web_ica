/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/File.java to edit this template
 */
package servlet;

import conexion.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;

@WebServlet("/guardarInspeccion")
@MultipartConfig
public class GuardarInspeccionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombreFoto = guardarFoto(request);

        String sql = "INSERT INTO INFORME_FITOSANITARIO "
                   + "(ID_INFORME, ID_LOTE, ID_ASISTENTE, FECHA, ESTADO_FENOLOGICO, AREA_HA, CANT_PLANTAS, FOTO) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        int idInforme = Integer.parseInt(request.getParameter("idInforme"));

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idInforme);
            ps.setInt(2, Integer.parseInt(request.getParameter("idLote")));
            ps.setInt(3, Integer.parseInt(request.getParameter("idAsistente")));
            ps.setDate(4, Date.valueOf(request.getParameter("fecha")));
            ps.setString(5, request.getParameter("estadoFenologico"));
            ps.setDouble(6, Double.parseDouble(request.getParameter("areaHa")));
            ps.setInt(7, Integer.parseInt(request.getParameter("cantPlantas")));
            ps.setString(8, nombreFoto);

            ps.executeUpdate();

            response.sendRedirect("informe.jsp?id=" + idInforme);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al guardar inspección: " + e.getMessage());
        }
    }

    private String guardarFoto(HttpServletRequest request)
            throws IOException, ServletException {

        Part archivo = request.getPart("foto");

        if (archivo == null || archivo.getSize() == 0) {
            return null;
        }

        String nombreOriginal = Paths.get(archivo.getSubmittedFileName()).getFileName().toString();
        String nombreFoto = System.currentTimeMillis() + "_" + nombreOriginal;

        String ruta = getServletContext().getRealPath("/uploads");
        File carpeta = new File(ruta);

        if (!carpeta.exists()) {
            carpeta.mkdirs();
        }

        archivo.write(ruta + File.separator + nombreFoto);

        return nombreFoto;
    }
}