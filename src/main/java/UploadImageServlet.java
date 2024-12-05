import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.imageio.ImageIO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import net.coobird.thumbnailator.Thumbnails;

@WebServlet("/uploadImage")
@MultipartConfig(maxFileSize = 1024 * 1024 * 256) // 256MB max file size
public class UploadImageServlet extends HttpServlet {
    private static final String INSERT_IMAGE_QUERY =
            "INSERT INTO images (user_id, name, low_res, medium_res, high_res, tags, price) VALUES (?, ?, ?, ?, ?, ?, ?)";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp?error=PleaseLogin");
            return;
        }

        String name = request.getParameter("name");
        String tags = request.getParameter("tags");
        String priceStr = request.getParameter("price");
        Part imagePart = request.getPart("image");

        if (name == null || tags == null || imagePart == null || priceStr == null) {
            response.sendRedirect("upload-image.jsp?error=MissingFields");
            return;
        }

        BigDecimal price = null;
        try {
            price = new BigDecimal(priceStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("upload-image.jsp?error=InvalidPrice");
            return;
        }

        try (InputStream originalInputStream = imagePart.getInputStream();
             Connection conn = DatabaseConnection.getConnection()) {

            BufferedImage originalImage = ImageIO.read(originalInputStream);

            BufferedImage lowResImage = resizeImage(originalImage, 360);
            BufferedImage mediumResImage = resizeImage(originalImage, 720);

            byte[] lowResBytes = convertImageToBytes(lowResImage, "jpeg");
            byte[] mediumResBytes = convertImageToBytes(mediumResImage, "jpeg");
            byte[] highResBytes = convertImageToBytes(originalImage, "png");

            PreparedStatement stmt = conn.prepareStatement(INSERT_IMAGE_QUERY);
            stmt.setInt(1, userId);
            stmt.setString(2, name);
            stmt.setBytes(3, lowResBytes);
            stmt.setBytes(4, mediumResBytes);
            stmt.setBytes(5, highResBytes);
            stmt.setString(6, tags);
            stmt.setBigDecimal(7, price);
            stmt.executeUpdate();

            response.sendRedirect("upload-image.jsp?success=ImageUploaded");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("upload-image.jsp?error=DatabaseError");
        }
    }

    /**
     * Resize the input image to the specified width while maintaining the aspect ratio.
     *
     * @param originalImage The original image
     * @param width The target width
     * @return The resized BufferedImage
     * @throws IOException If an error occurs during resizing
     */
    private BufferedImage resizeImage(BufferedImage originalImage, int width) throws IOException {
        return Thumbnails.of(originalImage)
                .width(width)
                .asBufferedImage();
    }

    /**
     * Convert a BufferedImage to a byte array in the specified format.
     *
     * @param image The BufferedImage
     * @param format The image format (e.g., "png")
     * @return The byte array representation of the image
     * @throws IOException If an error occurs during image writing
     */
    private byte[] convertImageToBytes(BufferedImage image, String format) throws IOException {
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            ImageIO.write(image, format, baos);
            return baos.toByteArray();
        }
    }
}
