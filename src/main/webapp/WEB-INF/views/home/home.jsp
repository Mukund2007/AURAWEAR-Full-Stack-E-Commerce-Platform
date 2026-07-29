<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Cache bust: v200 --%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html class="scroll-smooth" lang="en">
<head>
    <jsp:include page="../partials/head-includes.jsp" />
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>AuraWear - High-End Minimalist Apparel</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script id="tailwind-config">
        tailwind.config = {
          theme: {
            extend: {
              "colors": {
                      "surface": "#f5f5f5",             /* Neutral 50 */
                      "background": "#ffffff",          /* Pure White */
                      "primary": "#000000",             /* Pure Black */
                      "secondary": "#262626",           /* Neutral 800 */
                      "accent": "#000000",              /* Black — no separate accent */
                      "accent-light": "#404040",        /* Neutral 700 */
                      "on-surface": "#000000",          /* Primary Text */
                      "on-background": "#000000",
                      "on-primary": "#ffffff",
                      "on-secondary": "#ffffff",
                      "outline": "#e5e5e5",             /* Neutral 200 */
                      "outline-variant": "#e5e5e5",
                      "error": "#dc2626",               /* Red 600 */
                      "success": "#16a34a",             /* Green 600 */
                      "surface-container-low": "#f5f5f5",
                      "surface-container-high": "#e5e5e5",
                      "surface-container-highest": "#d4d4d4"
              },
              "borderRadius": {
                      "DEFAULT": "0px",
                      "lg": "0px",
                      "xl": "0px",
                      "full": "999px"
              },
              "spacing": {
                      "margin-desktop": "80px",
                      "container-max": "1440px",
                      "gutter": "24px",
                      "stack-lg": "32px",
                      "section-gap-mobile": "64px",
                      "section-gap": "160px",
                      "margin-mobile": "20px",
                      "stack-sm": "8px",
                      "stack-md": "16px"
              },
              "fontFamily": {
                      "headline-md": ["DM Sans", "sans-serif"],
                      "headline-sm": ["DM Sans", "sans-serif"],
                      "display-lg-mobile": ["DM Sans", "sans-serif"],
                      "label-md": ["DM Sans", "sans-serif"],
                      "label-caps": ["DM Sans", "sans-serif"],
                      "display-lg": ["DM Sans", "sans-serif"],
                      "body-md": ["DM Sans", "sans-serif"],
                      "body-lg": ["DM Sans", "sans-serif"],
              },
              "fontSize": {
                      "headline-md": ["32px", {"lineHeight": "1.3", "letterSpacing": "-0.01em", "fontWeight": "400"}],
                      "headline-sm": ["24px", {"lineHeight": "1.4", "fontWeight": "400"}],
                      "display-lg-mobile": ["40px", {"lineHeight": "1.2", "letterSpacing": "-0.01em", "fontWeight": "500"}],
                      "label-md": ["14px", {"lineHeight": "1.4", "fontWeight": "500"}],
                      "label-caps": ["12px", {"lineHeight": "1.0", "letterSpacing": "0.08em", "fontWeight": "600"}],
                      "display-lg": ["64px", {"lineHeight": "1.1", "letterSpacing": "-0.02em", "fontWeight": "500"}],
                      "body-md": ["16px", {"lineHeight": "1.6", "fontWeight": "400"}],
                      "body-lg": ["18px", {"lineHeight": "1.6", "fontWeight": "400"}]
              }
            },
          },
        }
    </script>
    <style>
        body {
            background-color: theme('colors.background');
            color: theme('colors.on-surface');
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
        }
        /* Soft slow transitions for editorial feel */
        a, button, img {
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
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
<body class="min-h-screen flex flex-col bg-background">
    <c:set var="isHome" value="true" scope="request" />
    <jsp:include page="../partials/navbar.jsp" />

    <main class="flex-grow">
        <!-- Hero Section -->
        <section class="relative w-full h-[90vh] flex items-center justify-center overflow-hidden bg-black">
            <video autoplay loop muted playsinline class="absolute inset-0 w-full h-full object-cover object-center z-0 scale-105 hero-bg-video">
                <source src="${ctx}/assets/images/hero-main.webm?v=1.0.0" type="video/webm">
            </video>
            <div class="relative z-20 text-center px-margin-mobile flex flex-col items-center select-none">
                <span class="font-sans text-xs font-semibold tracking-[0.25em] uppercase mb-6 text-white/90" style="text-shadow: 0 2px 10px rgba(0,0,0,0.6);">Premium Streetwear</span>
                <h1 class="text-white font-light tracking-[-0.05em] mb-8 leading-[1.05] text-center" style="font-family: 'Cormorant Garamond', serif; font-size: clamp(48px, 8vw, 88px); font-weight: 400; text-shadow: 0 4px 20px rgba(0,0,0,0.5);">
                    AURA
                </h1>
                <p class="font-sans text-white/90 text-xs sm:text-sm md:text-base tracking-[0.45em] uppercase mb-12 font-light" style="text-shadow: 0 2px 10px rgba(0,0,0,0.6);">
                    AUTUMN / WINTER 2026
                </p>
                <div class="flex gap-4 flex-wrap justify-center">
                    <a class="inline-flex items-center justify-center px-10 py-4 border border-white text-black font-sans text-xs md:text-sm tracking-[0.15em] uppercase rounded-none bg-white hover:bg-neutral-200 transition-all duration-300 shadow-md hover:-translate-y-0.5" href="${ctx}/products">
                        DISCOVER COLLECTION
                    </a>
                    <a class="inline-flex items-center justify-center px-10 py-4 border border-white text-white font-sans text-xs md:text-sm tracking-[0.15em] uppercase rounded-none bg-transparent hover:bg-white/20 backdrop-blur-sm transition-all duration-300" href="${ctx}/collections">
                        VIEW LOOKBOOK
                    </a>
                </div>
            </div>
        </section>

        <!-- Brand Philosophy Section -->
        <section class="py-section-gap px-margin-mobile md:px-margin-desktop bg-surface-container-low">
            <div class="max-w-4xl mx-auto text-center space-y-stack-md">
                <span class="font-label-caps text-label-caps text-on-surface-variant tracking-[0.2em] uppercase">Ethos</span>
                <h2 class="font-display-lg-mobile md:text-[48px] md:leading-[1.2] text-primary">
                    Architectural Wardrobes designed with Technical Purity.
                </h2>
                <div class="w-12 h-[1px] bg-outline-variant mx-auto my-stack-lg"></div>
                <p class="font-body-lg text-on-surface-variant max-w-2xl mx-auto leading-relaxed">
                    We believe clothing is the primary architecture of the human experience. Our focus remains on textile clarity and essential geometric forms.
                </p>
            </div>
        </section>

        <!-- Material Innovation Highlight -->
        <section class="grid grid-cols-1 md:grid-cols-2 min-h-[700px]">
            <div class="bg-surface-container-highest overflow-hidden">
                <img alt="Macro fabric texture" class="w-full h-full object-cover hover:scale-110 duration-[2000ms]" src="${ctx}/assets/images/innovation-macro.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'"/>
            </div>
            <div class="flex flex-col justify-center p-margin-mobile md:p-32 bg-background">
                <span class="font-label-caps text-label-caps text-on-surface-variant tracking-[0.2em] uppercase mb-stack-md">Innovation</span>
                <h3 class="font-headline-md text-headline-md mb-stack-lg">V-01 Technical Weave</h3>
                <p class="font-body-md text-on-surface-variant leading-relaxed mb-12">
                    Our signature V-01 Technical Weave utilizes high-density organic polymers cross-stitched for maximum structural integrity without compromising weight. The result is a fabric that maintains its silhouette while adapting to atmospheric moisture and body heat.
                </p>
                <div class="grid grid-cols-2 gap-8 border-t border-outline-variant pt-8">
                    <div>
                        <p class="font-mono text-[10px] uppercase text-on-surface-variant mb-1">Weight</p>
                        <p class="font-mono text-xs text-primary">240 GSM / Ultra-light</p>
                    </div>
                    <div>
                        <p class="font-mono text-[10px] uppercase text-on-surface-variant mb-1">Breathability</p>
                        <p class="font-mono text-xs text-primary">15,000 g/m²/24h</p>
                    </div>
                    <div>
                        <p class="font-mono text-[10px] uppercase text-on-surface-variant mb-1">Composition</p>
                        <p class="font-mono text-xs text-primary">82% Organic, 18% Polymer</p>
                    </div>
                    <div>
                        <p class="font-mono text-[10px] uppercase text-on-surface-variant mb-1">Treatment</p>
                        <p class="font-mono text-xs text-primary">PFC-Free DWR</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Category Grid -->
        <section class="py-section-gap px-margin-mobile md:px-margin-desktop max-w-container-max mx-auto">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-gutter">
                <a class="group relative aspect-[3/4] overflow-hidden bg-surface-container-low rounded-none shadow-sm hover:shadow-md hover:-translate-y-1 transition-all duration-300" href="${ctx}/products?gender=Men">
                    <img alt="Men's Collection" class="w-full h-full object-cover group-hover:scale-105" src="${ctx}/assets/images/category-men.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'"/>
                    <div class="absolute inset-0 flex items-end p-6" style="background: linear-gradient(180deg, rgba(0, 0, 0, 0.1) 0%, rgba(0, 0, 0, 0.4) 100%);"><span class="font-label-caps text-label-caps text-white uppercase tracking-widest font-semibold" style="text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);">Men</span></div>
                </a>
                <a class="group relative aspect-[3/4] overflow-hidden bg-surface-container-low rounded-none shadow-sm hover:shadow-md hover:-translate-y-1 transition-all duration-300" href="${ctx}/products?gender=Women">
                    <img alt="Women's Collection" class="w-full h-full object-cover group-hover:scale-105" src="${ctx}/assets/images/category-women.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'"/>
                    <div class="absolute inset-0 flex items-end p-6" style="background: linear-gradient(180deg, rgba(0, 0, 0, 0.1) 0%, rgba(0, 0, 0, 0.4) 100%);"><span class="font-label-caps text-label-caps text-white uppercase tracking-widest font-semibold" style="text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);">Women</span></div>
                </a>
                <a class="group relative aspect-[3/4] overflow-hidden bg-surface-container-low rounded-none shadow-sm hover:shadow-md hover:-translate-y-1 transition-all duration-300" href="${ctx}/products?category=Footwear">
                    <img alt="Footwear" class="w-full h-full object-cover group-hover:scale-105" src="${ctx}/assets/images/category-footwear.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'"/>
                    <div class="absolute inset-0 flex items-end p-6" style="background: linear-gradient(180deg, rgba(0, 0, 0, 0.1) 0%, rgba(0, 0, 0, 0.4) 100%);"><span class="font-label-caps text-label-caps text-white uppercase tracking-widest font-semibold" style="text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);">Footwear</span></div>
                </a>
                <a class="group relative aspect-[3/4] overflow-hidden bg-surface-container-low rounded-none shadow-sm hover:shadow-md hover:-translate-y-1 transition-all duration-300" href="${ctx}/products?category=Accessories">
                    <img alt="Accessories" class="w-full h-full object-cover group-hover:scale-105" src="${ctx}/assets/images/category-accessories.jpg" onerror="this.src='${ctx}/assets/images/fallback.jpg'"/>
                    <div class="absolute inset-0 flex items-end p-6" style="background: linear-gradient(180deg, rgba(0, 0, 0, 0.1) 0%, rgba(0, 0, 0, 0.4) 100%);"><span class="font-label-caps text-label-caps text-white uppercase tracking-widest font-semibold" style="text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);">Accessories</span></div>
                </a>
            </div>
        </section>

        <!-- Dynamic Studio Selection Products -->
        <section class="py-section-gap px-margin-mobile md:px-margin-desktop max-w-container-max mx-auto border-t border-outline-variant">
            <div class="flex flex-col md:flex-row justify-between items-end mb-stack-lg gap-gutter">
                <div>
                    <span class="font-label-caps text-label-caps text-on-surface-variant tracking-[0.2em] uppercase mb-stack-sm block">Archive</span>
                    <h2 class="font-headline-md text-headline-md">Studio Selection 01</h2>
                </div>
                <a class="font-label-caps text-label-caps border-b border-primary pb-1 hover:opacity-60" href="${ctx}/products">View Archive</a>
            </div>
            
            <div class="grid grid-cols-2 md:grid-cols-4 gap-gutter">
                <c:choose>
                    <c:when test="${empty products}">
                        <div class="col-span-2 md:col-span-4 text-center py-16 text-on-surface-variant/80 font-body-md tracking-wide">
                            No products available in the archive. Check back soon.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${products}">
                            <div class="group cursor-pointer flex flex-col ${p.stockQuantity == 0 ? 'opacity-70' : ''}" onclick="goToProduct('${p.id}')">
                                <div class="aspect-[3/4] mb-stack-md bg-surface-container-low overflow-hidden relative">
                                    <img class="w-full h-full object-cover group-hover:scale-105" 
                                         src="<c:choose><c:when test="${fn:startsWith(p.image, 'http')}">${p.image}</c:when><c:otherwise>${ctx}/assets/images/${p.image}</c:otherwise></c:choose>"
                                         onerror="this.src='${ctx}/assets/images/fallback.jpg'"
                                         alt="${p.name}">
                                    
                                    <c:choose>
                                        <c:when test="${p.stockQuantity == 0}">
                                            <div class="absolute top-4 left-4 bg-primary text-on-primary text-[10px] font-mono tracking-widest px-2 py-1 uppercase">OUT OF STOCK</div>
                                        </c:when>
                                        <c:when test="${p.stockQuantity <= 5}">
                                            <div class="absolute top-4 left-4 bg-error text-on-error text-[10px] font-mono tracking-widest px-2 py-1 uppercase">ONLY ${p.stockQuantity} LEFT</div>
                                        </c:when>
                                    </c:choose>

                                    <button class="absolute top-4 right-4 bg-background/80 hover:bg-background text-primary w-8 h-8 rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity z-20 wishlist-btn ${not empty wishlistNames and wishlistNames.contains(p.id) ? 'active' : ''}"
                                            data-id="${p.id}"
                                            onclick="toggleWishlist(event, this)">
                                        <span class="material-symbols-outlined" style="${not empty wishlistNames and wishlistNames.contains(p.id) ? 'font-variation-settings: \'FILL\' 1;' : ''}">favorite</span>
                                    </button>
                                    
                                    <button class="absolute bottom-0 left-0 right-0 bg-primary text-on-primary font-label-md py-3 text-center opacity-0 translate-y-2 group-hover:opacity-100 group-hover:translate-y-0 transition-all z-20 add-to-bag-btn ${p.stockQuantity == 0 ? 'disabled' : ''}" 
                                            data-id="${p.id}" 
                                            data-size="M" 
                                            data-price="${p.price}" 
                                            onclick="quickAdd(event)"
                                            ${p.stockQuantity == 0 ? 'disabled' : ''}>
                                        ${p.stockQuantity == 0 ? 'OUT OF STOCK' : '+ ADD TO BAG'}
                                    </button>
                                </div>
                                <div class="flex justify-between items-start mt-2">
                                    <div>
                                        <h3 class="font-body-md text-primary group-hover:underline">${p.name}</h3>
                                        <p class="font-label-md text-on-surface-variant">${p.category}</p>
                                    </div>
                                    <div class="text-right">
                                        <p class="font-label-md text-primary font-medium">₹<fmt:formatNumber value="${p.price}" maxFractionDigits="0"/></p>
                                        <c:if test="${p.discount > 0}">
                                            <p class="text-on-surface-variant line-through text-[11px] mt-0.5">₹<fmt:formatNumber value="${p.originalPrice}" maxFractionDigits="0"/></p>
                                            <span class="inline-block bg-error/10 text-error text-[10px] font-mono tracking-widest px-1.5 py-0.5 rounded mt-0.5 font-bold">${p.discount}% OFF</span>
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
        <section class="py-stack-lg border-t border-outline-variant px-margin-mobile md:px-margin-desktop bg-surface-bright">
            <div class="max-w-container-max mx-auto flex flex-col md:flex-row justify-center items-center gap-8 md:gap-16">
                <span class="font-label-caps text-label-caps text-on-surface-variant uppercase tracking-widest">Complimentary Global Shipping</span>
                <span class="hidden md:block w-1 h-1 bg-outline-variant rounded-full"></span>
                <span class="font-label-caps text-label-caps text-on-surface-variant uppercase tracking-widest">90-Day Returns</span>
                <span class="hidden md:block w-1 h-1 bg-outline-variant rounded-full"></span>
                <span class="font-label-caps text-label-caps text-on-surface-variant uppercase tracking-widest">Secured Checkout</span>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="bg-primary w-full py-section-gap-mobile md:py-32 border-t border-outline-variant">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-gutter px-margin-mobile md:px-margin-desktop max-w-container-max mx-auto">
            <div class="flex flex-col gap-stack-md col-span-1 md:col-span-2 pr-0 md:pr-12">
                <h4 class="font-headline-sm text-headline-sm font-medium text-white" style="font-family: 'Cormorant Garamond', serif; font-size: 28px; font-weight: 500; letter-spacing: -0.04em;">AuraWear</h4>
                <p class="font-body-md text-body-md text-white/80 max-w-md leading-relaxed">
                    High-end minimalist apparel designed with organic precision. We focus on textile clarity and essential silhouettes for the modern wardrobe.
                </p>
                <p class="font-label-md text-label-md text-white/60 mt-stack-lg">
                    © 2025 AuraWear. All rights reserved.
                </p>
            </div>
            <div class="flex flex-col gap-stack-md mt-stack-lg md:mt-0">
                <h5 class="font-label-caps text-label-caps text-accent uppercase mb-2 font-semibold tracking-wider">Explore</h5>
                <a class="font-body-md text-body-md text-white/80 hover:text-accent transition-colors" href="${ctx}/products">Shop All</a>
                <a class="font-body-md text-body-md text-white/80 hover:text-accent transition-colors" href="${ctx}/products?gender=Men">New Arrivals</a>
                <a class="font-body-md text-body-md text-white/80 hover:text-accent transition-colors" href="${ctx}/products?category=Accessories">Essentials</a>
                <a class="font-body-md text-body-md text-white/80 hover:text-accent transition-colors" href="${ctx}/collections">Collections</a>
            </div>
            <div class="flex flex-col gap-stack-md mt-stack-lg md:mt-0">
                <h5 class="font-label-caps text-label-caps text-accent uppercase mb-2 font-semibold tracking-wider">Support</h5>
                <a class="font-body-md text-body-md text-white/80 hover:text-accent transition-colors" href="mailto:support@aurawear.com">Contact</a>
                <a class="font-body-md text-body-md text-white/80 hover:text-accent transition-colors" href="${ctx}/my-orders">Shipping &amp; Returns</a>
                <a class="font-body-md text-body-md text-white/80 hover:text-accent transition-colors" href="javascript:void(0)" onclick="openSizeGuide()">Size Guide</a>
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
        const pName = btn.closest(".group").querySelector("h3")?.innerText || 'Product';
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
