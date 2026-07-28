package com.aurawear.controller;

import com.aurawear.dao.UserDAO;
import com.aurawear.util.EmailUtil;

import java.io.IOException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // RESEND OTP
        if ("true".equals(request.getParameter("resend"))) {
            System.out.println("[REGISTRATION][RESEND] Resend OTP requested");
            HttpSession session = request.getSession();
            String email = (String) session.getAttribute("pendingEmail");
            System.out.println("[REGISTRATION][RESEND] Session pendingEmail: '" + email + "'");

            if (email == null || email.isEmpty()) {
                System.err.println("[REGISTRATION][RESEND] ERROR: No pending email in session — cannot resend");
                request.setAttribute("error", "Session expired. Please register again.");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                return;
            }

            // ✅ SECURITY: use cryptographically secure random — Math.random() is predictable
            java.security.SecureRandom sr = new java.security.SecureRandom();
            String otp = String.format("%06d", sr.nextInt(1_000_000));
            session.setAttribute("otp", otp);
            session.setAttribute("otpCreatedAt", System.currentTimeMillis());
            session.removeAttribute("otpAttempts");
            System.out.println("[REGISTRATION][RESEND] New OTP generated and stored in session");

            try {
                System.out.println("[REGISTRATION][RESEND] Calling EmailUtil.sendOTP() for '" + email + "'");
                EmailUtil.sendOTP(email, otp);
                System.out.println("[REGISTRATION][RESEND] OTP resent successfully to '" + email + "'");
            } catch (Exception e) {
                System.err.println("[REGISTRATION][RESEND] Exception sending OTP to '" + email + "': " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Could not resend OTP. Please try again.");
            }

            request.setAttribute("showOtp", true);
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[REGISTRATION] ============ NEW REGISTRATION ATTEMPT ============");

        // ── STEP 1: Form parameters ──────────────────────────────────────────────
        System.out.println("[REGISTRATION] STEP 1: Reading form parameters");
        String firstName = request.getParameter("firstName");
        String lastName  = request.getParameter("lastName");
        String name      = firstName + " " + lastName;
        String email     = request.getParameter("email");
        String password  = request.getParameter("password");
        String username  = request.getParameter("username");

        System.out.println("[REGISTRATION] firstName     : '" + firstName + "'");
        System.out.println("[REGISTRATION] lastName      : '" + lastName + "'");
        System.out.println("[REGISTRATION] username      : '" + username + "'");
        System.out.println("[REGISTRATION] email (raw)   : '" + email + "'");
        System.out.println("[REGISTRATION] password set  : " + (password != null && !password.isEmpty()));

        // ── STEP 2: Form validation ──────────────────────────────────────────────
        System.out.println("[REGISTRATION] STEP 2: Form validation");
        if (email == null || email.trim().isEmpty()) {
            System.err.println("[REGISTRATION] VALIDATION FAILED: email is null or empty");
            request.setAttribute("error", "Email address is required.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            System.err.println("[REGISTRATION] VALIDATION FAILED: password is null or empty");
            request.setAttribute("error", "Password is required.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        String normalizedEmail = email.trim().toLowerCase();
        System.out.println("[REGISTRATION] email (normalized): '" + normalizedEmail + "'");
        System.out.println("[REGISTRATION] STEP 2: Validation PASSED");

        String[] interestsArr = request.getParameterValues("interests");
        String interests = (interestsArr != null) ? String.join(",", interestsArr) : "";

        // ── STEP 3: Duplicate email check ────────────────────────────────────────
        System.out.println("[REGISTRATION] STEP 3: Checking duplicate email in database");
        boolean exists;
        try {
            UserDAO dao = new UserDAO();
            exists = dao.emailExists(normalizedEmail);
            System.out.println("[REGISTRATION] emailExists(" + normalizedEmail + ") = " + exists);
        } catch (Exception e) {
            System.err.println("[REGISTRATION] STEP 3 FAILED: Database error checking email: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "A database error occurred. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        if (exists) {
            System.out.println("[REGISTRATION] BLOCKED: Duplicate email detected — '" + normalizedEmail + "'");
            request.setAttribute("emailError", "This email is already registered.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }
        System.out.println("[REGISTRATION] STEP 3: Email is new — proceeding");

        // ── STEP 4: OTP generation ───────────────────────────────────────────────
        System.out.println("[REGISTRATION] STEP 4: Generating OTP");
        // ✅ SECURITY: use cryptographically secure random — Math.random() is predictable
        java.security.SecureRandom sr = new java.security.SecureRandom();
        String otp = String.format("%06d", sr.nextInt(1_000_000));
        // ✅ SECURITY: do NOT log the OTP — it is a single-use secret

        // ── STEP 5: Session storage ──────────────────────────────────────────────
        System.out.println("[REGISTRATION] STEP 5: Storing data in session");
        HttpSession session = request.getSession();
        session.setAttribute("pendingName",      name);
        session.setAttribute("pendingEmail",     normalizedEmail);
        // ✅ SECURITY: store the PBKDF2 hash, NOT the raw plaintext password
        session.setAttribute("pendingPassword",  com.aurawear.util.PasswordUtil.hashPassword(password));
        session.setAttribute("pendingUsername",  username);
        session.setAttribute("pendingInterests", interests);
        session.setAttribute("otp",              otp);
        session.setAttribute("otpCreatedAt",     System.currentTimeMillis());
        session.removeAttribute("otpAttempts");
        System.out.println("[REGISTRATION] STEP 5: Session stored — pendingEmail='" + normalizedEmail + "'");

        // ── STEP 6: Email delivery ───────────────────────────────────────────────
        System.out.println("[REGISTRATION] STEP 6: Sending OTP email to '" + normalizedEmail + "'");
        try {
            EmailUtil.sendOTP(normalizedEmail, otp);
            System.out.println("[REGISTRATION] STEP 6: OTP email SENT successfully to '" + normalizedEmail + "'");
        } catch (Exception e) {
            System.err.println("[REGISTRATION] STEP 6 FAILED: Exception sending OTP email to '" + normalizedEmail + "'");
            System.err.println("[REGISTRATION] Exception type   : " + e.getClass().getName());
            System.err.println("[REGISTRATION] Exception message: " + e.getMessage());
            e.printStackTrace();
            // *** DO NOT throw — return a friendly error page instead ***
            request.setAttribute("error",
                "We could not send the verification email to '" + normalizedEmail +
                "'. Please check the address and try again. (" + e.getMessage() + ")");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // ── STEP 7: Forward to OTP entry page ───────────────────────────────────
        System.out.println("[REGISTRATION] STEP 7: Forwarding to OTP entry view");
        request.setAttribute("showOtp", true);
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp")
               .forward(request, response);
        System.out.println("[REGISTRATION] ============ REGISTRATION FLOW COMPLETE ============");
    }
}