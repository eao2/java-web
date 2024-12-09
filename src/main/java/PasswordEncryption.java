
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordEncryption {

    private static final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    // Encrypt the password
    public static String hashPassword(String plainPassword) {
        return passwordEncoder.encode(plainPassword);
    }

    // Verify the password
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        return passwordEncoder.matches(plainPassword, hashedPassword);
    }

    public static void main(String[] args) {
        String password = "mySecurePassword";

        // Hash the password
        String hashedPassword = hashPassword(password);
        System.out.println("Hashed Password: " + hashedPassword);

        // Verify the password
        boolean isMatch = verifyPassword(password, hashedPassword);
        System.out.println("Password matches: " + isMatch);
    }
}