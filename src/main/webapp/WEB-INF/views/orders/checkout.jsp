<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../partials/head-includes.jsp" />
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout — AuraWear</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/home.css?v=300">
    <link class="checkout-style" rel="stylesheet" href="${ctx}/assets/css/checkout.css?v=300">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body>

    <jsp:include page="../partials/navbar.jsp" />

    <div class="checkout-wrap">

        <div class="checkout-grid">

            <!-- ===== LEFT: BILLING & PAYMENT GATEWAY TRIGGER ===== -->
            <div class="checkout-left">
                <h1 class="checkout-title">Checkout</h1>

                <c:if test="${not empty errorMsg}">
                    <div class="error-banner" style="background: rgba(186, 26, 26, 0.1); border: 1px solid var(--co-error); color: var(--co-error); padding: 16px; font-family: var(--font-body); font-weight: 600; text-transform: uppercase; font-size: 12px; margin-bottom: 24px; letter-spacing: 0.5px; display: inline-flex; align-items: center; gap: 8px;">
                        <span class="material-symbols-outlined" style="font-size: 18px;">warning</span> <c:out value="${errorMsg}" />
                    </div>
                </c:if>

                <!-- ===== SHIPPING ADDRESS SECTION ===== -->
                <div class="checkout-section">
                    <h3 class="section-title">
                        <span class="material-symbols-outlined">local_shipping</span> Shipping Address
                    </h3>
                    
                    <p style="font-size: 13px; opacity: 0.7; margin-bottom: 20px; line-height: 1.5; text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; font-family: var(--font-body);">
                        Where should we deliver your premium selection?
                    </p>

                    <div class="form-row two-col">
                        <div class="form-group">
                            <label for="shipping_name">Full Name *</label>
                            <input type="text" id="shipping_name" placeholder="Recipient name" required value="${fn:escapeXml(user.name)}">
                        </div>
                        <div class="form-group">
                            <label for="shipping_phone">Phone Number *</label>
                            <input type="tel" id="shipping_phone" placeholder="10-digit mobile number" maxlength="10" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="shipping_address">Street Address *</label>
                        <input type="text" id="shipping_address" placeholder="House / Flat No., Street, Locality" required>
                    </div>

                    <div class="form-row two-col">
                        <div class="form-group">
                            <label for="shipping_city">City *</label>
                            <input type="text" id="shipping_city" placeholder="City" required>
                        </div>
                        <div class="form-group">
                            <label for="shipping_state">State *</label>
                            <input type="text" id="shipping_state" placeholder="State" required>
                        </div>
                    </div>

                    <div class="form-row two-col">
                        <div class="form-group">
                            <label for="shipping_pincode">PIN Code *</label>
                            <input type="text" id="shipping_pincode" placeholder="6-digit PIN code" maxlength="6" required>
                        </div>
                        <div class="form-group">
                            <!-- empty spacer for alignment -->
                        </div>
                    </div>

                    <div id="shippingError" style="display: none; background: rgba(186, 26, 26, 0.1); border: 1px solid var(--co-error); color: var(--co-error); padding: 12px; font-family: var(--font-body); font-weight: 600; text-transform: uppercase; font-size: 11px; letter-spacing: 0.5px; margin-top: 12px; display: inline-flex; align-items: center; gap: 6px;">
                        <span class="material-symbols-outlined" style="font-size: 16px;">warning</span> Please complete all shipping address fields.
                    </div>
                </div>

                <!-- ===== PAYMENT METHOD SECTION ===== -->
                <div class="checkout-section">
                    <h3 class="section-title">
                        <span class="material-symbols-outlined">payments</span> Payment Method
                    </h3>
                    
                    <p style="font-size: 13px; opacity: 0.7; margin-bottom: 20px; line-height: 1.5; text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; font-family: var(--font-body);">
                        Select how you would like to complete your premium acquisition.
                    </p>

                    <!-- PAYMENT METHOD SELECTOR -->
                    <div class="payment-options">
                        <label class="payment-option selected" id="opt-online">
                            <input type="radio" name="payment_method" value="online" checked style="display:none;">
                            <span class="material-symbols-outlined" style="font-size: 18px;">credit_card</span> Online Payment
                        </label>
                        <label class="payment-option" id="opt-cod">
                            <input type="radio" name="payment_method" value="cod" style="display:none;">
                            <span class="material-symbols-outlined" style="font-size: 18px;">payments</span> Cash on Delivery
                        </label>
                    </div>

                    <!-- PREFILLED BILLING SUMMARY -->
                    <div class="customer-info-box" style="background: var(--co-surface-container); border: 1px solid var(--co-outline-variant); padding: 20px; border-radius: var(--radius-default); margin-bottom: 24px; display: flex; flex-direction: column; gap: 12px;">
                        <h4 style="font-family: var(--font-body); font-size: 12px; font-weight: 500; letter-spacing: 0.05em; text-transform: uppercase; border-bottom: 1px dashed var(--co-outline-variant); padding-bottom: 8px; color: var(--co-primary); margin: 0;">Customer Information</h4>
                        <div class="customer-info-row" style="display: flex; justify-content: space-between; font-size: 13px; font-weight: 500; text-transform: uppercase;">
                            <span style="color: var(--co-on-surface-variant); opacity: 0.7;">Name</span>
                            <span style="color: var(--co-primary); font-weight: 600;"><c:out value="${user.name}" /></span>
                        </div>
                        <div class="customer-info-row" style="display: flex; justify-content: space-between; font-size: 13px; font-weight: 500;">
                            <span style="color: var(--co-on-surface-variant); opacity: 0.7; text-transform: uppercase;">Email</span>
                            <span style="color: var(--co-primary); font-weight: 600;"><c:out value="${user.email}" /></span>
                        </div>
                    </div>

                    <!-- ONLINE PAYMENT FLOW -->
                    <div id="onlinePaymentFlow">
                        <!-- PAYMENT BUTTON -->
                        <c:choose>
                            <c:when test="${not empty razorpayOrderId}">
                                <button type="button" id="payNowBtn" class="place-order-btn">
                                    <span class="material-symbols-outlined">lock</span> Pay Now — ₹<fmt:formatNumber value="${grandTotal}" maxFractionDigits="0"/>
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="place-order-btn" disabled>
                                    Online Checkout Unavailable
                                </button>
                            </c:otherwise>
                        </c:choose>
                        
                        <p class="secure-label">
                            <span class="material-symbols-outlined">verified_user</span> Secure 256-bit encrypted SSL checkout
                        </p>
                    </div>

                    <!-- COD PAYMENT FLOW -->
                    <div id="codPaymentFlow" style="display: none;">
                        <form id="codForm" action="${ctx}/checkout/cod" method="POST">
                            <input type="hidden" name="_csrf" value="${_csrf}" />
                            <input type="hidden" name="shipping_name" id="cod_shipping_name">
                            <input type="hidden" name="shipping_phone" id="cod_shipping_phone">
                            <input type="hidden" name="shipping_address" id="cod_shipping_address">
                            <input type="hidden" name="shipping_city" id="cod_shipping_city">
                            <input type="hidden" name="shipping_state" id="cod_shipping_state">
                            <input type="hidden" name="shipping_pincode" id="cod_shipping_pincode">
                            <button type="submit" class="place-order-btn">
                                <span class="material-symbols-outlined">local_shipping</span> Place Order (COD) — ₹<fmt:formatNumber value="${grandTotal}" maxFractionDigits="0"/>
                            </button>
                        </form>
                        
                        <p class="secure-label">
                            <span class="material-symbols-outlined">payments</span> Pay in cash upon product delivery
                        </p>
                    </div>

                </div>
            </div>

            <!-- ===== RIGHT: ORDER SUMMARY ===== -->
            <div class="checkout-summary">
                <h3 class="summary-heading">Order Summary</h3>

                <div class="summary-items">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="summary-item">
                            <img src="<c:choose><c:when test="${fn:startsWith(item.image, 'http')}">${item.image}</c:when><c:otherwise>${ctx}/assets/images/${item.image}</c:otherwise></c:choose>"
                                 onerror="this.src='${ctx}/assets/images/fallback.jpg'"
                                 alt="${item.productName}">
                            <div class="summary-item-info">
                                <p class="summary-item-name"><c:out value="${item.productName}" /></p>
                                <p class="summary-item-meta">Size: <c:out value="${item.size}" /> · Qty: ${item.quantity}</p>
                            </div>
                            <p class="summary-item-price">₹<fmt:formatNumber value="${item.price * item.quantity}" maxFractionDigits="0"/></p>
                        </div>
                    </c:forEach>
                </div>

                <div class="summary-divider"></div>

                <div class="summary-row">
                    <span>Subtotal</span>
                    <span>₹<fmt:formatNumber value="${subtotal}" maxFractionDigits="0"/></span>
                </div>

                <div class="summary-row">
                    <span>Shipping</span>
                    <span>
                        <c:choose>
                            <c:when test="${shipping == 0}">
                                <span class="free-badge">FREE</span>
                            </c:when>
                            <c:otherwise>
                                ₹<fmt:formatNumber value="${shipping}" maxFractionDigits="0"/>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="summary-divider"></div>

                <div class="summary-total-row">
                    <span>Total</span>
                    <span>₹<fmt:formatNumber value="${grandTotal}" maxFractionDigits="0"/></span>
                </div>
            </div>

        </div>

    </div>

    <!-- Footer -->
    <footer class="footer-section">
        <div class="footer-container">
            <div class="footer-brand-col">
                <div class="footer-logo">AURAWEAR</div>
                <p class="footer-desc">
                    PREMIUM STREETWEAR FOR THE BOLD. DEFINING THE AESTHETIC OF THE NEW ERA.
                </p>
                <div class="footer-socials">
                    <a href="#">INSTAGRAM</a>
                    <a href="#">TIKTOK</a>
                </div>
            </div>
            <div class="footer-links-col">
                <h5 class="footer-heading">SHOP</h5>
                <ul class="footer-links-list">
                    <li><a href="${ctx}/products?gender=Men">MEN</a></li>
                    <li><a href="${ctx}/products?gender=Women">WOMEN</a></li>
                    <li><a href="${ctx}/products?category=Accessories">ACCESSORIES</a></li>
                    <li><a href="${ctx}/collections">COLLECTIONS</a></li>
                </ul>
            </div>
            <div class="footer-links-col">
                <h5 class="footer-heading">ACCOUNT</h5>
                <ul class="footer-links-list">
                    <li><a href="${ctx}/profile">PROFILE</a></li>
                    <li><a href="${ctx}/my-orders">ORDERS</a></li>
                    <li><a href="${ctx}/wishlist">WISHLIST</a></li>
                    <li><a href="${ctx}/cart">CART</a></li>
                </ul>
            </div>
            <div class="footer-links-col">
                <h5 class="footer-heading">HELP</h5>
                <ul class="footer-links-list">
                    <li><a href="${ctx}/my-orders">SHIPPING &amp; RETURNS</a></li>
                    <li><a href="javascript:void(0)" onclick="openSizeGuide()">SIZE GUIDE</a></li>
                    <li><a href="mailto:support@aurawear.com">CONTACT</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom-row">
            <p class="footer-copyright">© 2025 AURAWEAR. ALL RIGHTS RESERVED.</p>
        </div>
    </footer>

    <!-- RAZORPAY SCRIPT -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <script>
    // Navbar scroll effect
    window.addEventListener("scroll", function () {
        const nav = document.querySelector(".navbar");
        if (nav) nav.classList.toggle("scrolled", window.scrollY > 80);
    });

    // --- Shipping validation helper ---
    function getShippingFields() {
        return {
            shipping_name:    document.getElementById("shipping_name").value.trim(),
            shipping_phone:   document.getElementById("shipping_phone").value.trim(),
            shipping_address: document.getElementById("shipping_address").value.trim(),
            shipping_city:    document.getElementById("shipping_city").value.trim(),
            shipping_state:   document.getElementById("shipping_state").value.trim(),
            shipping_pincode: document.getElementById("shipping_pincode").value.trim()
        };
    }

    function validateShipping() {
        const fields = getShippingFields();
        const errorDiv = document.getElementById("shippingError");
        
        // 1. Check empty fields
        for (const key in fields) {
            if (!fields[key]) {
                errorDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size: 16px;">warning</span> Please complete all shipping address fields.';
                errorDiv.style.display = "flex";
                errorDiv.scrollIntoView({ behavior: "smooth", block: "center" });
                return false;
            }
        }

        // 2. Validate Phone Number (must be exactly 10 digits)
        if (!/^\d{10}$/.test(fields.shipping_phone)) {
            errorDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size: 16px;">warning</span> Please enter a valid 10-digit mobile number.';
            errorDiv.style.display = "flex";
            document.getElementById("shipping_phone").scrollIntoView({ behavior: "smooth", block: "center" });
            return false;
        }

        // 3. Validate PIN Code (must be exactly 6 digits)
        if (!/^\d{6}$/.test(fields.shipping_pincode)) {
            errorDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size: 16px;">warning</span> Please enter a valid 6-digit PIN code.';
            errorDiv.style.display = "flex";
            document.getElementById("shipping_pincode").scrollIntoView({ behavior: "smooth", block: "center" });
            return false;
        }

        errorDiv.style.display = "none";
        return true;
    }

    // Dynamic numeric-only restrictions
    document.getElementById("shipping_phone").addEventListener("input", function() {
        this.value = this.value.replace(/\D/g, "");
    });

    document.getElementById("shipping_pincode").addEventListener("input", function() {
        this.value = this.value.replace(/\D/g, "");
    });

    // Hide shipping error when user starts typing
    document.querySelectorAll('#shipping_name, #shipping_phone, #shipping_address, #shipping_city, #shipping_state, #shipping_pincode').forEach(function(input) {
        input.addEventListener('input', function() {
            document.getElementById("shippingError").style.display = "none";
        });
    });

    // --- Toggle payment method flow ---
    const optOnline = document.getElementById("opt-online");
    const optCod = document.getElementById("opt-cod");
    const onlinePaymentFlow = document.getElementById("onlinePaymentFlow");
    const codPaymentFlow = document.getElementById("codPaymentFlow");

    if (optOnline && optCod) {
        const radios = document.getElementsByName("payment_method");
        
        function updatePaymentFlow() {
            let selectedMethod = "online";
            for (const radio of radios) {
                if (radio.checked) {
                    selectedMethod = radio.value;
                    break;
                }
            }
            
            if (selectedMethod === "online") {
                optOnline.classList.add("selected");
                optCod.classList.remove("selected");
                onlinePaymentFlow.style.display = "block";
                codPaymentFlow.style.display = "none";
            } else {
                optOnline.classList.remove("selected");
                optCod.classList.add("selected");
                onlinePaymentFlow.style.display = "none";
                codPaymentFlow.style.display = "block";
            }
        }

        optOnline.onclick = function() {
            optOnline.querySelector('input[type="radio"]').checked = true;
            updatePaymentFlow();
        };

        optCod.onclick = function() {
            optCod.querySelector('input[type="radio"]').checked = true;
            updatePaymentFlow();
        };
    }

    // --- COD: populate hidden fields and validate before submit ---
    const codForm = document.getElementById("codForm");
    if (codForm) {
        codForm.addEventListener("submit", function(e) {
            if (!validateShipping()) {
                e.preventDefault();
                return;
            }
            const fields = getShippingFields();
            document.getElementById("cod_shipping_name").value    = fields.shipping_name;
            document.getElementById("cod_shipping_phone").value   = fields.shipping_phone;
            document.getElementById("cod_shipping_address").value = fields.shipping_address;
            document.getElementById("cod_shipping_city").value    = fields.shipping_city;
            document.getElementById("cod_shipping_state").value   = fields.shipping_state;
            document.getElementById("cod_shipping_pincode").value = fields.shipping_pincode;
        });
    }

    // --- Razorpay Integration ---
    <c:if test="${not empty razorpayOrderId}">
    const payNowBtn = document.getElementById("payNowBtn");
    
    const options = {
        "key": "${razorpayKeyId}",
        "amount": "${amountInPaise}",
        "currency": "INR",
        "name": "AuraWear",
        "description": "Premium Streetwear Checkout",
        "order_id": "${razorpayOrderId}",
        "handler": function (response) {
            const form = document.createElement("form");
            form.method = "POST";
            form.action = "${ctx}/payment-success";

            // CSRF Token
            const csrfInp = document.createElement("input");
            csrfInp.type = "hidden"; csrfInp.name = "_csrf"; csrfInp.value = "${_csrf}";
            form.appendChild(csrfInp);

            // Payment credentials
            const pId = document.createElement("input");
            pId.type = "hidden"; pId.name = "razorpay_payment_id"; pId.value = response.razorpay_payment_id;
            form.appendChild(pId);

            const oId = document.createElement("input");
            oId.type = "hidden"; oId.name = "razorpay_order_id"; oId.value = response.razorpay_order_id;
            form.appendChild(oId);

            const sig = document.createElement("input");
            sig.type = "hidden"; sig.name = "razorpay_signature"; sig.value = response.razorpay_signature;
            form.appendChild(sig);

            // Append shipping fields
            const shipFields = getShippingFields();
            for (const key in shipFields) {
                const inp = document.createElement("input");
                inp.type = "hidden"; inp.name = key; inp.value = shipFields[key];
                form.appendChild(inp);
            }

            document.body.appendChild(form);
            form.submit();
        },
        "prefill": {
            "name": "${fn:escapeXml(user.name)}",
            "email": "${fn:escapeXml(user.email)}"
        },
        "theme": {
            "color": "#000000"
        }
    };

    const rzp = new Razorpay(options);
    
    payNowBtn.onclick = function(e) {
        e.preventDefault();
        if (!validateShipping()) return;
        rzp.open();
    };
    </c:if>
    </script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            if (typeof gtag === 'function') {
                gtag('event', 'begin_checkout', {
                    currency: 'INR',
                    value: parseFloat('${grandTotal}'),
                    items: [
                        <c:forEach var="item" items="${cartItems}" varStatus="status">
                        {
                            item_id: '${item.productId}',
                            item_name: '${item.productName}',
                            price: parseFloat('${item.price}'),
                            quantity: parseInt('${item.quantity}'),
                            item_size: '${item.size}'
                        }${not status.last ? ',' : ''}
                        </c:forEach>
                    ]
                });
            }
        });
    </script>

</body>
</html>
