import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/deleteImage")
public class DeleteImageServlet extends HttpServlet {
    private static final String DELETE_IMAGE_QUERY = "DELETE FROM images WHERE id = ? AND user_id = ?";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp?error=PleaseLogin");
            return;
        }

        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            response.sendRedirect("manage-images.jsp?error=ImageIdRequired");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_IMAGE_QUERY)) {
            stmt.setInt(1, Integer.parseInt(id));
            stmt.setInt(2, userId);

            int rowsDeleted = stmt.executeUpdate();

            if (rowsDeleted > 0) {
                response.sendRedirect("manage-images.jsp?success=ImageDeleted");
            } else {
                response.sendRedirect("manage-images.jsp?error=DeleteFailed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manage-images.jsp?error=DatabaseError");
        }
    }
}
