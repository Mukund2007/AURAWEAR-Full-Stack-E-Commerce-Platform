package com.aurawear.config;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

/**
 * AppConfig — Centralized environment configuration loader.
 *
 * Resolution order for every variable (first non-null wins):
 *   1. OS environment variable   → System.getenv("VAR")
 *   2. JVM system property       → System.getProperty("VAR") / -DVAR=value
 *   3. app-local.properties      → src/main/resources/app-local.properties (git-ignored)
 *
 * Required variables must be declared in REQUIRED_VARS. The application will
 * throw a fatal RuntimeException at first use if any required variable is absent.
 *
 * Usage:
 *   String dbUrl      = AppConfig.get("AURAWEAR_DB_URL");
 *   String emailPass  = AppConfig.get("AURAWEAR_EMAIL_PASSWORD");
 *   boolean liveMode  = AppConfig.getBoolean("RAZORPAY_LIVE_MODE");
 */
public class AppConfig {

    // ── Required variables — startup will FAIL if any of these are missing ──────
    private static final String[] REQUIRED_VARS = {
        // Razorpay mode (defaults to false if absent)
    };

    // ── Local-dev fallback properties (git-ignored) ─────────────────────────────
    private static final Properties LOCAL_PROPS = loadLocalProps();

    private static Properties loadLocalProps() {
        Properties p = new Properties();
        try (InputStream in = AppConfig.class
                .getClassLoader()
                .getResourceAsStream("app-local.properties")) {
            if (in != null) {
                p.load(in);
                System.out.println("[AppConfig] Loaded app-local.properties (local-dev override)");
            }
        } catch (Exception ignored) { /* file is optional in production */ }
        return p;
    }

    /**
     * Resolves a configuration value: env → system property → local properties.
     * Returns null if the variable is not found anywhere.
     */
    public static String get(String key) {
        String v = System.getenv(key);
        if (v != null && !v.isEmpty()) return v;
        v = System.getProperty(key);
        if (v != null && !v.isEmpty()) return v;
        v = LOCAL_PROPS.getProperty(key);
        return (v != null && !v.isEmpty()) ? v : null;
    }

    /**
     * Resolves a boolean configuration value.
     * Returns false if the variable is absent or not "true" (case-insensitive).
     */
    public static boolean getBoolean(String key) {
        String v = get(key);
        return Boolean.parseBoolean(v);
    }

    /**
     * Resolves a value and returns {@code defaultValue} if absent.
     */
    public static String getOrDefault(String key, String defaultValue) {
        String v = get(key);
        return v != null ? v : defaultValue;
    }

    /**
     * Validates that all required variables are resolvable.
     * Call this from a ServletContextListener at startup.
     *
     * @throws RuntimeException listing every missing variable if any are absent.
     */
    public static void validateRequiredVars() {
        List<String> missing = new ArrayList<>();
        for (String key : REQUIRED_VARS) {
            if (get(key) == null) {
                missing.add(key);
            }
        }
        if (!missing.isEmpty()) {
            throw new RuntimeException(
                "[AppConfig] FATAL — Application cannot start. " +
                "The following required environment variables are not set:\n  • " +
                String.join("\n  • ", missing) +
                "\nSet them as OS environment variables, JVM -D properties, " +
                "or in src/main/resources/app-local.properties (local dev only)."
            );
        }
        System.out.println("[AppConfig] All required environment variables are present ✓");
    }
}
