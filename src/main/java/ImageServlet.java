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
    private static final String PURCHASE_QUERY = "SELECT COUNT(*) FROM purchases WHERE user_id = ? AND image_id = ?";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String resolution = request.getParameter("res");
        Integer userId = (Integer) request.getSession().getAttribute("userId"); // Assuming `userId` is stored in the session

        if (id == null || id.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image ID is required");
            return;
        }

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "You must be logged in to access this resource");
            return;
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            // Check if the user has purchased the image
            if ("high".equals(resolution)) {
                try (PreparedStatement purchaseStmt = connection.prepareStatement(PURCHASE_QUERY)) {
                    int imageId = Integer.parseInt(id);
                    purchaseStmt.setInt(1, userId);
                    purchaseStmt.setInt(2, imageId);

                    try (ResultSet rs = purchaseStmt.executeQuery()) {
                        if (rs.next() && rs.getInt(1) == 0) {
                            // User has not purchased the image
                            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You must purchase this image to access the high-resolution version");
                            return;
                        }
                    }
                }
            }

            // Fetch the image data
            try (PreparedStatement imageStmt = connection.prepareStatement(IMAGE_QUERY)) {
                int imageId = Integer.parseInt(id);
                imageStmt.setInt(1, imageId);

                try (ResultSet rs = imageStmt.executeQuery()) {
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
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid image ID");
        } catch (SQLException e) {
            log("Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
}
