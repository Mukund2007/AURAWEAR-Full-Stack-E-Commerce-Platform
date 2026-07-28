package com.aurawear.controller;

import com.aurawear.dao.UserDAO;
import com.aurawear.model.User;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/otp-verify")
public class VerifyOTPServlet extends HttpServlet {

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

        response.sendRedirect("register");
    }


    @Override
    protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

        try {
            System.out.println("[OTP_VERIFY] STEP 1 Request received");

            System.out.println("[OTP_VERIFY] STEP 2 OTP parameter read");
            String enteredOtp = request.getParameter("otp");
            // ✅ SECURITY: do NOT log the entered OTP — it is a single-use secret

            System.out.println("[OTP_VERIFY] STEP 3 Session loaded");
            HttpSession session = request.getSession(true);
            
            // Read all session attributes as requested by user
            String pendingEmail = (String) session.getAttribute("pendingEmail");
            String pendingUsername = (String) session.getAttribute("pendingUsername");
            String pendingPassword = (String) session.getAttribute("pendingPassword");
            String pendingName = (String) session.getAttribute("pendingName");
            String pendingInterests = (String) session.getAttribute("pendingInterests");
            String realOtp = (String) session.getAttribute("otp");
            Object otpExpiry = session.getAttribute("otpExpiry"); // explicitly read otpExpiry
            Long otpCreatedAt = (Long) session.getAttribute("otpCreatedAt");

            System.out.println("[OTP_VERIFY] Session Attributes:");
            System.out.println("  - pendingEmail: " + pendingEmail);
            System.out.println("  - pendingUsername: " + pendingUsername);
            System.out.println("  - pendingPassword: " + (pendingPassword != null ? "[PRESENT]" : "[NULL]"));
            System.out.println("  - pendingName: " + pendingName);
            System.out.println("  - pendingInterests: " + pendingInterests);
            System.out.println("  - otp (realOtp): [REDACTED]"); // ✅ SECURITY: never log OTP
            System.out.println("  - otpExpiry: " + otpExpiry);
            System.out.println("  - otpCreatedAt: " + otpCreatedAt);

            System.out.println("[OTP_VERIFY] STEP 4 Session attributes validated");
            // Check for missing critical session attributes
            if (realOtp == null || pendingEmail == null || pendingName == null || pendingPassword == null) {
                System.out.println("[OTP_VERIFY] Session validation FAILED - missing critical attributes");
                request.setAttribute("otpError", "Registration session expired or invalid. Please register again.");
                request.setAttribute("showOtp", false);
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                return;
            }
            System.out.println("[OTP_VERIFY] Session validation PASSED");

            System.out.println("[OTP_VERIFY] STEP 5 OTP compared");
            boolean otpMatches = enteredOtp != null && enteredOtp.equals(realOtp);
            System.out.println("[OTP_VERIFY] OTP matches: " + otpMatches);

            if (otpMatches) {
                // Check OTP expiry (10 minutes)
                if (otpCreatedAt != null && (System.currentTimeMillis() - otpCreatedAt) > 600_000) {
                    System.out.println("[OTP_VERIFY] OTP has expired");
                    session.removeAttribute("otp");
                    session.removeAttribute("otpCreatedAt");
                    request.setAttribute("showOtp", true);
                    request.setAttribute("otpError", "Verification code expired. Please request a new one.");
                    request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                    return;
                }

                System.out.println("[OTP_VERIFY] STEP 6 User object created");
                User user = new User(pendingName, pendingEmail, pendingPassword);
                System.out.println("[OTP_VERIFY] Created user object with email: " + user.getEmail());

                System.out.println("[OTP_VERIFY] STEP 7 User persisted");
                UserDAO dao = new UserDAO();
                boolean saved = dao.registerUser(user);
                System.out.println("[OTP_VERIFY] User save result: " + saved);

                if (saved) {
                    User createdUser = dao.getUserByEmail(pendingEmail);
                    if (createdUser == null) {
                        System.out.println("[OTP_VERIFY] FAILED: User saved but getUserByEmail returned null for " + pendingEmail);
                        throw new RuntimeException("User successfully registered but unable to retrieve back from database.");
                    }

                    int userId = createdUser.getId();
                    System.out.println("[OTP_VERIFY] Retrieved user ID: " + userId);

                    // Create user profile in user_profiles
                    com.aurawear.model.UserProfile profile = new com.aurawear.model.UserProfile(
                        userId,
                        pendingUsername != null ? pendingUsername : "",
                        "",
                        "",
                        "",
                        pendingInterests != null ? pendingInterests : ""
                    );
                    boolean profileSaved = dao.saveProfile(profile);
                    System.out.println("[OTP_VERIFY] Profile saved: " + profileSaved);

                    // Clear session registration attributes
                    session.removeAttribute("otp");
                    session.removeAttribute("otpCreatedAt");
                    session.removeAttribute("otpAttempts");
                    session.removeAttribute("pendingName");
                    session.removeAttribute("pendingEmail");
                    session.removeAttribute("pendingPassword");
                    session.removeAttribute("pendingUsername");
                    session.removeAttribute("pendingInterests");

                    System.out.println("[OTP_VERIFY] STEP 8 User logged in");
                    // Session fixation protection
                    session.invalidate();
                    HttpSession newSession = request.getSession(true);
                    newSession.setAttribute("userId", userId);
                    newSession.setAttribute("user", createdUser);
                    newSession.setAttribute("registrationSuccess", true); // GA4 Event Flag

                    System.out.println("[OTP_VERIFY] STEP 9 Redirect success");
                    response.sendRedirect(request.getContextPath() + "/home");
                } else {
                    System.out.println("[OTP_VERIFY] FAILED: registerUser returned false");
                    request.setAttribute("otpError", "Registration database entry failed. Please try again.");
                    request.setAttribute("showOtp", true);
                    request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                }
            } else {
                System.out.println("[OTP_VERIFY] Comparison failed: Invalid verification code");
                request.setAttribute("showOtp", true);
                request.setAttribute("otpError", "Invalid verification code");

                Integer attempts = (Integer) session.getAttribute("otpAttempts");
                attempts = (attempts == null) ? 1 : attempts + 1;
                session.setAttribute("otpAttempts", attempts);
                System.out.println("[OTP_VERIFY] Failed attempt count: " + attempts);
                if (attempts >= 3) {
                    session.removeAttribute("otp");
                    session.removeAttribute("otpCreatedAt");
                    session.removeAttribute("otpAttempts");
                    request.setAttribute("otpError", "Too many failed attempts. Please register again.");
                    request.setAttribute("showOtp", false);
                }

                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Find the line number of the crash
            int lineNumber = -1;
            String fileName = "VerifyOTPServlet.java";
            for (StackTraceElement element : e.getStackTrace()) {
                if (element.getClassName().contains("VerifyOTPServlet")) {
                    lineNumber = element.getLineNumber();
                    fileName = element.getFileName();
                    break;
                }
            }

            System.err.println("[OTP_VERIFY] UNCAUGHT EXCEPTION IN doPost");
            System.err.println("[OTP_VERIFY] Exception Type: " + e.getClass().getName());
            System.err.println("[OTP_VERIFY] Exception Message: " + e.getMessage());
            System.err.println("[OTP_VERIFY] Crash Location: " + fileName + ":" + lineNumber);
            System.err.println("[OTP_VERIFY] Stack Trace:");
            e.printStackTrace();
            
            String errorMsg = "An unexpected error occurred during OTP verification.";

            request.setAttribute("error", errorMsg);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}