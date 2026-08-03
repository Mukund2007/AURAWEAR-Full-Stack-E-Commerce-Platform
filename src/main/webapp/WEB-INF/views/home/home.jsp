<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Cache bust: v300 --%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../partials/head-includes.jsp" />
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>AuraWear - High-End Minimalist Apparel</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/home.css?v=300">
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
        }
        /* Toast notification styling */
        #aw-toast {
            position: fixed;
            bottom: 40px;
            right: 40px;
            background: var(--primary-brand);
            color: var(--bg-color);
            padding: 16px 28px;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 2px;
            z-index: 99999;
            text-transform: uppercase;
            box-shadow: 6px 6px 0px var(--secondary-brand);
            border: 2px solid var(--border-color);
            transform: translateY(20px);
            opacity: 0;
            pointer-events: none;
            transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
        }
        #aw-toast.show {
            transform: translateY(0);
            opacity: 1;
            pointer-events: auto;
        }
        
        /* Wishlist button active state */
        .wishlist-btn.active span {
            font-variation-settings: 'FILL' 1 !important;
            color: var(--error-color) !important;
        }
    </style>
</head>
<body>
    <c:set var="isHome" value="true" scope="request" />
    <jsp:include page="../partials/navbar.jsp" />

    <main class="main-content">
        <!-- Hero Section -->
        <section class="hero-section">
            <video autoplay loop muted playsinline class="hero-bg-video">
                <source src="${ctx}/assets/images/hero-main.webm?v=1.0.0" type="video/webm">
            </video>
            <div class="hero-content">
                <span class="hero-eyebrow">Premium Streetwear</span>
                <h1 class="hero-title">AURA</h1>
                <p class="hero-subtitle">AUTUMN / WINTER 2026</p>
                <div class="hero-buttons">
                    <a class="btn btn-primary" href="${ctx}/products">DISCOVER COLLECTION</a>
                    <a class="btn btn-secondary" href="${ctx}/collections">VIEW LOOKBOOK</a>
                </div>
            </div>
        </section>

        <!-- Brand Philosophy Section -->
        <section class="brand-ethos-section">
            <div class="brand-ethos-inner">
                <span class="brand-ethos-eyebrow">Ethos</span>
                <h2 class="brand-ethos-heading">
                    Architectural Wardrobes designed with Technical Purity.
                </h2>
                <div class="brand-ethos-divider"></div>
                <p class="brand-ethos-body">
                    We believe clothing is the primary architecture of the human experience. Our focus remains on textile clarity and essential geometric forms.
                </p>
            </div>
        </section>

        <!-- Material Innovation Highlight -->
        <section class="innovation-section">
            <div class="innovation-image-wrap">
                <img alt="Macro fabric texture" class="innovation-image" src="${ctx}/assets/images/innovation-macro.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'"/>
            </div>
            <div class="innovation-content">
                <span class="innovation-eyebrow">Innovation</span>
                <h3 class="innovation-heading">V-01 Technical Weave</h3>
                <p class="innovation-body">
                    Our signature V-01 Technical Weave utilizes high-density organic polymers cross-stitched for maximum structural integrity without compromising weight. The result is a fabric that maintains its silhouette while adapting to atmospheric moisture and body heat.
                </p>
                <div class="innovation-specs">
                    <div>
                        <p class="spec-label">Weight</p>
                        <p class="spec-value">240 GSM / Ultra-light</p>
                    </div>
                    <div>
                        <p class="spec-label">Breathability</p>
                        <p class="spec-value">15,000 g/m²/24h</p>
                    </div>
                    <div>
                        <p class="spec-label">Composition</p>
                        <p class="spec-value">82% Organic, 18% Polymer</p>
                    </div>
                    <div>
                        <p class="spec-label">Treatment</p>
                        <p class="spec-value">PFC-Free DWR</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Category Grid -->
        <section class="category-section">
            <div class="category-grid">
                <a class="category-tile" href="${ctx}/products?gender=Men">
                    <img alt="Men's Collection" class="category-img" src="${ctx}/assets/images/category-men.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'"/>
                    <div class="category-overlay"><span class="category-label">Men</span></div>
                </a>
                <a class="category-tile" href="${ctx}/products?gender=Women">
                    <img alt="Women's Collection" class="category-img" src="${ctx}/assets/images/category-women.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'"/>
                    <div class="category-overlay"><span class="category-label">Women</span></div>
                </a>
                <a class="category-tile" href="${ctx}/products?category=Footwear">
                    <img alt="Footwear" class="category-img" src="${ctx}/assets/images/category-footwear.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'"/>
                    <div class="category-overlay"><span class="category-label">Footwear</span></div>
                </a>
                <a class="category-tile" href="${ctx}/products?category=Accessories">
                    <img alt="Accessories" class="category-img" src="${ctx}/assets/images/category-accessories.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'"/>
                    <div class="category-overlay"><span class="category-label">Accessories</span></div>
                </a>
            </div>
        </section>

        <!-- Dynamic Studio Selection Products -->
        <section class="products-section">
            <div class="section-header">
                <div>
                    <span class="section-eyebrow">Archive</span>
                    <h2 class="section-heading">Studio Selection 01</h2>
                </div>
                <a class="section-link" href="${ctx}/products">View Archive</a>
            </div>
            
            <div class="products-grid">
                <c:choose>
                    <c:when test="${empty products}">
                        <div class="empty-state">
                            No products available in the archive. Check back soon.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${products}">
                            <div class="product-card ${p.stockQuantity == 0 ? 'out-of-stock' : ''}" onclick="goToProduct('${p.id}')">
                                <div class="product-image-container">
                                    <img class="product-image" 
                                         src="<c:choose><c:when test="${fn:startsWith(p.image, 'http')}">${p.image}</c:when><c:otherwise>${ctx}/assets/images/${p.image}</c:otherwise></c:choose>"
                                         onerror="this.src='${ctx}/assets/images/fallback.jpg'"
                                         alt="${p.name}">
                                    
                                    <c:choose>
                                        <c:when test="${p.stockQuantity == 0}">
                                            <div class="product-badge badge-oos">OUT OF STOCK</div>
                                        </c:when>
                                        <c:when test="${p.stockQuantity <= 5}">
                                            <div class="product-badge badge-low-stock">ONLY ${p.stockQuantity} LEFT</div>
                                        </c:when>
                                    </c:choose>

                                    <button class="wishlist-btn ${not empty wishlistNames and wishlistNames.contains(p.id) ? 'active' : ''}"
                                            data-id="${p.id}"
                                            onclick="toggleWishlist(event, this)">
                                        <span class="material-symbols-outlined" style="${not empty wishlistNames and wishlistNames.contains(p.id) ? 'font-variation-settings: \'FILL\' 1;' : ''}">favorite</span>
                                    </button>
                                    
                                    <button class="add-to-bag-btn ${p.stockQuantity == 0 ? 'disabled' : ''}" 
                                            data-id="${p.id}" 
                                            data-size="M" 
                                            data-price="${p.price}" 
                                            onclick="quickAdd(event)"
                                            ${p.stockQuantity == 0 ? 'disabled' : ''}>
                                        ${p.stockQuantity == 0 ? 'OUT OF STOCK' : '+ ADD TO BAG'}
                                    </button>
                                </div>
                                <div class="product-info-row">
                                    <div class="product-info-left">
                                        <h3 class="product-name">${p.name}</h3>
                                        <p class="product-category">${p.category}</p>
                                    </div>
                                    <div class="product-info-right">
                                        <p class="product-price">&#8377;<fmt:formatNumber value="${p.price}" maxFractionDigits="0"/></p>
                                        <c:if test="${p.discount > 0}">
                                            <p class="product-original-price">&#8377;<fmt:formatNumber value="${p.originalPrice}" maxFractionDigits="0"/></p>
                                            <span class="discount-badge">${p.discount}% OFF</span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- Trust Signals -->
        <section class="trust-badges-section">
            <div class="trust-badges-container">
                <span class="trust-badge-item">Complimentary Global Shipping</span>
                <span class="trust-badge-dot"></span>
                <span class="trust-badge-item">90-Day Returns</span>
                <span class="trust-badge-dot"></span>
                <span class="trust-badge-item">Secured Checkout</span>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="footer-section">
        <div class="footer-container">
            <div class="footer-brand-col">
                <div class="footer-logo">AuraWear</div>
                <p class="footer-desc">
                    High-end minimalist apparel designed with organic precision. We focus on textile clarity and essential silhouettes for the modern wardrobe.
                </p>
                <p class="footer-copyright">
                    &copy; 2025 AuraWear. All rights reserved.
                </p>
            </div>
            <div class="footer-links-col">
                <h5 class="footer-heading">Explore</h5>
                <ul class="footer-links-list">
                    <li><a href="${ctx}/products">Shop All</a></li>
                    <li><a href="${ctx}/products?gender=Men">New Arrivals</a></li>
                    <li><a href="${ctx}/products?category=Accessories">Essentials</a></li>
                    <li><a href="${ctx}/collections">Collections</a></li>
                </ul>
            </div>
            <div class="footer-links-col">
                <h5 class="footer-heading">Support</h5>
                <ul class="footer-links-list">
                    <li><a href="mailto:support@aurawear.com">Contact</a></li>
                    <li><a href="${ctx}/my-orders">Shipping &amp; Returns</a></li>
                    <li><a href="javascript:void(0)" onclick="openSizeGuide()">Size Guide</a></li>
                </ul>
            </div>
        </div>
    </footer>

    <!-- TOAST -->
    <div id="aw-toast"></div>

    <script>
    const ctx = "${ctx}";

    function goToProduct(id) {
        window.location.href = ctx + "/product?id=" + id;
    }

    function toggleWishlist(e, el) {
        e.stopPropagation();
        const id = el.getAttribute("data-id");
        fetch(ctx + "/wishlist-toggle", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "X-CSRF-Token": window._csrf
            },
            body: "id=" + encodeURIComponent(id),
            credentials: "include"
        })
        .then(res => {
            if (res.status === 401) { window.location.href = ctx + "/login"; return; }
            if (!res.ok) throw new Error("Server error");
            return res.text();
        })
        .then(status => {
            if (!status) return;
            const icon = el.querySelector("span");
            if (status.trim() === "added") {
                el.classList.add("active");
                if (icon) { icon.style.fontVariationSettings = "'FILL' 1"; }
                showToast("Added to wishlist ♡");
            } else {
                el.classList.remove("active");
                if (icon) { icon.style.fontVariationSettings = "'FILL' 0"; }
                showToast("Removed from wishlist");
            }
        })
        .catch(() => {
            showToast("Could not update wishlist. Try again.");
        });
    }

    function quickAdd(e) {
        e.stopPropagation();
        const btn = e.currentTarget;
        const id = btn.getAttribute("data-id");
        const size = btn.getAttribute("data-size");
        const price = btn.getAttribute("data-price");
        const pName = btn.closest(".product-card")?.querySelector("h3")?.innerText || 'Product';
        btn.disabled = true;
        btn.innerText = "Adding...";
        fetch(ctx + "/add-to-cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "X-CSRF-Token": window._csrf
            },
            body: "id=" + encodeURIComponent(id) + "&size=" + encodeURIComponent(size || "M") + "&price=" + encodeURIComponent(price),
            credentials: "include"
        })
        .then(res => {
            if (res.status === 401) { window.location.href = ctx + "/login"; return; }
            if (!res.ok) throw new Error();
            return res.json();
        })
        .then(data => {
            if (!data) return;
            if (data.success) {
                btn.innerText = "Added ✓";
                showToast("Added to bag!");
                updateCartCount();
                if (typeof gtag === 'function') {
                    gtag('event', 'add_to_cart', {
                        currency: 'INR',
                        value: parseFloat(price),
                        items: [{
                            item_id: id,
                            item_name: pName,
                            price: parseFloat(price),
                            quantity: 1,
                            item_size: size || 'M'
                        }]
                    });
                }
            } else {
                btn.innerText = "OUT OF STOCK";
                showToast(data.message || "Out of stock!");
            }
            setTimeout(() => {
                btn.disabled = !data.success;
                btn.innerText = data.success ? "+ ADD TO BAG" : "OUT OF STOCK";
            }, 1600);
        })
        .catch(() => {
            btn.disabled = false;
            btn.innerText = "+ ADD TO BAG";
        });
    }

    function updateCartCount() {
        fetch(ctx + "/cart-count", { credentials: "include" })
            .then(r => r.text())
            .then(c => { 
                const el = document.getElementById("cart-count"); 
                if (el) el.innerText = c; 
                document.querySelectorAll(".cart-badge").forEach(b => b.innerText = c);
            })
            .catch(() => {});
    }

    // Parallax effect on hero image
    window.addEventListener('scroll', () => {
        const scrolled = window.pageYOffset;
        const heroImg = document.querySelector('.hero-bg-img');
        if (heroImg) {
            heroImg.style.transform = `translateY(${scrolled * 0.05}px)`;
        }
    });

    function showToast(msg) {
        const t = document.getElementById("aw-toast");
        t.innerText = msg;
        t.classList.add("show");
        setTimeout(() => t.classList.remove("show"), 2800);
    }
    window.showToast = showToast;

    document.addEventListener("DOMContentLoaded", updateCartCount);
    </script>
    <script src="${ctx}/assets/js/app-interactions.js?v=11"></script>
</body>
</html>
