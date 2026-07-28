package com.aurawear.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * One-time password migration utility.
 * Identifies users in the database with plaintext passwords (no ':' in the password string)
 * and updates them to PBKDF2 format using PasswordUtil.
 */
public class MigratePasswords {

    private static class UserInfo {
        int id;
        String email;
        String plaintextPassword;

        UserInfo(int id, String email, String plaintextPassword) {
            this.id = id;
            this.email = email;
            this.plaintextPassword = plaintextPassword;
        }
    }

    public static void main(String[] args) {
        String url = System.getenv("AURAWEAR_DB_URL");
        String user = System.getenv("AURAWEAR_DB_USER");
        String password = System.getenv("AURAWEAR_DB_PASSWORD");

        // ✅ SECURITY: never use a hardcoded fallback password.
        // Set AURAWEAR_DB_URL, AURAWEAR_DB_USER, AURAWEAR_DB_PASSWORD as environment variables
        // or in app-local.properties before running this utility.
        if (url == null || url.isEmpty() || user == null || user.isEmpty()
                || password == null || password.isEmpty()) {
            System.err.println("ERROR: AURAWEAR_DB_URL, AURAWEAR_DB_USER, and AURAWEAR_DB_PASSWORD " +
                               "must be set as environment variables before running this utility.");
            return;
        }

        System.out.println("Connecting to database: " + url + " as user: " + user);

        List<UserInfo> usersToMigrate = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL driver not found: " + e.getMessage());
            return;
        }

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            // Find all users with plaintext passwords (where password field is not null and does not contain ':')
            String selectSql = "SELECT id, email, password FROM users WHERE password IS NOT NULL AND password NOT LIKE '%:%'";
            try (PreparedStatement ps = conn.prepareStatement(selectSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    usersToMigrate.add(new UserInfo(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("password")
                    ));
                }
            }

            System.out.println("Found " + usersToMigrate.size() + " users with plaintext passwords.");

            if (usersToMigrate.isEmpty()) {
                System.out.println("No migration needed.");
                return;
            }

            String updateSql = "UPDATE users SET password = ? WHERE id = ?";
            try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                int count = 0;
                for (UserInfo u : usersToMigrate) {
                    if (u.plaintextPassword == null || u.plaintextPassword.trim().isEmpty()) {
                        continue;
                    }
                    String hashedPassword = PasswordUtil.hashPassword(u.plaintextPassword);
                    updatePs.setString(1, hashedPassword);
                    updatePs.setInt(2, u.id);
                    updatePs.addBatch();
                    count++;
                }

                if (count > 0) {
                    int[] results = updatePs.executeBatch();
                    System.out.println("Successfully migrated " + results.length + " users to PBKDF2.");
                }
            }

        } catch (SQLException e) {
            System.err.println("Database migration failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
