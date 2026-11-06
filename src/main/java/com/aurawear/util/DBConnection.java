package com.aurawear.util;

import com.aurawear.config.AppConfig;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Database connection pool using HikariCP.
 *
 * Credentials are loaded exclusively from environment variables via AppConfig:
 *   AURAWEAR_DB_URL      — full JDBC URL  (e.g. jdbc:mysql://host:3306/aurawear)
 *   AURAWEAR_DB_USER     — database username
 *   AURAWEAR_DB_PASSWORD — database password
 *
 * No hardcoded credentials. Local development values go in
 * src/main/resources/app-local.properties (git-ignored).
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

        if (url == null || user == null || password == null) {
            throw new RuntimeException(
                "[DBConnection] FATAL — One or more database environment variables are not set. " +
                "Required: AURAWEAR_DB_URL, AURAWEAR_DB_USER, AURAWEAR_DB_PASSWORD"
            );
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(url);
            config.setUsername(user);
            config.setPassword(password);
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");

            // Fail fast if database is unreachable
            config.addDataSourceProperty("connectTimeout", "5000");
            config.addDataSourceProperty("socketTimeout",  "5000");

            // Pool configuration optimised for typical servlet container workloads
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setIdleTimeout(30000);
            config.setMaxLifetime(1800000);
            config.setConnectionTimeout(10000);

            dataSource = new HikariDataSource(config);
        } catch (Exception e) {
            String details = e.getMessage();
            if (e.getCause() != null) {
                details += " | Cause: " + e.getCause().getMessage();
            }
            throw new RuntimeException("[DBConnection] Failed to initialise HikariCP data source: " + details, e);
        }
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