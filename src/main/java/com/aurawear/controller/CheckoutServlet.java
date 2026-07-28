package com.aurawear.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import com.aurawear.dao.CartDAO;
import com.aurawear.model.CartItem;
import com.aurawear.model.User;
import com.aurawear.config.RazorpayConfig;

import com.razorpay.RazorpayClient;
import com.razorpay.Order;
import org.json.JSONObject;

public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        CartDAO dao = new CartDAO();

        String errorParam = request.getParameter("error");
        if (errorParam != null && !errorParam.trim().isEmpty()) {
            request.setAttribute("errorMsg", errorParam);
        }

        List<CartItem> cartItems = dao.getCartItems(user.getEmail());
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Calculate Totals
        int subtotal = 0;
        for (CartItem item : cartItems) {
            subtotal += item.getPrice() * item.getQuantity();
        }
        int threshold = com.aurawear.util.SettingsUtil.getFreeShippingThreshold();
        int shippingCharge = com.aurawear.util.SettingsUtil.getShippingCharge();
        int shipping = (subtotal > 0 && subtotal < threshold) ? shippingCharge : 0;
        int grandTotal = subtotal + shipping;

        // Convert amount to paise (1 Rupee = 100 Paise)
        int amountInPaise = grandTotal * 100;

        String razorpayOrderId = null;
        String razorpayKeyId = null;

        try {
            razorpayKeyId = RazorpayConfig.getKeyId();
            // Initialize Razorpay Client using configuration constants
            RazorpayClient razorpay = new RazorpayClient(razorpayKeyId, RazorpayConfig.getKeySecret());

            // Create Razorpay Order request
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amountInPaise);
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "txn_" + System.currentTimeMillis());

            Order order = razorpay.orders.create(orderRequest);
            razorpayOrderId = order.get("id");

            // ✅ SECURITY: store order ID + expected amount in session so PaymentSuccessServlet
            // can verify the incoming razorpay_order_id was actually created by this server
            // for this session, preventing replay attacks with foreign order IDs.
            HttpSession checkoutSession = request.getSession(false);
            if (checkoutSession != null) {
                checkoutSession.setAttribute("pendingRazorpayOrderId", razorpayOrderId);
                checkoutSession.setAttribute("pendingAmountInPaise",   amountInPaise);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Failed to initialize checkout with payment gateway: " + e.getMessage());
        }

        // Set request attributes
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("shipping", shipping);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("amountInPaise", amountInPaise);
        request.setAttribute("razorpayOrderId", razorpayOrderId);
        request.setAttribute("razorpayKeyId", razorpayKeyId);
        request.setAttribute("user", user);

        request.getRequestDispatcher("/WEB-INF/views/orders/checkout.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect standard POST to GET checkout page
        doGet(request, response);
    }
}