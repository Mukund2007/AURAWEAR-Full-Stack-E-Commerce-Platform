<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ page import="java.util.*, com.aurawear.model.CartItem" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%
    List<CartItem> cart = (List<CartItem>) request.getAttribute("cartItems");
    int total     = 0;
    int itemCount = 0;
    if (cart != null) {
        itemCount = cart.size();
        for (CartItem item : cart) {
            total += item.getPrice() * item.getQuantity();
        }
    }
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../partials/head-includes.jsp" />
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Bag — AuraWear</title>

    <link rel="stylesheet" href="${ctx}/assets/css/home.css?v=200">
    <link class="cart-style" rel="stylesheet" href="${ctx}/assets/css/cart3.css?v=200">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
        }
    </style>
</head>
<body>

    <jsp:include page="../partials/navbar.jsp" />

    <main class="cart-container-wrap">
        <h1 class="cart-title-main" id="cartTitle">
            <% if (itemCount == 0) { %>
                YOUR BAG (0)
            <% } else { %>
                Your Bag
            <% } %>
        </h1>
        <p class="cart-subtitle" id="cartSubtitle" <%= itemCount == 0 ? "style=\"display:none;\"" : "" %>><span id="headerCount"><span id="headerCountVal"><%= itemCount %></span></span> item<%= itemCount != 1 ? "s" : "" %></p>

        <section class="cart-page <%= (cart == null || cart.isEmpty()) ? "empty" : "" %>" id="cartPageSection">

            <!-- ===== LEFT COLUMN ===== -->
            <div class="cart-left">
                <% if (cart == null || cart.isEmpty()) { %>
                    <div class="empty-cart" id="emptyState">
                        <p class="sad-text">NOT EVEN ONE THING?<br>THAT'S SAD.</p>
                        <a href="${ctx}/products" class="go-shopping-link">GO SHOPPING &rarr;</a>
                    </div>
                <% } else { %>
                    <!-- Empty state placeholder inside list context for JS toggle -->
                    <div class="empty-cart" id="emptyState" style="display:none;">
                        <p class="sad-text">NOT EVEN ONE THING?<br>THAT'S SAD.</p>
                        <a href="${ctx}/products" class="go-shopping-link">GO SHOPPING &rarr;</a>
                    </div>
                    <div class="cart-items-list" id="cartItemsList">
                    <% 
                        for (CartItem item : cart) { 
                            String imgUrl = item.getImage();
                            if (imgUrl != null && !imgUrl.startsWith("http")) {
                                imgUrl = ctxPath + "/assets/images/" + imgUrl;
                            }
                    %>
                        <div class="cart-item" id="item-<%= item.getProductId() %>-<%= item.getSize() %>">
                            <div class="cart-item-image-wrap" onclick="window.location.href='${ctx}/product?id=<%= item.getProductId() %>'" style="cursor:pointer;">
                                <img src="<%= imgUrl %>"
                                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex'"
                                     alt="<%= item.getProductName() %>">
                                <div class="wl-img-fallback" style="display:none; width:100%; height:100%; align-items:center; justify-content:center; background:var(--surface-color);">
                                    <i class="fa-solid fa-shirt" style="font-size:24px; color:var(--secondary-text);"></i>
                                </div>
                            </div>

                            <div class="item-details">
                                <div class="item-header-row">
                                    <div class="item-title-meta">
                                        <h3 onclick="window.location.href='${ctx}/product?id=<%= item.getProductId() %>'" style="cursor:pointer;"><%= item.getProductName() %></h3>
                                        <p class="item-meta">Size: <%= item.getSize() %></p>
                                    </div>
                                    <span class="item-price" data-price="<%= item.getPrice() %>">
                                        ₹<%= item.getPrice() * item.getQuantity() %>
                                    </span>
                                </div>

                                <div class="item-actions-row">
                                    <div class="qty-controls">
                                        <button type="button" onclick="updateQty(this, <%= item.getProductId() %>, '<%= item.getSize() %>', -1)"
                                            <%= item.getQuantity() == 1 ? "disabled" : "" %> aria-label="Decrease quantity">
                                            <span class="material-symbols-outlined" style="font-size: 16px;">remove</span>
                                        </button>
                                        <span class="qty"><%= item.getQuantity() %></span>
                                        <button type="button" onclick="updateQty(this, <%= item.getProductId() %>, '<%= item.getSize() %>', 1)" aria-label="Increase quantity">
                                            <span class="material-symbols-outlined" style="font-size: 16px;">add</span>
                                        </button>
                                    </div>
                                    
                                    <button type="button" onclick="removeItem(event, <%= item.getProductId() %>, '<%= item.getSize() %>', '<%= item.getProductName().replace("'", "\\'") %>')"
                                       class="remove-item-btn">
                                        Remove
                                    </button>
                                </div>
                            </div>
                        </div>
                    <% } %>
                    </div>

                    <div class="continue-shopping-wrap" id="continueShoppingWrap">
                        <a href="${ctx}/products" class="continue-shopping-link">
                            <i class="fa-solid fa-arrow-left"></i>
                            <span>Continue Shopping</span>
                        </a>
                    </div>
                <% } %>
            </div>

            <!-- ===== RIGHT COLUMN: SUMMARY ===== -->
            <div class="cart-summary">
                <h2 class="summary-title">Order Summary</h2>

                <div class="summary-details">
                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span class="subtotal">₹<%= total %></span>
                    </div>

                    <div class="summary-row">
                        <span>Shipping</span>
                        <span class="shipping-value">
                            <% if (total >= com.aurawear.util.SettingsUtil.getFreeShippingThreshold()) { %>
                                <span class="free-badge">FREE</span>
                            <% } else { %>
                                ₹<%= com.aurawear.util.SettingsUtil.getShippingCharge() %>
                            <% } %>
                        </span>
                    </div>
                </div>

                <div class="summary-total">
                    <span>Total</span>
                    <span class="total">₹<%= total >= com.aurawear.util.SettingsUtil.getFreeShippingThreshold() ? total : total + com.aurawear.util.SettingsUtil.getShippingCharge() %></span>
                </div>

                <div class="coupon-box">
                    <label for="promo-input">Promo Code</label>
                    <div class="coupon-input-group">
                        <input type="text" id="promo-input" placeholder="Promo code">
                        <button type="button" class="apply-coupon-btn">Apply</button>
                    </div>
                </div>

                <a href="${ctx}/checkout" class="checkout-btn">
                    Checkout <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                </a>

                <div class="trust-badges">
                    <div class="trust-badge-item">
                        <span class="material-symbols-outlined" title="Secure Checkout">lock</span>
                    </div>
                    <div class="trust-badge-item">
                        <span class="material-symbols-outlined" title="Verified">verified_user</span>
                    </div>
                    <div class="trust-badge-item">
                        <span class="material-symbols-outlined" title="Carbon Neutral">eco</span>
                    </div>
                </div>
            </div>

        </section>

        <!-- ===== YOU MAY ALSO LIKE ===== -->
        <section class="home-products-section" style="margin-top: 120px; border-top: 1px solid var(--cart-outline-variant); padding-top: 80px;">
            <h2 class="section-title" style="font-family: var(--font-body); font-size: 32px; font-weight: 500; text-align: center; margin-bottom: 48px; letter-spacing: -0.01em;">You May Also Like</h2>
            <div class="products-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 32px; max-width: 1200px; margin: 0 auto;">
                <!-- Product 1 -->
                <div class="product-card" onclick="window.location.href='${ctx}/product?id=6'" style="cursor:pointer; display:flex; flex-direction:column; gap:16px;">
                    <div class="product-image-wrapper" style="position:relative; width:100%; aspect-ratio:4/5; background:var(--cart-surface-low); overflow:hidden;">
                        <img src="${ctx}/assets/images/track-jacket.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'" alt="Classic Tracksuit" style="width:100%; height:100%; object-fit:cover; transition:transform 0.6s cubic-bezier(0.16, 1, 0.3, 1);">
                    </div>
                    <div class="product-info" style="display:flex; flex-direction:column; gap:4px;">
                        <h3 style="font-family: var(--font-body); font-size: 16px; font-weight: 500; color: var(--cart-primary);">Classic Tracksuit</h3>
                        <p style="font-family: var(--font-body); font-size: 14px; font-weight: 600; color: var(--cart-primary);">₹2,499</p>
                    </div>
                </div>
                <!-- Product 2 -->
                <div class="product-card" onclick="window.location.href='${ctx}/product?id=1'" style="cursor:pointer; display:flex; flex-direction:column; gap:16px;">
                    <div class="product-image-wrapper" style="position:relative; width:100%; aspect-ratio:4/5; background:var(--cart-surface-low); overflow:hidden;">
                        <img src="${ctx}/assets/images/sneak-alpha.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'" alt="Classic Sneaker White" style="width:100%; height:100%; object-fit:cover; transition:transform 0.6s cubic-bezier(0.16, 1, 0.3, 1);">
                    </div>
                    <div class="product-info" style="display:flex; flex-direction:column; gap:4px;">
                        <h3 style="font-family: var(--font-body); font-size: 16px; font-weight: 500; color: var(--cart-primary);">Classic Sneaker White</h3>
                        <p style="font-family: var(--font-body); font-size: 14px; font-weight: 600; color: var(--cart-primary);">₹2,999</p>
                    </div>
                </div>
                <!-- Product 3 -->
                <div class="product-card" onclick="window.location.href='${ctx}/product?id=3'" style="cursor:pointer; display:flex; flex-direction:column; gap:16px;">
                    <div class="product-image-wrapper" style="position:relative; width:100%; aspect-ratio:4/5; background:var(--cart-surface-low); overflow:hidden;">
                        <img src="${ctx}/assets/images/beanie-v2.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'" alt="Leather Cap" style="width:100%; height:100%; object-fit:cover; transition:transform 0.6s cubic-bezier(0.16, 1, 0.3, 1);">
                    </div>
                    <div class="product-info" style="display:flex; flex-direction:column; gap:4px;">
                        <h3 style="font-family: var(--font-body); font-size: 16px; font-weight: 500; color: var(--cart-primary);">Leather Cap</h3>
                        <p style="font-family: var(--font-body); font-size: 14px; font-weight: 600; color: var(--cart-primary);">₹799</p>
                    </div>
                </div>
            </div>
        </section>
    </main>

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

    <!-- Toast Notification -->
    <div id="toast" class="wl-toast" style="position:fixed; bottom:32px; right:32px; background:var(--cart-primary); color:var(--cart-on-primary); padding:16px 24px; border-radius:var(--radius-default); font-size:14px; font-weight:500; box-shadow:0 10px 30px rgba(0,0,0,0.1); transform:translateY(100px); opacity:0; transition:all 0.3s cubic-bezier(0.16, 1, 0.3, 1); z-index:9999;"></div>

    <script>
    const ctxPath = "<%= ctxPath %>";

    function updateQty(btn, id, size, change) {
        const controls  = btn.parentElement;
        const minusBtn  = controls.querySelector("button:first-child");
        const plusBtn   = controls.querySelector("button:last-child");
        
        minusBtn.disabled = true;
        plusBtn.disabled = true;

        fetch(ctxPath + "/update-cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "X-CSRF-Token": window._csrf
            },
            body: "id=" + encodeURIComponent(id) + "&size=" + encodeURIComponent(size) + "&change=" + encodeURIComponent(change)
        })
        .then(res => res.json())
        .then(data => {
            const qtySpan   = controls.querySelector(".qty");
            qtySpan.innerText    = data.quantity;
            minusBtn.disabled    = data.quantity <= 1;
            plusBtn.disabled     = false;

            const itemDiv  = btn.closest(".cart-item");
            const priceTag = itemDiv.querySelector(".item-price");
            const basePrice = parseInt(priceTag.dataset.price);
            priceTag.innerText = "₹" + (basePrice * data.quantity);

            updateSummary();
            updateNavbarCartCount();
        })
        .catch(err => {
            console.error("Cart update error:", err);
            minusBtn.disabled = false;
            plusBtn.disabled = false;
        });
    }

    function removeItem(e, id, size, name) {
        e.stopPropagation();
        const itemDiv = document.getElementById("item-" + id + "-" + size);
        if (!itemDiv) return;

        itemDiv.style.opacity = "0";
        itemDiv.style.transform = "scale(0.95)";

        fetch(ctxPath + "/remove-from-cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "X-CSRF-Token": window._csrf
            },
            body: "id=" + encodeURIComponent(id) + "&size=" + encodeURIComponent(size)
        })
        .then(res => {
            if (!res.ok) throw new Error();
            setTimeout(() => {
                itemDiv.remove();
                
                const remaining = document.querySelectorAll(".cart-item").length;
                const headerCountVal = document.getElementById("headerCountVal");
                if (headerCountVal) {
                    headerCountVal.innerText = remaining;
                } else {
                    const headerCount = document.getElementById("headerCount");
                    if (headerCount) headerCount.innerText = remaining;
                }

                updateSummary();
                updateNavbarCartCount();
                showToast(name + " removed from bag");

                if (remaining === 0) {
                    const listDiv = document.getElementById("cartItemsList");
                    if (listDiv) listDiv.remove();
                    const shopWrap = document.getElementById("continueShoppingWrap");
                    if (shopWrap) shopWrap.remove();
                    const summaryDiv = document.querySelector(".cart-summary");
                    if (summaryDiv) summaryDiv.remove();

                    const cartPageSec = document.getElementById("cartPageSection");
                    if (cartPageSec) cartPageSec.classList.add("empty");

                    const cartTitle = document.getElementById("cartTitle");
                    if (cartTitle) cartTitle.innerText = "YOUR BAG (0)";

                    const cartSubtitle = document.getElementById("cartSubtitle");
                    if (cartSubtitle) cartSubtitle.style.display = "none";

                    const emptyState = document.getElementById("emptyState");
                    if (emptyState) emptyState.style.display = "block";
                }
            }, 300);
        })
        .catch(err => {
            console.error("Remove item error:", err);
            itemDiv.style.opacity = "1";
            itemDiv.style.transform = "none";
            showToast("Could not remove item. Try again.");
        });
    }

    function updateSummary() {
        let subtotal = 0;
        document.querySelectorAll(".item-price").forEach(el => {
            subtotal += parseInt(el.innerText.replace("₹", "").trim());
        });

        document.querySelector(".subtotal").innerText = "₹" + subtotal;

        const freeThreshold = <%= com.aurawear.util.SettingsUtil.getFreeShippingThreshold() %>;
        const charge = <%= com.aurawear.util.SettingsUtil.getShippingCharge() %>;
        const freeShipping = subtotal >= freeThreshold;
        document.querySelector(".total").innerText = "₹" + (subtotal === 0 ? 0 : (freeShipping ? subtotal : subtotal + charge));

        // Update shipping badge
        const shippingEl = document.querySelector(".shipping-value");
        if (shippingEl) {
            shippingEl.innerHTML = subtotal === 0 
                ? "₹0" 
                : (freeShipping ? '<span class="free-badge">FREE</span>' : '₹' + charge);
        }
    }

    function updateNavbarCartCount() {
        fetch(ctxPath + "/cart-count", { credentials: "include" })
        .then(res => res.text())
        .then(count => {
            const el = document.getElementById("cart-count");
            if (el) el.innerText = count;
        });
    }

    function showToast(msg) {
        const toast = document.getElementById("toast");
        toast.innerText = msg;
        toast.style.transform = "translateY(0)";
        toast.style.opacity = "1";
        setTimeout(() => {
            toast.style.transform = "translateY(100px)";
            toast.style.opacity = "0";
        }, 2400);
    }

    window.addEventListener('scroll', function () {
        const nav = document.querySelector('.navbar');
        if (nav) nav.classList.toggle('scrolled', window.scrollY > 80);
    });
    </script>
    <c:if test="${sessionScope.justAddedToCart}">
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                if (typeof gtag === 'function') {
                    gtag('event', 'add_to_cart', {
                        currency: 'INR',
                        value: parseFloat('${sessionScope.addedPrice}'),
                        items: [{
                            item_id: '${sessionScope.addedProduct.id}',
                            item_name: '${sessionScope.addedProduct.name}',
                            price: parseFloat('${sessionScope.addedPrice}'),
                            quantity: 1,
                            item_size: '${sessionScope.addedSize}'
                        }]
                    });
                }
            });
        </script>
        <%
            session.removeAttribute("justAddedToCart");
            session.removeAttribute("addedProduct");
            session.removeAttribute("addedSize");
            session.removeAttribute("addedPrice");
        %>
    </c:if>

    </body>
</html>
