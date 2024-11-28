import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/image")
public class ImageServlet extends HttpServlet {
    private static final String IMAGE_QUERY = "SELECT image FROM images WHERE id = ?";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image ID is required");
            return;
        }

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            connection = DatabaseConnection.getConnection();
            statement = connection.prepareStatement(IMAGE_QUERY);
            statement.setString(1, id);

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String base64Image = resultSet.getString("image");

                if (base64Image != null && !base64Image.trim().isEmpty()) {
                    String[] parts = base64Image.split(",", 2);
                    String mimeType = "image/jpeg"; // Default to JPEG
                    String base64Data = base64Image;

                    if (parts.length == 2) {
                        mimeType = parts[0].split(":")[1].split(";")[0];
                        base64Data = parts[1];
                    }

                    byte[] imageData = Base64.getDecoder().decode(base64Data);

                    response.setContentType(mimeType);
                    response.setContentLength(imageData.length);

                    try (OutputStream out = response.getOutputStream()) {
                        out.write(imageData);
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image data is empty");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found");
            }
        } catch (IllegalArgumentException e) {
            getServletContext().log("Error decoding Base64 image", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Invalid image data format");
        } catch (SQLException e) {
            getServletContext().log("Database error retrieving image", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Database error: " + e.getMessage());
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                getServletContext().log("Error closing database resources", e);
            }
        }
    }
}