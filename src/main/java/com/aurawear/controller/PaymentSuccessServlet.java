package com.aurawear.controller;

import java.io.IOException;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import com.aurawear.dao.CartDAO;
import com.aurawear.model.User;
import com.aurawear.config.RazorpayConfig;

public class PaymentSuccessServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String email = user.getEmail();

        String razorpayPaymentId = request.getParameter("razorpay_payment_id");
        String razorpayOrderId   = request.getParameter("razorpay_order_id");
        String razorpaySignature = request.getParameter("razorpay_signature");

        // ✅ SECURITY: do NOT log payment ID or signature — PCI-DSS / log-leakage concern
        System.out.println("[PaymentSuccessServlet] Payment callback received");

        if (email == null || email.trim().isEmpty()) {
            System.err.println("[PaymentSuccessServlet] Error: user_email read from session is null or empty!");
            throw new IllegalArgumentException("User email in session is null or empty.");
        }
        System.out.println("[PaymentSuccessServlet] Verified user_email from session: " + email);

        if (razorpayPaymentId == null || razorpayOrderId == null || razorpaySignature == null) {
            System.err.println("[PaymentSuccessServlet] Error: Missing parameters!");
            response.sendRedirect(request.getContextPath() + "/checkout?error=missing_parameters");
            return;
        }

        // ✅ SECURITY: verify the order ID came from this server's session (anti-replay)
        String expectedOrderId = (String) session.getAttribute("pendingRazorpayOrderId");
        if (expectedOrderId == null || !expectedOrderId.equals(razorpayOrderId)) {
            System.err.println("[PaymentSuccessServlet] Order ID mismatch — possible replay attack. " +
                               "Expected=" + expectedOrderId + " Got=(redacted)");
            response.sendRedirect(request.getContextPath() + "/checkout?error=invalid_order");
            return;
        }
        // Consume the pending order ID so it cannot be replayed a second time
        session.removeAttribute("pendingRazorpayOrderId");
        session.removeAttribute("pendingAmountInPaise");

        try {
            // Verify signature: HmacSHA256(order_id + "|" + payment_id, secret)
            String signatureData      = razorpayOrderId + "|" + razorpayPaymentId;
            byte[] generatedSigBytes  = calculateHmacSHA256Bytes(signatureData, RazorpayConfig.getKeySecret());
            byte[] receivedSigBytes   = hexToBytes(razorpaySignature);

            // ✅ SECURITY: constant-time comparison — prevents timing oracle on signature bytes
            if (!java.security.MessageDigest.isEqual(generatedSigBytes, receivedSigBytes)) {
                System.out.println("[PaymentSuccessServlet] Signature verification: FAILED");
                throw new SecurityException("Cryptographic signature mismatch! Invalid payment.");
            }
            System.out.println("[PaymentSuccessServlet] Signature verification: PASSED");

            // Fetch cart items and calculate grand total before the transaction clears them
            CartDAO dao = new CartDAO();
            java.util.List<com.aurawear.model.CartItem> cartItems = dao.getCartItems(email);
            int subtotal = 0;
            if (cartItems != null) {
                for (com.aurawear.model.CartItem item : cartItems) {
                    subtotal += item.getPrice() * item.getQuantity();
                }
            }
            int threshold = com.aurawear.util.SettingsUtil.getFreeShippingThreshold();
            int shippingCharge = com.aurawear.util.SettingsUtil.getShippingCharge();
            int shipping = (subtotal > 0 && subtotal < threshold) ? shippingCharge : 0;
            final double grandTotal = subtotal + shipping;

            String shippingName = request.getParameter("shipping_name");
            String shippingPhone = request.getParameter("shipping_phone");
            String shippingAddress = request.getParameter("shipping_address");
            String shippingCity = request.getParameter("shipping_city");
            String shippingState = request.getParameter("shipping_state");
            String shippingPincode = request.getParameter("shipping_pincode");

            // Save order and clear cart in a single transaction
            System.out.println("[PaymentSuccessServlet] Calling moveCartToOrdersWithPayment for: " + email);
            int orderId = -1;
            try {
                orderId = dao.moveCartToOrdersWithPayment(email, razorpayPaymentId, "PAID",
                                                         shippingName, shippingPhone, shippingAddress,
                                                         shippingCity, shippingState, shippingPincode);
                System.out.println("[PaymentSuccessServlet] moveCartToOrdersWithPayment: SUCCESS, Order ID: " + orderId);
                if (orderId != -1) {
                    session.setAttribute("justPurchased", true);
                    session.setAttribute("purchaseOrderId", orderId);
                    session.setAttribute("purchaseTotal", grandTotal);
                    session.setAttribute("purchaseItems", cartItems);
                }
            } catch (Exception e) {
                System.out.println("[PaymentSuccessServlet] moveCartToOrdersWithPayment: FAILURE");
                e.printStackTrace();
                throw e; // Rethrow to propagate to the outer catch block
            }

            // Trigger order confirmation email asynchronously
            if (orderId != -1 && cartItems != null && !cartItems.isEmpty()) {
                final int finalOrderId = orderId;
                final String finalEmail = email;
                new Thread(() -> {
                    try {
                        System.out.println("[PaymentSuccessServlet] Initiating asynchronous order confirmation email for order: " + finalOrderId);
                        com.aurawear.util.EmailUtil.sendOrderConfirmation(finalEmail, String.valueOf(finalOrderId), cartItems, grandTotal, false,
                                                                         shippingName, shippingPhone, shippingAddress, shippingCity, shippingState, shippingPincode);
                    } catch (Exception e) {
                        System.err.println("[PaymentSuccessServlet] Error sending asynchronous order confirmation email: " + e.getMessage());
                        e.printStackTrace();
                    }
                }).start();
            }

            response.sendRedirect(request.getContextPath() + "/order-success");

        } catch (Exception e) {
            System.err.println("[PaymentSuccessServlet] Exception occurred: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMsg", "Order placement failed: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/orders/checkout.jsp")
                   .forward(request, response);
        }
    }

    /** Returns raw HMAC-SHA256 bytes (for constant-time comparison). */
    private byte[] calculateHmacSHA256Bytes(String data, String keySecret) throws Exception {
        javax.crypto.Mac sha256_HMAC = javax.crypto.Mac.getInstance("HmacSHA256");
        javax.crypto.spec.SecretKeySpec secret_key =
                new javax.crypto.spec.SecretKeySpec(keySecret.getBytes("UTF-8"), "HmacSHA256");
        sha256_HMAC.init(secret_key);
        return sha256_HMAC.doFinal(data.getBytes("UTF-8"));
    }

    /** Converts a lowercase hex string (as returned by Razorpay) to a byte array. */
    private byte[] hexToBytes(String hex) {
        if (hex == null || hex.length() % 2 != 0) return new byte[0];
        byte[] result = new byte[hex.length() / 2];
        for (int i = 0; i < result.length; i++) {
            result[i] = (byte) Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16);
        }
        return result;
    }
}
