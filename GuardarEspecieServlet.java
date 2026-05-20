/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
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
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/guardarEspecie")
@MultipartConfig
public class GuardarEspecieServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombreCientifico = request.getParameter("nombreCientifico");
        String nombresComunes = request.getParameter("nombresComunes");
        String variedad = request.getParameter("variedad");
        String ciclo = request.getParameter("ciclo");
        String idPlaga = request.getParameter("idPlaga");

        String nombreFoto = guardarFoto(request);

        String sqlEspecie = "INSERT INTO ESPECIE "
                + "(NOMBRE_CIENTIFICO, NOMBRES_COMUNES, VARIEDAD, CICLO, FOTO) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = ConexionBD.conectar()) {

            PreparedStatement ps = con.prepareStatement(sqlEspecie);

            ps.setString(1, nombreCientifico);
            ps.setString(2, nombresComunes);
            ps.setString(3, variedad);
            ps.setString(4, ciclo);
            ps.setString(5, nombreFoto);

            ps.executeUpdate();

            int idEspecieGenerada = 0;

            PreparedStatement psId = con.prepareStatement(
                    "SELECT MAX(ID_ESPECIE) AS ID_ESPECIE FROM ESPECIE"
            );

            ResultSet rsId = psId.executeQuery();

            if (rsId.next()) {
                idEspecieGenerada = rsId.getInt("ID_ESPECIE");
            }

            if (idPlaga != null && !idPlaga.trim().isEmpty()) {
                String sqlRelacion = "INSERT INTO ESPECIE_PLAGA (ID_ESPECIE, ID_PLAGA) VALUES (?, ?)";

                PreparedStatement psRelacion = con.prepareStatement(sqlRelacion);

                psRelacion.setInt(1, idEspecieGenerada);
                psRelacion.setInt(2, Integer.parseInt(idPlaga));

                psRelacion.executeUpdate();
            }

            response.sendRedirect("especies.jsp?ok=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al guardar especie: " + e.getMessage());
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

        String ruta = getServletContext().getRealPath("/") + "uploads";
        File carpeta = new File(ruta);

        if (!carpeta.exists()) {
            carpeta.mkdirs();
        }

        archivo.write(ruta + File.separator + nombreFoto);

        return nombreFoto;
    }
}