<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../partials/head-includes.jsp" />
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curated Collections — AuraWear</title>
    <meta name="description" content="Explore AuraWear's curated fashion drops. Premium technical garments engineered for longevity, versatility, and the modern architectural form.">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/home.css?v=200">
    <link rel="stylesheet" href="${ctx}/assets/css/collections.css?v=200">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body>

    <jsp:include page="../partials/navbar.jsp" />

    <!-- ══ HEADER ════════════════════════════════════════════ -->
    <section class="col-header">
        <div class="reveal">
            <h1 class="col-header-title">Collections</h1>
            <p class="col-header-desc">
                A curated study of technical garments engineered for longevity, versatility, and the modern architectural form.
            </p>
        </div>
    </section>

    <!-- ══ COLLECTION 01 — THE ESSENTIALS ═══════════════════ -->
    <section class="col-section" id="essentials">
        <div class="col-container">
            <div class="col-col-half reveal">
                <div class="col-images-grid-2">
                    <div class="col-img-wrapper">
                        <img src="${ctx}/assets/images/linen-overshirt.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'" alt="The Essentials — Linen Overshirt">
                    </div>
                    <div class="col-img-wrapper col-img-offset">
                        <img src="${ctx}/assets/images/base-mock.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'" alt="The Essentials — Ribbed Long Sleeve">
                    </div>
                </div>
            </div>
            <div class="col-col-half reveal">
                <div class="col-tags">
                    <span class="col-tag">CORE</span>
                    <span class="col-tag">MONOCHROME</span>
                </div>
                <h2 class="col-title">The Essentials</h2>
                <p class="col-desc">
                    The foundation of the technical wardrobe. Designed with structural integrity and minimal silhouettes, these pieces provide the core framework for any variable environment. Longevity in every fiber.
                </p>
                <a class="col-btn" href="${ctx}/products?category=Tops">
                    SHOP COLLECTION
                </a>
            </div>
        </div>
    </section>

    <!-- ══ COLLECTION 02 — MODULAR LAYERING ═════════════════ -->
    <section class="col-section col-section-alt" id="layering">
        <div class="col-container">
            <div class="col-col-half reveal">
                <div class="col-tags">
                    <span class="col-tag">TECHNICAL</span>
                    <span class="col-tag">STRUCTURED</span>
                </div>
                <h2 class="col-title">Modular Layering</h2>
                <p class="col-desc">
                    An exploration of architectural layering. Our technical mid-layers and shell jackets are engineered to interface seamlessly, creating a responsive protective system that adapts to both climate and context.
                </p>
                <a class="col-btn col-btn--outline" href="${ctx}/products?category=Outerwear">
                    SHOP COLLECTION
                </a>
            </div>
            <div class="col-col-half reveal">
                <div class="col-images-composite">
                    <div class="col-img-composite-main">
                        <img src="${ctx}/assets/images/tech-windbreaker.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'" alt="Modular Layering — Classic Windbreaker">
                    </div>
                    <div class="col-img-composite-stack">
                        <div class="col-img-composite-sub">
                            <img src="${ctx}/assets/images/utility-vest.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'" alt="Modular Layering — Quilted Vest">
                        </div>
                        <div class="col-img-composite-sub">
                            <img src="${ctx}/assets/images/feature-drop-new.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'" alt="Modular Layering — Puffer Vest">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ══ COLLECTION 03 — SOFT SCULPTURES ══════════════════ -->
    <section class="col-section" id="sculptures">
        <div class="col-container">
            <div class="col-col-half reveal">
                <div class="col-images-relative">
                    <div class="col-img-square">
                        <img src="${ctx}/assets/images/track-jacket.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'" alt="Soft Sculptures — Classic Tracksuit">
                    </div>
                    <div class="col-img-overlapping">
                        <img src="${ctx}/assets/images/knit-coord.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'" alt="Soft Sculptures — Knit Co-ord Set">
                    </div>
                </div>
            </div>
            <div class="col-col-half reveal">
                <div class="col-tags">
                    <span class="col-tag">OVERSIZED</span>
                    <span class="col-tag">TEXTURAL</span>
                </div>
                <h2 class="col-title">Soft Sculptures</h2>
                <p class="col-desc">
                    Where comfort meets rigid form. This collection explores the intersection of soft-touch materials with structured silhouettes, creating garments that hold their shape while respecting the fluid movement of the wearer.
                </p>
                <a class="col-btn" href="${ctx}/products?category=Sets">
                    SHOP COLLECTION
                </a>
            </div>
        </div>
    </section>

    <!-- ══ TRUST SIGNALS ════════════════════════════════════ -->
    <section class="col-trust-section">
        <div class="col-trust-container">
            <div class="col-trust-item reveal">
                <span class="material-symbols-outlined">local_shipping</span>
                <span class="col-trust-text">Global Logistics</span>
            </div>
            <div class="col-trust-item reveal">
                <span class="material-symbols-outlined">verified_user</span>
                <span class="col-trust-text">Lifetime Warranty</span>
            </div>
            <div class="col-trust-item reveal">
                <span class="material-symbols-outlined">eco</span>
                <span class="col-trust-text">Regenerative Textiles</span>
            </div>
            <div class="col-trust-item reveal">
                <span class="material-symbols-outlined">architecture</span>
                <span class="col-trust-text">Precision Engineering</span>
            </div>
        </div>
    </section>

    <!-- ══ FOOTER ═══════════════════════════════════════════ -->
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

    <script>
        // Reveal elements on scroll
        function reveal() {
            const reveals = document.querySelectorAll(".reveal");
            const windowHeight = window.innerHeight;
            const elementVisible = 100;
            reveals.forEach(el => {
                const elementTop = el.getBoundingClientRect().top;
                if (elementTop < windowHeight - elementVisible) {
                    el.classList.add("active");
                }
            });
        }

        window.addEventListener("scroll", reveal);
        // Initial execution
        reveal();
    </script>
</body>
</html>