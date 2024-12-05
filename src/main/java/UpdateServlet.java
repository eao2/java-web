import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/UpdateServlet")
public class UpdateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("password");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String checkSql = "SELECT id FROM users WHERE username = ? AND email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, username);
            checkStmt.setString(2, email);

            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                String hashedPassword = PasswordUtil.hashPassword(newPassword);

                String updateSql = "UPDATE users SET password = ? WHERE username = ? AND email = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setString(1, hashedPassword);
                updateStmt.setString(2, username);
                updateStmt.setString(3, email);

                int rowsUpdated = updateStmt.executeUpdate();
                if (rowsUpdated > 0) {
                    response.sendRedirect("login.jsp");
                } else {
                    response.sendRedirect("update.jsp?error=updateFailed");
                }
            } else {
                response.sendRedirect("update.jsp?error=userNotFound");
            }
        } catch (SQLException | NoSuchAlgorithmException e) {
            e.printStackTrace();
            response.sendRedirect("update.jsp?error=sqlError");
        }
    }
}
