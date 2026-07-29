package com.aurawear.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.aurawear.model.User;
import com.aurawear.model.UserProfile;
import com.aurawear.util.DBConnection;

public class UserDAO {

    public boolean registerUser(User user) {
        String sql = "INSERT INTO users(name,email,password,verified) VALUES(?,?,?,1)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            // ✅ The password field already contains a PBKDF2 hash —
            // RegisterServlet hashes before storing in session; do NOT re-hash here.
            ps.setString(3, user.getPassword());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean emailExists(String email) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT 1 FROM users WHERE email=?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean saveProfile(UserProfile p) {
        String sql = "INSERT INTO user_profiles(user_id,username,style_preference,clothing_size,fit_preference,interests) VALUES(?,?,?,?,?,?) " +
                     "ON DUPLICATE KEY UPDATE username=VALUES(username), style_preference=VALUES(style_preference), clothing_size=VALUES(clothing_size), fit_preference=VALUES(fit_preference), interests=VALUES(interests)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, p.getUserId());
            ps.setString(2, p.getUsername());
            ps.setString(3, p.getStyle());
            ps.setString(4, p.getSize());
            ps.setString(5, p.getFit());
            ps.setString(6, p.getInterests());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean setUserVerified(String email) {
        String sql = "UPDATE users SET verified=1 WHERE email=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getUserByEmail(String email) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User(
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password")
                    );
                    user.setId(rs.getInt("id"));
                    user.setRole(rs.getString("role"));
                    user.setVerified(rs.getBoolean("verified"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}