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

@WebServlet("/guardarEspecie")
@MultipartConfig
public class GuardarEspecieServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombreFoto = guardarFoto(request);

        String sql = "INSERT INTO ESPECIE "
                   + "(NOMBRE_CIENTIFICO, NOMBRES_COMUNES, VARIEDAD, CICLO, FOTO) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, request.getParameter("nombreCientifico"));
            ps.setString(2, request.getParameter("nombresComunes"));
            ps.setString(3, request.getParameter("variedad"));
            ps.setString(4, request.getParameter("ciclo"));
            ps.setString(5, nombreFoto);

            ps.executeUpdate();

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

        String ruta = getServletContext().getRealPath("/uploads");
        File carpeta = new File(ruta);

        if (!carpeta.exists()) {
            carpeta.mkdirs();
        }

        archivo.write(ruta + File.separator + nombreFoto);

        return nombreFoto;
    }
}