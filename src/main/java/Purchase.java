import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/purchase")
public class Purchase extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/wallpaper_shop";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "admin";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        int imageId = Integer.parseInt(request.getParameter("imageId"));
        double amount = Double.parseDouble(request.getParameter("price"));

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD)) {
            // Add purchase record
            String sql = "INSERT INTO purchases (user_id, image_id, amount) VALUES (?, ?, ?)";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, imageId);
            preparedStatement.setDouble(3, amount);
            preparedStatement.executeUpdate();

            // Remove from cart
            sql = "DELETE FROM cart WHERE user_id = ? AND image_id = ?";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, imageId);
            preparedStatement.executeUpdate();

            response.sendRedirect("cart.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
