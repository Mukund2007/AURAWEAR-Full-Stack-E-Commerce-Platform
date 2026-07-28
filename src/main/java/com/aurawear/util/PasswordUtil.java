package com.aurawear.util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 * Password hashing utility using PBKDF2WithHmacSHA256.
 *
 * <p>Stored format (v1): {@code v1$<iterations>$<base64-salt>$<base64-hash>}
 * The version prefix allows future iteration-count upgrades without
 * invalidating all existing passwords — old hashes can be re-hashed
 * transparently on next successful login.
 *
 * <p>OWASP 2023 recommendation for PBKDF2-SHA256: ≥ 310,000 iterations.
 */
public class PasswordUtil {

    // ✅ OWASP 2023 minimum for PBKDF2WithHmacSHA256 (was 10,000 — 31× too low)
    private static final int ITERATIONS  = 310_000;
    private static final int KEY_LENGTH  = 256;

    /** Reusable SecureRandom instance (thread-safe). */
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    // ────────────────────────────────────────────────────────────────────────
    // Hash
    // ────────────────────────────────────────────────────────────────────────

    /**
     * Hash a plaintext password.
     *
     * @return versioned hash string: {@code v1$310000$<b64salt>$<b64hash>}
     */
    public static String hashPassword(String password) {
        byte[] salt = new byte[16];
        SECURE_RANDOM.nextBytes(salt);

        byte[] hash = pbkdf2(password.toCharArray(), salt, ITERATIONS);

        return "v1$" + ITERATIONS
             + "$" + Base64.getEncoder().encodeToString(salt)
             + "$" + Base64.getEncoder().encodeToString(hash);
    }

    // ────────────────────────────────────────────────────────────────────────
    // Verify
    // ────────────────────────────────────────────────────────────────────────

    /**
     * Verify a plaintext password against a stored hash.
     *
     * <p>Supports both the new versioned format ({@code v1$…}) and the legacy
     * two-part format ({@code base64salt:base64hash}) so existing accounts
     * continue to work after upgrading.
     *
     * @return {@code true} if the password matches
     */
    public static boolean verifyPassword(String password, String storedHash) {
        if (storedHash == null) return false;

        if (storedHash.startsWith("v1$")) {
            return verifyV1(password, storedHash);
        } else if (storedHash.contains(":")) {
            // Legacy format: base64salt:base64hash with ITERATIONS=10000
            return verifyLegacy(password, storedHash);
        } else {
            throw new IllegalArgumentException("Unknown password hash format.");
        }
    }

    // ────────────────────────────────────────────────────────────────────────
    // Private helpers
    // ────────────────────────────────────────────────────────────────────────

    /** Verify against the v1 versioned format. */
    private static boolean verifyV1(String password, String storedHash) {
        // Format: v1$<iterations>$<b64salt>$<b64hash>
        String[] parts = storedHash.split("\\$", 4);
        if (parts.length != 4) {
            throw new IllegalArgumentException("Invalid v1 hash format: wrong number of parts.");
        }
        int iterations = Integer.parseInt(parts[1]);
        byte[] salt    = Base64.getDecoder().decode(parts[2]);
        byte[] hash    = Base64.getDecoder().decode(parts[3]);

        byte[] testHash = pbkdf2(password.toCharArray(), salt, iterations);
        return java.security.MessageDigest.isEqual(hash, testHash);
    }

    /** Verify against the legacy two-part format (iterations hard-coded to 10,000). */
    private static boolean verifyLegacy(String password, String storedHash) {
        String[] parts = storedHash.split(":", 2);
        if (parts.length != 2) {
            throw new IllegalArgumentException("Invalid legacy hash format.");
        }
        byte[] salt     = Base64.getDecoder().decode(parts[0]);
        byte[] hash     = Base64.getDecoder().decode(parts[1]);
        byte[] testHash = pbkdf2(password.toCharArray(), salt, 10_000);
        return java.security.MessageDigest.isEqual(hash, testHash);
    }

    /** Run PBKDF2WithHmacSHA256 with the given iteration count. */
    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, KEY_LENGTH);
            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            byte[] hash = factory.generateSecret(spec).getEncoded();
            spec.clearPassword();
            return hash;
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException("PBKDF2 error", e);
        }
    }
}
