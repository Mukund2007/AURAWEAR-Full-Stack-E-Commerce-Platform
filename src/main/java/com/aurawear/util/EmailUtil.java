package com.aurawear.util;

import com.aurawear.config.AppConfig;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

/**
 * Email utility for sending OTP and order confirmation emails via Brevo HTTP API.
 *
 * Credentials are loaded exclusively from environment variables via AppConfig:
 *   BREVO_API_KEY       — API key from brevo.com
 *   AURAWEAR_EMAIL      — verified sender email address on Brevo
 *
 * Uses Brevo Transactional Email API (v3) over HTTPS — works on Render.
 * No SMTP ports required.
 */
public class EmailUtil {

    private static final String BREVO_API_URL = "https://api.brevo.com/v3/smtp/email";

    private static final HttpClient HTTP_CLIENT = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .build();

    private static String getApiKey() {
        String v = AppConfig.get("BREVO_API_KEY");
        if (v == null) throw new RuntimeException(
            "[EmailUtil] BREVO_API_KEY environment variable is not set");
        return v;
    }

    private static String getFromEmail() {
        String v = AppConfig.get("AURAWEAR_EMAIL");
        if (v == null) throw new RuntimeException(
            "[EmailUtil] AURAWEAR_EMAIL environment variable is not set");
        return v;
    }

    // ─── sendOTP ────────────────────────────────────────────────────────────────

    public static void sendOTP(String toEmail, String otp) throws Exception {

        System.out.println("[EmailUtil.sendOTP] Recipient  : '" + toEmail + "'");
        // ✅ SECURITY: do NOT log the OTP itself — it is a single-use authentication secret
        System.out.println("[EmailUtil.sendOTP] Sender     : '" + getFromEmail() + "'");
        System.out.println("[EmailUtil.sendOTP] Sending via Brevo HTTP API...");

        String json = buildBrevoJson(
            getFromEmail(),
            "AuraWear",
            toEmail,
            "Your AuraWear Verification Code",
            buildOtpEmailHTML(otp)
        );

        HttpResponse<String> response = postToBrevo(json);

        System.out.println("[EmailUtil.sendOTP] Brevo HTTP status  : " + response.statusCode());
        System.out.println("[EmailUtil.sendOTP] Brevo response body: " + response.body());

        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new RuntimeException(
                "[EmailUtil.sendOTP] Brevo rejected request (HTTP " +
                response.statusCode() + "): " + response.body());
        }

        System.out.println("[EmailUtil.sendOTP] Email accepted by Brevo for: " + toEmail);
    }

    // ─── sendOrderConfirmation overloads ────────────────────────────────────────

    public static void sendOrderConfirmation(
            String toEmail, String orderId,
            java.util.List<com.aurawear.model.CartItem> items,
            double totalAmount) throws Exception {
        sendOrderConfirmation(toEmail, orderId, items, totalAmount, false,
                null, null, null, null, null, null);
    }

    public static void sendOrderConfirmation(
            String toEmail, String orderId,
            java.util.List<com.aurawear.model.CartItem> items,
            double totalAmount, boolean isCOD) throws Exception {
        sendOrderConfirmation(toEmail, orderId, items, totalAmount, isCOD,
                null, null, null, null, null, null);
    }

    public static void sendOrderConfirmation(
            String toEmail, String orderId,
            java.util.List<com.aurawear.model.CartItem> items,
            double totalAmount, boolean isCOD,
            String shippingName, String shippingPhone, String shippingAddress,
            String shippingCity, String shippingState, String shippingPincode) throws Exception {

        String subject = isCOD
                ? "Your AuraWear Order Confirmation (COD) - #" + orderId
                : "Your AuraWear Order Confirmation - #" + orderId;

        String html = buildOrderEmailHTML(orderId, items, totalAmount, isCOD,
                shippingName, shippingPhone, shippingAddress,
                shippingCity, shippingState, shippingPincode);

        String json = buildBrevoJson(getFromEmail(), "AuraWear", toEmail, subject, html);
        HttpResponse<String> response = postToBrevo(json);

        System.out.println("[EmailUtil.sendOrderConfirmation] Brevo HTTP status: " + response.statusCode());

        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new RuntimeException(
                "[EmailUtil.sendOrderConfirmation] Brevo rejected request (HTTP " +
                response.statusCode() + "): " + response.body());
        }

        System.out.println("Order confirmation email sent to: " + toEmail +
                " for order: " + orderId + " (COD=" + isCOD + ")");
    }

    // ─── Internal helpers ────────────────────────────────────────────────────────

    private static HttpResponse<String> postToBrevo(String json) throws Exception {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(BREVO_API_URL))
                .header("api-key", getApiKey())
                .header("Content-Type", "application/json")
                .header("Accept", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(json))
                .timeout(Duration.ofSeconds(15))
                .build();

        return HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());
    }

    private static String buildBrevoJson(String fromEmail, String fromName,
                                          String toEmail, String subject, String html) {
        return "{"
            + "\"sender\":{"
            +   "\"name\":"  + jsonString(fromName)  + ","
            +   "\"email\":" + jsonString(fromEmail)
            + "},"
            + "\"to\":[{"
            +   "\"email\":" + jsonString(toEmail)
            + "}],"
            + "\"subject\":" + jsonString(subject) + ","
            + "\"htmlContent\":" + jsonString(html)
            + "}";
    }

    private static String jsonString(String value) {
        if (value == null) return "\"\"";
        String escaped = value
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r")
            .replace("\t", "\\t");
        return "\"" + escaped + "\"";
    }

    // ─── Email HTML builders ─────────────────────────────────────────────────────

    private static String buildOtpEmailHTML(String otp) {
        return "<!DOCTYPE html>" +
            "<html><head><meta charset='UTF-8'></head><body style='" +
            "margin:0;padding:0;background:#f5f2ee;font-family:Arial,sans-serif;'>" +
            "<table width='100%' cellpadding='0' cellspacing='0'><tr><td align='center' style='padding:40px 20px;'>" +
            "<table width='520' cellpadding='0' cellspacing='0' style='" +
            "background:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08);'>" +

            "<tr><td style='background:#111111;padding:36px 40px;text-align:center;'>" +
            "<span style='color:#fff;font-size:22px;font-weight:700;letter-spacing:4px;'>AURAWEAR</span><br>" +
            "<span style='color:rgba(255,255,255,0.5);font-size:11px;letter-spacing:3px;'>WEAR YOUR AURA</span>" +
            "</td></tr>" +

            "<tr><td style='padding:44px 40px;text-align:center;'>" +
            "<p style='font-size:16px;color:#444;margin:0 0 8px;'>Your verification code is</p>" +
            "<div style='font-size:48px;font-weight:700;letter-spacing:12px;color:#111;margin:24px 0;'>" +
            otp + "</div>" +
            "<p style='font-size:13px;color:#999;margin:0 0 32px;'>This code expires in <strong>10 minutes</strong>. Do not share it with anyone.</p>" +
            "<hr style='border:none;border-top:1px solid #f0ede8;margin:0 0 28px;'>" +
            "<p style='font-size:12px;color:#bbb;margin:0;'>If you didn't create an AuraWear account, ignore this email.</p>" +
            "</td></tr>" +

            "<tr><td style='background:#faf9f6;padding:24px 40px;text-align:center;'>" +
            "<p style='font-size:11px;color:#ccc;margin:0;letter-spacing:0.5px;'>" +
            "&copy; 2026 AuraWear. All Rights Reserved.</p>" +
            "</td></tr>" +

            "</table></td></tr></table></body></html>";
    }

    private static String buildOrderEmailHTML(
            String orderId, java.util.List<com.aurawear.model.CartItem> items,
            double totalAmount, boolean isCOD,
            String shippingName, String shippingPhone, String shippingAddress,
            String shippingCity, String shippingState, String shippingPincode) {

        StringBuilder sb = new StringBuilder();
        sb.append("<!DOCTYPE html>")
          .append("<html><head><meta charset='UTF-8'></head><body style='margin:0;padding:0;background:#f5f2ee;font-family:Arial,sans-serif;'>")
          .append("<table width='100%' cellpadding='0' cellspacing='0'><tr><td align='center' style='padding:40px 20px;'>")
          .append("<table width='560' cellpadding='0' cellspacing='0' style='background:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08);'>")
          .append("<tr><td style='background:#111111;padding:36px 40px;text-align:center;'>")
          .append("<span style='color:#fff;font-size:22px;font-weight:700;letter-spacing:4px;'>AURAWEAR</span><br>")
          .append("<span style='color:rgba(255,255,255,0.5);font-size:11px;letter-spacing:3px;'>WEAR YOUR AURA</span>")
          .append("</td></tr>")
          .append("<tr><td style='padding:40px;color:#111111;'>");

        if (isCOD) {
            sb.append("<h2 style='font-size:20px;font-weight:800;text-transform:uppercase;margin:0 0 8px;'>Order Placed (COD)</h2>")
              .append("<p style='font-size:14px;color:#666666;margin:0 0 24px;line-height:1.5;'>Thank you for shopping with AuraWear. Payment should be made in cash upon delivery.</p>");
        } else {
            sb.append("<h2 style='font-size:20px;font-weight:800;text-transform:uppercase;margin:0 0 8px;'>Order Confirmed</h2>")
              .append("<p style='font-size:14px;color:#666666;margin:0 0 24px;line-height:1.5;'>Thank you for shopping with AuraWear. Your order details are outlined below.</p>");
        }

        sb.append("<div style='background:#faf9f6;padding:16px 20px;margin-bottom:24px;border-left:4px solid #ff0001;'>")
          .append("<span style='font-size:12px;font-weight:700;text-transform:uppercase;color:#888888;'>Order Number</span><br>")
          .append("<span style='font-size:16px;font-weight:800;color:#111111;'>#").append(orderId).append("</span>")
          .append("</div>");

        if (shippingName != null && !shippingName.trim().isEmpty()) {
            sb.append("<div style='background:#f8f6f3;padding:16px 20px;margin-bottom:24px;border-left:4px solid #111111;'>")
              .append("<span style='font-size:12px;font-weight:700;text-transform:uppercase;color:#888888;'>Delivery Address</span><br>")
              .append("<span style='font-size:14px;font-weight:700;color:#111111;'>").append(shippingName).append("</span><br>")
              .append("<span style='font-size:13px;color:#555555;'>").append(shippingPhone != null ? shippingPhone : "").append("</span><br>")
              .append("<span style='font-size:13px;color:#555555;'>").append(shippingAddress != null ? shippingAddress : "").append("</span><br>")
              .append("<span style='font-size:13px;color:#555555;'>")
              .append(shippingCity != null ? shippingCity : "").append(", ")
              .append(shippingState != null ? shippingState : "").append(" - ")
              .append(shippingPincode != null ? shippingPincode : "")
              .append("</span></div>");
        }

        sb.append("<table width='100%' cellpadding='0' cellspacing='0' style='border-collapse:collapse;'>")
          .append("<thead><tr style='border-bottom:2px solid #111111;text-align:left;'>")
          .append("<th style='padding:8px 0;font-size:11px;font-weight:700;text-transform:uppercase;color:#111111;'>Item</th>")
          .append("<th style='padding:8px 0;font-size:11px;font-weight:700;text-transform:uppercase;color:#111111;text-align:center;'>Qty</th>")
          .append("<th style='padding:8px 0;font-size:11px;font-weight:700;text-transform:uppercase;color:#111111;text-align:right;'>Price</th>")
          .append("</tr></thead><tbody>");

        for (com.aurawear.model.CartItem item : items) {
            sb.append("<tr style='border-bottom:1px solid #f0ede8;'>")
              .append("<td style='padding:12px 0;'>")
              .append("<span style='font-size:14px;font-weight:600;color:#111111;'>").append(item.getProductName()).append("</span><br>")
              .append("<span style='font-size:11px;color:#888888;'>Size: ").append(item.getSize()).append("</span>")
              .append("</td>")
              .append("<td style='padding:12px 0;font-size:14px;color:#111111;text-align:center;'>").append(item.getQuantity()).append("</td>")
              .append("<td style='padding:12px 0;font-size:14px;font-weight:600;color:#111111;text-align:right;'>₹").append(item.getPrice() * item.getQuantity()).append("</td>")
              .append("</tr>");
        }

        sb.append("</tbody></table>")
          .append("<table width='100%' cellpadding='0' cellspacing='0' style='margin-top:20px;'><tr>");

        sb.append(isCOD
            ? "<td style='font-size:14px;font-weight:700;color:#666666;'>Total to Pay (COD)</td>"
            : "<td style='font-size:14px;font-weight:700;color:#666666;'>Total Paid</td>");

        sb.append("<td style='font-size:20px;font-weight:800;color:#ff0001;text-align:right;'>₹")
          .append(String.format("%.0f", totalAmount)).append("</td>")
          .append("</tr></table>")
          .append("<hr style='border:none;border-top:1px solid #f0ede8;margin:32px 0 24px;'>")
          .append("<p style='font-size:12px;color:#888888;line-height:1.5;margin:0;text-align:center;'>")
          .append("Our logistics team is already sorting your choices. We'll update you once it ships.")
          .append("</p></td></tr>")
          .append("<tr><td style='background:#faf9f6;padding:24px 40px;text-align:center;'>")
          .append("<p style='font-size:11px;color:#bbb;margin:0;letter-spacing:0.5px;'>")
          .append("&copy; 2026 AuraWear. All Rights Reserved.</p>")
          .append("</td></tr>")
          .append("</table></td></tr></table></body></html>");

        return sb.toString();
    }
}