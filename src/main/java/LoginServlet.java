import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT id, password FROM users WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("id");
                String storedHashedPassword = rs.getString("password");

                String hashedPassword = PasswordUtil.hashPassword(password);

                if (storedHashedPassword.equals(hashedPassword)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", userId);
                    session.setAttribute("username", username);

                    response.sendRedirect("index.jsp");
                } else {
                    response.sendRedirect("login.jsp?error=PasswordIncorrect");
                }
            } else {
                response.sendRedirect("login.jsp?error=UserNotFound");
            }
        } catch (SQLException | NoSuchAlgorithmException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp");
        }
    }
}
