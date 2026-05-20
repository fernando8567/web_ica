/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import conexion.ConexionBD;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.BaseColor;

import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet("/generarPdfInforme")
public class GenerarPdfInformeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        int idInforme =
                Integer.parseInt(
                        request.getParameter("id")
                );

        response.setContentType("application/pdf");

        response.setHeader(
                "Content-Disposition",
                "inline; filename=informe_ica.pdf"
        );

        try {

            Document document =
                    new Document(
                            PageSize.A4,
                            40,
                            40,
                            50,
                            50
                    );

            PdfWriter.getInstance(
                    document,
                    response.getOutputStream()
            );

            document.open();

            // ===================================
            // LOGO ICA
            // ===================================

            try {

                String rutaLogo =
                        getClass()
                        .getClassLoader()
                        .getResource("img/logo_ica.png")
                        .toExternalForm();

                Image logo =
                        Image.getInstance(rutaLogo);

                logo.scaleToFit(120,120);

                logo.setAlignment(
                        Element.ALIGN_CENTER
                );

                document.add(logo);

            } catch(Exception e){

                e.printStackTrace();

                document.add(
                        new Paragraph(
                                "Error cargando logo ICA"
                        )
                );
            }

            // ===================================
            // TITULO
            // ===================================

            Font titulo =
                    FontFactory.getFont(
                            FontFactory.HELVETICA_BOLD,
                            20,
                            BaseColor.GREEN
                    );

            Paragraph encabezado =
                    new Paragraph(
                            "INFORME FITOSANITARIO ICA",
                            titulo
                    );

            encabezado.setAlignment(
                    Element.ALIGN_CENTER
            );

            document.add(encabezado);

            document.add(
                    new Paragraph(" ")
            );

            // ===================================
            // CONSULTA
            // ===================================

            try(Connection con =
                        ConexionBD.conectar()) {

                String sql =

                    "SELECT I.ID_INFORME, " +

                    "PR.NOMBRE PRODUCTOR, " +

                    "LP.NOMBRE LUGAR, " +

                    "LP.MUNICIPIO, " +

                    "L.NUMERO LOTE, " +

                    "E.NOMBRE_CIENTIFICO ESPECIE, " +

                    "A.NOMBRE ASISTENTE, " +

                    "I.FECHA, " +

                    "I.ESTADO_FENOLOGICO, " +

                    "I.AREA_HA, " +

                    "I.CANT_PLANTAS, " +

                    "PL.NOMBRE_CIENTIFICO PLAGA, " +

                    "D.PLANTAS_INFESTADAS, " +

                    "D.PORCENTAJE_INFESTACION, " +

                    "I.OBSERVACIONES " +

                    "FROM INFORME_FITOSANITARIO I " +

                    "INNER JOIN LOTE L " +
                    "ON I.ID_LOTE = L.ID_LOTE " +

                    "INNER JOIN ESPECIE E " +
                    "ON L.ID_ESPECIE = E.ID_ESPECIE " +

                    "INNER JOIN LUGAR_PRODUCCION LP " +
                    "ON L.ID_LUGAR = LP.ID_LUGAR " +

                    "INNER JOIN PRODUCTOR PR " +
                    "ON LP.ID_PRODUCTOR = PR.ID_PRODUCTOR " +

                    "INNER JOIN ASISTENTE_TECNICO A " +
                    "ON I.ID_ASISTENTE = A.ID_ASISTENTE " +

                    "INNER JOIN DETALLE_INFORME_PLAGA D " +
                    "ON I.ID_INFORME = D.ID_INFORME " +

                    "INNER JOIN PLAGA PL " +
                    "ON D.ID_PLAGA = PL.ID_PLAGA " +

                    "WHERE I.ID_INFORME=?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setInt(1, idInforme);

                ResultSet rs =
                        ps.executeQuery();

                if(rs.next()) {

                    PdfPTable tabla =
                            new PdfPTable(2);

                    tabla.setWidthPercentage(100);

                    tabla.setSpacingBefore(15f);

                    tabla.setSpacingAfter(15f);

                    PdfPCell c1;

                    // PRODUCTOR

                    c1 = new PdfPCell(
                            new Paragraph("Productor")
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            rs.getString("PRODUCTOR")
                    );

                    // LUGAR

                    c1 = new PdfPCell(
                            new Paragraph("Lugar Producción")
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            rs.getString("LUGAR")
                    );

                    // MUNICIPIO

                    c1 = new PdfPCell(
                            new Paragraph("Municipio")
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            rs.getString("MUNICIPIO")
                    );

                    // LOTE

                    c1 = new PdfPCell(
                            new Paragraph("Lote")
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            rs.getString("LOTE")
                    );

                    // ESPECIE

                    c1 = new PdfPCell(
                            new Paragraph("Especie")
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            rs.getString("ESPECIE")
                    );

                    // PLAGA

                    c1 = new PdfPCell(
                            new Paragraph("Plaga")
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            rs.getString("PLAGA")
                    );

                    // ASISTENTE

                    c1 = new PdfPCell(
                            new Paragraph(
                                    "Asistente Técnico"
                            )
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            rs.getString("ASISTENTE")
                    );

                    // FECHA

                    c1 = new PdfPCell(
                            new Paragraph("Fecha")
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            rs.getDate("FECHA")
                            .toString()
                    );

                    // ESTADO

                    c1 = new PdfPCell(
                            new Paragraph(
                                    "Estado Fenológico"
                            )
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            rs.getString(
                                    "ESTADO_FENOLOGICO"
                            )
                    );

                    // AREA

                    c1 = new PdfPCell(
                            new Paragraph("Área")
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            rs.getDouble("AREA_HA")
                            + " HA"
                    );

                    // CANTIDAD PLANTAS

                    c1 = new PdfPCell(
                            new Paragraph(
                                    "Cantidad Plantas"
                            )
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            String.valueOf(
                                    rs.getInt(
                                            "CANT_PLANTAS"
                                    )
                            )
                    );

                    // INFESTADAS

                    c1 = new PdfPCell(
                            new Paragraph(
                                    "Plantas Infestadas"
                            )
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            String.valueOf(
                                    rs.getInt(
                                            "PLANTAS_INFESTADAS"
                                    )
                            )
                    );

                    // PORCENTAJE

                    double porcentaje =
                            rs.getDouble(
                                    "PORCENTAJE_INFESTACION"
                            );

                    c1 = new PdfPCell(
                            new Paragraph(
                                    "% Infestación"
                            )
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            porcentaje + "%"
                    );

                    // ALERTA

                    String alerta;

                    if(porcentaje <= 10){

                        alerta = "BAJO";

                    } else if(porcentaje <= 30){

                        alerta = "MEDIO";

                    } else {

                        alerta = "ALTO";
                    }

                    c1 = new PdfPCell(
                            new Paragraph(
                                    "Nivel Alerta"
                            )
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(alerta);

                    // OBSERVACIONES

                    c1 = new PdfPCell(
                            new Paragraph(
                                    "Observaciones ICA"
                            )
                    );

                    c1.setBackgroundColor(
                            BaseColor.LIGHT_GRAY
                    );

                    tabla.addCell(c1);

                    tabla.addCell(
                            rs.getString(
                                    "OBSERVACIONES"
                            )
                    );

                    document.add(tabla);

                    // PIE

                    document.add(
                            new Paragraph(" ")
                    );

                    Paragraph pie =
                            new Paragraph(
                                    "Instituto Colombiano Agropecuario - ICA",
                                    FontFactory.getFont(
                                            FontFactory.HELVETICA_BOLD,
                                            12
                                    )
                            );

                    pie.setAlignment(
                            Element.ALIGN_CENTER
                    );

                    document.add(pie);
                }
            }

            document.close();

        } catch(Exception e){

            e.printStackTrace();

            response.getWriter().println(
                    "Error generando PDF: "
                    + e.getMessage()
            );
        }
    }
}