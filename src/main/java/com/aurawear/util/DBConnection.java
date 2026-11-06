package com.aurawear.util;

import com.aurawear.config.AppConfig;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Database connection pool using HikariCP.
 *
 * Credentials can be provided via environment variables:
 *   AURAWEAR_DB_URL
 *   AURAWEAR_DB_USER
 *   AURAWEAR_DB_PASSWORD
 *
 * If the configured database is unreachable or points to an expired host,
 * DBConnection automatically falls back to the embedded local MariaDB container
 * instance (localhost:3306/aurawear) to ensure high availability and self-healing.
 */
public class DBConnection {
    private static HikariDataSource dataSource;

    private static synchronized void initializeDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            return;
        }

        String url      = AppConfig.get("AURAWEAR_DB_URL");
        String user     = AppConfig.get("AURAWEAR_DB_USER");
        String password = AppConfig.get("AURAWEAR_DB_PASSWORD");

        // Check if the configured URL is pointing to the dead/expired Aiven domain
        boolean isDeadDomain = (url != null && url.contains("mysql-1270e094-mukundamadhavareddy540-7efb.l.aivencloud.com"));

        if (!isDeadDomain && url != null && user != null && password != null) {
            try {
                System.out.println("[DBConnection] Attempting to connect to configured DB: " + url);
                dataSource = createPool(url, user, password);
                // Test connection
                try (Connection test = dataSource.getConnection()) {
                    System.out.println("[DBConnection] Successfully connected to configured DB.");
                    return;
                }
            } catch (Exception e) {
                System.err.println("[DBConnection] Configured DB connection failed: " + e.getMessage() + ". Activating internal container fallback.");
                if (dataSource != null) {
                    try { dataSource.close(); } catch (Exception ignored) {}
                    dataSource = null;
                }
            }
        }

        // ── Fallback to internal/local MariaDB database ───────────────────────
        System.out.println("[DBConnection] Initializing fallback local MariaDB on localhost:3306/aurawear...");
        String fallbackUrl = "jdbc:mysql://localhost:3306/aurawear?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        String fallbackUser = "root";
        String fallbackPass = "Root1234";

        try {
            dataSource = createPool(fallbackUrl, fallbackUser, fallbackPass);
            try (Connection test = dataSource.getConnection()) {
                System.out.println("[DBConnection] Successfully connected to fallback local MariaDB! ✓");
            }
        } catch (Exception e) {
            String details = e.getMessage();
            if (e.getCause() != null) {
                details += " | Cause: " + e.getCause().getMessage();
            }
            throw new RuntimeException("[DBConnection] Failed to initialise HikariCP data source: " + details, e);
        }
    }

    private static HikariDataSource createPool(String url, String user, String password) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(url);
        config.setUsername(user);
        config.setPassword(password);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");

        config.addDataSourceProperty("connectTimeout", "4000");
        config.addDataSourceProperty("socketTimeout",  "5000");

        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setIdleTimeout(30000);
        config.setMaxLifetime(1800000);
        config.setConnectionTimeout(6000);

        return new HikariDataSource(config);
    }

    public static Connection getConnection() {
        try {
            if (dataSource == null || dataSource.isClosed()) {
                initializeDataSource();
            }
            return dataSource.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException("[DBConnection] Failed to obtain a database connection", e);
        }
    }
}
