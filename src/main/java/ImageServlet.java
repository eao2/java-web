import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/image")
public class ImageServlet extends HttpServlet {
    private static final String IMAGE_QUERY = "SELECT low_res, medium_res, high_res FROM images WHERE id = ?";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String resolution = request.getParameter("res");

        if (id == null || id.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image ID is required");
            return;
        }

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(IMAGE_QUERY)) {

            int imageId = Integer.parseInt(id);
            statement.setInt(1, imageId);

            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    byte[] imageData = null;

                    if ("medium".equals(resolution)) {
                        imageData = rs.getBytes("medium_res");
                    } else if ("high".equals(resolution)) {
                        imageData = rs.getBytes("high_res");
                    } else {
                        imageData = rs.getBytes("low_res");
                    }

                    if (imageData != null && imageData.length > 0) {
                        response.setContentType("image/png");
                        response.setContentLength(imageData.length);

                        response.getOutputStream().write(imageData);
                        response.getOutputStream().flush();
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image data is empty");
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found");
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid image ID");
        } catch (SQLException e) {
            log("Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
}