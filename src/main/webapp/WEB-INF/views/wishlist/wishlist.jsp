<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
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
    <title>Your Wishlist - AuraWear</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/home.css?v=200">
    <link class="wishlist-style" rel="stylesheet" href="${ctx}/assets/css/wishlist.css?v=200">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
        }
    </style>
</head>
<body>

    <jsp:include page="../partials/navbar.jsp" />

    <div class="wishlist-page">

        <!-- HEADER -->
        <div class="wishlist-header">
            <h1>Your Wishlist</h1>
            <p class="wl-subtitle">
                <c:choose>
                    <c:when test="${not empty wishlist}">
                        <span id="headerCount">${wishlist.size()}</span> item<c:if test="${wishlist.size() != 1}">s</c:if> saved
                    </c:when>
                    <c:otherwise>Items you've saved for later</c:otherwise>
                </c:choose>
            </p>
        </div>

        <!-- CONTENT -->
        <div class="wishlist-container">
            <c:choose>

                <c:when test="${empty wishlist}">
                    <div class="wishlist-empty" id="emptyState">
                        <div class="wishlist-empty-icon">
                            <span class="material-symbols-outlined">favorite</span>
                        </div>
                        <h3>Your wishlist is empty</h3>
                        <p>Save items you love by tapping the heart on any product.<br>They'll appear here for easy access.</p>
                        <a href="${ctx}/products" class="wishlist-browse-btn">Browse Store</a>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="wishlist-grid" id="wishlistGrid">
                        <c:forEach var="item" items="${wishlist}">
                            <div class="wishlist-card" id="wcard-${item.productId}">

                                <!-- Product Image -->
                                <div class="wl-image-wrap"
                                     onclick="window.location.href='${ctx}/product?id=${item.productId}'">
                                    <c:choose>
                                        <c:when test="${not empty item.image}">
                                            <img src="<c:choose><c:when test="${fn:startsWith(item.image, 'http')}">${item.image}</c:when><c:otherwise>${ctx}/assets/images/${item.image}</c:otherwise></c:choose>"
                                                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex'"
                                                 alt="<c:out value="${item.productName}"/>"
                                                 loading="lazy">
                                            <div class="wl-img-fallback" style="display:none;">
                                                <span class="material-symbols-outlined" style="font-size: 40px; color: var(--wl-outline); opacity: 0.4;">checkroom</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="wl-img-fallback">
                                                <span class="material-symbols-outlined" style="font-size: 40px; color: var(--wl-outline); opacity: 0.4;">checkroom</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Heart Remove Button -->
                                <button class="wl-remove-btn"
                                        onclick="removeItem(event, ${item.productId}, '${fn:replace(fn:escapeXml(item.productName), "'", "\\'")}')"
                                        aria-label="Remove from wishlist"
                                        title="Remove from wishlist">
                                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1, 'wght' 400;">favorite</span>
                                </button>

                                <!-- Product Info -->
                                <div class="wl-info">
                                    <h3 class="wl-name"><c:out value="${item.productName}"/></h3>
                                    <p class="wl-category">AuraWear</p>
                                    <p class="wl-price">₹<fmt:formatNumber value="${item.price}" maxFractionDigits="0"/></p>
                                </div>

                                <!-- Add to Bag Button -->
                                <button class="wl-add-btn"
                                        onclick="addToCart(event, ${item.productId}, '${fn:replace(fn:escapeXml(item.size), "'", "\\'")}', ${item.price})"
                                        id="addBtn-${item.productId}">
                                    + Add to Bag
                                </button>

                            </div>
                        </c:forEach>

                        <!-- Empty Slot placeholder (visible on large screens) -->
                        <div class="wl-empty-slot" id="emptySlot">
                            <span class="material-symbols-outlined">add</span>
                            <p>Keep exploring to add more items</p>
                            <a href="${ctx}/products">Browse Store</a>
                        </div>
                    </div>

                    <!-- Bottom Strip -->
                    <div class="wishlist-strip">
                        <span id="wishlistCount">
                            <span class="material-symbols-outlined" style="font-size: 18px; margin-right: 6px; font-variation-settings: 'FILL' 0, 'wght' 400;">favorite</span>
                            ${wishlist.size()} saved item<c:if test="${wishlist.size() != 1}">s</c:if>
                        </span>
                        <a href="${ctx}/products" style="text-decoration: none; display: inline-flex; align-items: center; gap: 4px;">Shop more <span class="material-symbols-outlined" style="font-size: 16px;">arrow_right_alt</span></a>
                    </div>
                </c:otherwise>

            </c:choose>
        </div>

        <!-- YOU MAY ALSO LIKE -->
        <div class="wl-recommendations">
            <h2>You may also like</h2>
            <div class="wl-rec-chips">
                <a href="${ctx}/products?category=Outerwear" class="wl-rec-chip">MODULAR LAYERS</a>
                <a href="${ctx}/products?category=Accessories" class="wl-rec-chip">URBAN TECH</a>
                <a href="${ctx}/products?category=Knitwear" class="wl-rec-chip">ESSENTIAL KNITS</a>
                <a href="${ctx}/products?gender=Men" class="wl-rec-chip">MEN'S EDIT</a>
                <a href="${ctx}/products?gender=Women" class="wl-rec-chip">WOMEN'S EDIT</a>
            </div>
        </div>

    </div>
    <!-- end .wishlist-page -->

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

    <!-- Toast Notification -->
    <div id="toast" class="wl-toast"></div>

    <script>
    const ctx = "${ctx}";

    function removeItem(e, productId, productName) {
        e.stopPropagation();
        fetch(ctx + "/wishlist-toggle", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "X-CSRF-Token": window._csrf
            },
            body: "id=" + encodeURIComponent(productId),
            credentials: "include"
        })
        .then(res => {
            if (res.status === 401) { window.location.href = ctx + "/login"; return; }
            if (!res.ok) throw new Error();
            const card = document.getElementById("wcard-" + productId);
            if (card) {
                card.style.transition = "opacity 0.3s, transform 0.3s";
                card.style.opacity = "0";
                card.style.transform = "scale(0.95)";
                setTimeout(() => { card.remove(); refreshCount(); }, 300);
            }
            showToast(productName + " removed from wishlist");
        })
        .catch(() => showToast("Could not remove. Try again."));
    }

    function addToCart(e, productId, size, price) {
        e.stopPropagation();
        const btn = e.currentTarget;
        btn.disabled = true;
        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Adding...';

        fetch(ctx + "/add-to-cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "X-CSRF-Token": window._csrf
            },
            body: "id=" + encodeURIComponent(productId) + "&size=" + encodeURIComponent(size || "M") + "&price=" + encodeURIComponent(price),
            credentials: "include"
        })
        .then(res => {
            if (res.status === 401) { window.location.href = ctx + "/login"; return; }
            if (!res.ok) throw new Error();
            btn.innerHTML = '<i class="fa-solid fa-check"></i> Added!';
            btn.classList.add("added");
            showToast("Added to bag!");
            updateCartCount();
            
            if (typeof gtag === 'function') {
                const pName = btn.closest(".wishlist-card")?.querySelector(".wl-name")?.innerText || 'Product';
                gtag('event', 'add_to_cart', {
                    currency: 'INR',
                    value: parseFloat(price),
                    items: [{
                        item_id: productId.toString(),
                        item_name: pName,
                        price: parseFloat(price),
                        quantity: 1,
                        item_size: size || 'M'
                    }]
                });
            }
            
            setTimeout(() => {
                btn.disabled = false;
                btn.innerHTML = '+ Add to Bag';
                btn.classList.remove("added");
            }, 1800);
        })
        .catch(() => {
            btn.disabled = false;
            btn.innerHTML = '+ Add to Bag';
            showToast("Could not add to bag. Try again.");
        });
    }

    function updateCartCount() {
        fetch(ctx + "/cart-count", { credentials: "include" })
        .then(res => res.text())
        .then(count => {
            const el = document.getElementById("cart-count");
            if (el) el.innerText = count;
            document.querySelectorAll(".cart-badge").forEach(b => b.innerText = count);
        }).catch(() => {});
    }

    function refreshCount() {
        const count = document.querySelectorAll(".wishlist-card").length;
        const headerEl = document.getElementById("headerCount");
        if (headerEl) headerEl.textContent = count;

        const el = document.getElementById("wishlistCount");
        if (el) el.innerHTML = '<span class="material-symbols-outlined" style="font-size: 18px; margin-right: 6px; font-variation-settings: \'FILL\' 0, \'wght\' 400;">favorite</span>'
            + count + ' saved item' + (count !== 1 ? 's' : '');

        if (count === 0) {
            document.querySelector(".wishlist-container").innerHTML =
                '<div class="wishlist-empty">'
              +   '<div class="wishlist-empty-icon"><span class="material-symbols-outlined">favorite</span></div>'
              +   '<h3>Your wishlist is empty</h3>'
              +   '<p>Save items you love by tapping the heart on any product.</p>'
              +   '<a href="' + ctx + '/products" class="wishlist-browse-btn">Browse Store</a>'
              + '</div>';

            var subtitle = document.querySelector(".wishlist-header .wl-subtitle");
            if (subtitle) subtitle.textContent = "Items you've saved for later";
        }
    }

    function showToast(msg) {
        const toast = document.getElementById("toast");
        toast.innerText = msg;
        toast.classList.add("show");
        setTimeout(() => toast.classList.remove("show"), 2400);
    }

    window.addEventListener("scroll", function () {
        const nav = document.querySelector(".navbar");
        if (nav) nav.classList.toggle("scrolled", window.scrollY > 80);
    });
    </script>

</body>
</html>
