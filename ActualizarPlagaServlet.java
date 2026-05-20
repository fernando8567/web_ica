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

@WebServlet("/actualizarPlaga")
@MultipartConfig
public class ActualizarPlagaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        int id =
                Integer.parseInt(
                        request.getParameter("id")
                );

        String nombreCientifico =
                request.getParameter("nombreCientifico");

        String nombresComunes =
                request.getParameter("nombresComunes");

        Part fotoPart =
                request.getPart("foto");

        String nombreArchivo = null;

        // FOTO NUEVA

        if (fotoPart != null && fotoPart.getSize() > 0) {

            nombreArchivo =
                    Paths.get(
                            fotoPart.getSubmittedFileName()
                    )
                    .getFileName()
                    .toString();

            String ruta =
                    getServletContext().getRealPath("")
                            + File.separator
                            + "imagenes"
                            + File.separator
                            + "plagas";

            File directorio =
                    new File(ruta);

            if (!directorio.exists()) {

                directorio.mkdirs();
            }

            fotoPart.write(
                    ruta + File.separator + nombreArchivo
            );
        }

        try (Connection con = ConexionBD.conectar()) {

            String sql;

            PreparedStatement ps;

            // SI CAMBIO FOTO

            if (nombreArchivo != null) {

                sql =
                        "UPDATE PLAGA " +
                        "SET NOMBRE_CIENTIFICO=?, " +
                        "NOMBRES_COMUNES=?, " +
                        "FOTO=? " +
                        "WHERE ID_PLAGA=?";

                ps = con.prepareStatement(sql);

                ps.setString(1, nombreCientifico);
                ps.setString(2, nombresComunes);
                ps.setString(3, nombreArchivo);
                ps.setInt(4, id);

            }

            // SI NO CAMBIO FOTO

            else {

                sql =
                        "UPDATE PLAGA " +
                        "SET NOMBRE_CIENTIFICO=?, " +
                        "NOMBRES_COMUNES=? " +
                        "WHERE ID_PLAGA=?";

                ps = con.prepareStatement(sql);

                ps.setString(1, nombreCientifico);
                ps.setString(2, nombresComunes);
                ps.setInt(3, id);
            }

            ps.executeUpdate();

            response.sendRedirect("especies.jsp");

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                    "Error al actualizar plaga: "
                            + e.getMessage()
            );
        }
    }
}