package com.aurawear.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.aurawear.config.DatabaseSeeder;
import com.aurawear.util.DBConnection;

@WebServlet("/health")
public class HealthCheckServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain");

        String seedParam = request.getParameter("seed");
        if ("true".equalsIgnoreCase(seedParam)) {
            try {
                DatabaseSeeder.seedIfEmpty();
            } catch (Exception e) {
                response.getWriter().write("Seeder exception: " + e.getMessage() + "\n");
            }
        }

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM products")) {
            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }
            response.getWriter().write("OK [DB: Connected, Products: " + count + "]");
        } catch (Exception e) {
            response.getWriter().write("DEGRADED [DB Error: " + e.getMessage() + "]");
        }
    }
}
