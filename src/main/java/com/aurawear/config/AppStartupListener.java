package com.aurawear.config;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * AppStartupListener — Validates all required environment variables at application startup.
 *
 * Registered as a ServletContextListener so it runs before any servlet handles a request.
 * If any required variable is missing the context initialization is aborted with a clear
 * error message, preventing the application from starting in a misconfigured state.
 *
 * Required variables checked:
 *   Database  : AURAWEAR_DB_URL, AURAWEAR_DB_USER, AURAWEAR_DB_PASSWORD
 *   Email     : AURAWEAR_EMAIL, AURAWEAR_EMAIL_PASSWORD
 *   Razorpay  : RAZORPAY_LIVE_MODE (+ mode-specific key/secret pair)
 */
@WebListener
public class AppStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        
        // Dynamically configure session cookie security based on the environment
        boolean isRender = System.getenv("RENDER") != null;
        ctx.getSessionCookieConfig().setHttpOnly(true);
        ctx.getSessionCookieConfig().setSecure(isRender);
        ctx.log("[AppStartupListener] Dynamic Session Cookie Secure flag set to: " + isRender);
        
        ctx.log("[AppStartupListener] Validating required environment variables...");

        try {
            // Validate core required vars
            AppConfig.validateRequiredVars();

            // Validate mode-specific Razorpay keys
            boolean liveMode = AppConfig.getBoolean("RAZORPAY_LIVE_MODE");
            if (liveMode) {
                requireVar("RAZORPAY_LIVE_KEY_ID");
                requireVar("RAZORPAY_LIVE_KEY_SECRET");
                ctx.log("[AppStartupListener] Razorpay mode: LIVE ✓");
            } else {
                requireVar("RAZORPAY_TEST_KEY_ID");
                requireVar("RAZORPAY_TEST_KEY_SECRET");
                ctx.log("[AppStartupListener] Razorpay mode: TEST ✓");
            }

            ctx.log("[AppStartupListener] All environment variables validated successfully. Application starting. ✓");

            // Seed the products table if it is empty (ensures Render deploys have data)
            try {
                DatabaseSeeder.seedIfEmpty();
                ctx.log("[AppStartupListener] Database seed check completed. ✓");
            } catch (Exception e) {
                ctx.log("[AppStartupListener] WARNING: Database seeding failed — " + e.getMessage());
            }

            // Log warning if email config is missing (but don't block startup)
            if (AppConfig.get("BREVO_API_KEY") == null || AppConfig.get("AURAWEAR_EMAIL") == null) {
                ctx.log("[AppStartupListener] WARNING: Email configuration (BREVO_API_KEY or AURAWEAR_EMAIL) is not set. Email delivery will fail if triggered.");
            }

        } catch (RuntimeException e) {
            // Log clearly and re-throw to abort startup
            ctx.log("[AppStartupListener] FATAL STARTUP ERROR: " + e.getMessage());
            System.err.println("\n========================================================");
            System.err.println("  AURAWEAR STARTUP FAILED — MISSING ENVIRONMENT VARS");
            System.err.println("========================================================");
            System.err.println(e.getMessage());
            System.err.println("========================================================\n");
            throw e; // Abort context initialization
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        sce.getServletContext().log("[AppStartupListener] Application context destroyed.");
    }

    private static void requireVar(String key) {
        if (AppConfig.get(key) == null) {
            throw new RuntimeException(
                "[AppStartupListener] Required environment variable not set: " + key +
                "\nSet it as an OS env var, JVM -D property, or in app-local.properties (local dev only)."
            );
        }
    }
}
