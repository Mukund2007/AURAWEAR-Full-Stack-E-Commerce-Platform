package com.aurawear.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.aurawear.util.DBConnection;

public class LoginDAO {

    public boolean validateUser(
            String email,
            String password) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT password FROM users WHERE email=?")) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password");
                    boolean verified = com.aurawear.util.PasswordUtil.verifyPassword(password, storedHash);
                    if (verified && (storedHash == null || !storedHash.startsWith("v1$"))) {
                        // Upgrade the hash format dynamically to v1 / 310,000 iterations
                        String newHash = com.aurawear.util.PasswordUtil.hashPassword(password);
                        try (PreparedStatement updatePs = con.prepareStatement("UPDATE users SET password=? WHERE email=?")) {
                            updatePs.setString(1, newHash);
                            updatePs.setString(2, email);
                            updatePs.executeUpdate();
                        }
                    }
                    return verified;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;

    }

}