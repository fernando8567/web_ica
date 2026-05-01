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
import java.sql.Date;
import java.sql.PreparedStatement;

@WebServlet("/guardarLote")
@MultipartConfig
public class GuardarLoteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombreFoto = guardarFoto(request);

        String sql = "INSERT INTO LOTE "
                   + "(ID_LUGAR, ID_ESPECIE, NUMERO, AREA_HA, FECHA_SIEMBRA, FECHA_ELIMINACION, FOTO) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(request.getParameter("idLugar")));
            ps.setInt(2, Integer.parseInt(request.getParameter("idEspecie")));
            ps.setString(3, request.getParameter("numero"));
            ps.setDouble(4, Double.parseDouble(request.getParameter("areaHa")));
            ps.setDate(5, Date.valueOf(request.getParameter("fechaSiembra")));

            String fechaEliminacion = request.getParameter("fechaEliminacion");

            if (fechaEliminacion == null || fechaEliminacion.isEmpty()) {
                ps.setNull(6, java.sql.Types.DATE);
            } else {
                ps.setDate(6, Date.valueOf(fechaEliminacion));
            }

            ps.setString(7, nombreFoto);

            ps.executeUpdate();

            response.sendRedirect("lotes.jsp?ok=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al guardar lote: " + e.getMessage());
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