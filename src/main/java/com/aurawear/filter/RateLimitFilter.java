package com.aurawear.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.logging.Logger;

/**
 * IP-based rate limiter for authentication and registration endpoints.
 *
 * <p>Tracks POST request counts per IP using a fixed-window algorithm
 * (10 requests per 60-second window). GET requests pass through without
 * rate limiting. Stale tracking entries are purged every 100 requests.</p>
 */
@WebFilter(urlPatterns = {"/login", "/admin/login", "/register", "/otp-verify"})
public class RateLimitFilter implements Filter {

    private static final Logger logger = Logger.getLogger(RateLimitFilter.class.getName());

    /** Maximum number of POST requests allowed per window per IP. */
    private static final int MAX_REQUESTS = 10;

    /** Window duration in milliseconds (60 seconds). */
    private static final long WINDOW_MS = 60_000L;

    /** Stale-entry threshold in milliseconds (5 minutes). */
    private static final long STALE_THRESHOLD_MS = 5 * 60_000L;

    /** How often (in total request count) to trigger cleanup. */
    private static final long CLEANUP_INTERVAL = 100;

    /**
     * Per-IP tracking: {@code long[0]} = request count within the current
     * window, {@code long[1]} = window start timestamp (epoch millis).
     */
    private final ConcurrentHashMap<String, long[]> requestCounts = new ConcurrentHashMap<>();

    /** Global request counter used to trigger periodic cleanup. */
    private final AtomicLong totalRequests = new AtomicLong(0);

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("RateLimitFilter initialized — max " + MAX_REQUESTS
                + " POST requests per " + (WINDOW_MS / 1000) + "s window");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (!(request instanceof HttpServletRequest httpRequest)
                || !(response instanceof HttpServletResponse httpResponse)) {
            chain.doFilter(request, response);
            return;
        }

        // Only rate-limit POST requests.
        if (!"POST".equalsIgnoreCase(httpRequest.getMethod())) {
            chain.doFilter(request, response);
            return;
        }

        String clientIp = getClientIp(httpRequest);
        long now = System.currentTimeMillis();

        // Periodic cleanup of stale entries.
        if (totalRequests.incrementAndGet() % CLEANUP_INTERVAL == 0) {
            cleanupStaleEntries(now);
        }

        // Atomic compute: either reset the window or increment the counter.
        long[] bucket = requestCounts.compute(clientIp, (ip, existing) -> {
            if (existing == null || (now - existing[1]) >= WINDOW_MS) {
                // New window.
                return new long[]{1, now};
            }
            existing[0]++;
            return existing;
        });

        if (bucket[0] > MAX_REQUESTS) {
            logger.warning(() -> "Rate limit exceeded for IP " + clientIp
                    + " on " + httpRequest.getServletPath());
            httpResponse.setStatus(429); // Too Many Requests
            httpResponse.setContentType("text/plain");
            httpResponse.getWriter().write("Too many requests. Please try again later.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        requestCounts.clear();
        logger.info("RateLimitFilter destroyed");
    }

    /**
     * Removes entries whose window started more than {@link #STALE_THRESHOLD_MS}
     * ago, freeing memory from IPs that are no longer active.
     */
    private void cleanupStaleEntries(long now) {
        int removed = 0;
        for (Map.Entry<String, long[]> entry : requestCounts.entrySet()) {
            if ((now - entry.getValue()[1]) > STALE_THRESHOLD_MS) {
                requestCounts.remove(entry.getKey());
                removed++;
            }
        }
        if (removed > 0) {
            int count = removed;
            logger.fine(() -> "Cleaned up " + count + " stale rate-limit entries");
        }
    }

    /**
     * Extracts the client IP address for Render deployment.
     *
     * <p>Render's load balancers set the FIRST IP entry in X-Forwarded-For to the real
     * client IP. This method extracts that first IP entry, falling back to X-Real-IP
     * and request.getRemoteAddr() if absent.
     */
    private String getClientIp(HttpServletRequest request) {
        String xff = request.getHeader("X-Forwarded-For");
        if (xff != null && !xff.trim().isEmpty()) {
            String[] ips = xff.split(",");
            String firstIp = ips[0].trim();
            if (!firstIp.isEmpty()) {
                return firstIp;
            }
        }
        String realIp = request.getHeader("X-Real-IP");
        if (realIp != null && !realIp.trim().isEmpty()) {
            return realIp.trim();
        }
        return request.getRemoteAddr();
    }
}
