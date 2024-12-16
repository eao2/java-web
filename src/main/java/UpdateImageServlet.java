import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.io.IOException;
import java.math.BigDecimal;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/updateImage")
public class UpdateImageServlet extends HttpServlet {
    private static final String UPDATE_IMAGE_QUERY = "UPDATE images SET name = ?, tags = ?, price = ? WHERE id = ? AND user_id = ?";

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
        String name = request.getParameter("name");
        String tags = request.getParameter("tags");
        String priceStr = request.getParameter("price");

        if (id == null || name == null || tags == null || priceStr == null) {
            response.sendRedirect("editImage.jsp?id=" + id + "&error=MissingFields");
            return;
        }

        try {
            BigDecimal price = new BigDecimal(priceStr);

            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(UPDATE_IMAGE_QUERY)) {
                stmt.setString(1, name);
                stmt.setString(2, tags);
                stmt.setBigDecimal(3, price);
                stmt.setInt(4, Integer.parseInt(id));
                stmt.setInt(5, userId);

                int rowsUpdated = stmt.executeUpdate();

                if (rowsUpdated > 0) {
                    response.sendRedirect("manage-images.jsp?success=ImageUpdated");
                } else {
                    response.sendRedirect("editImage.jsp?id=" + id + "&error=UpdateFailed");
                }
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("editImage.jsp?id=" + id + "&error=InvalidPrice");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("editImage.jsp?id=" + id + "&error=DatabaseError");
        }
    }
}
