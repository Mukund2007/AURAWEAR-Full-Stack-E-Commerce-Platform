<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="partials/head-includes.jsp" />
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${product.name}" /> — AuraWear</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/home.css?v=200">
    <link rel="stylesheet" href="${ctx}/assets/css/product-details.css?v=200">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body>

    <jsp:include page="partials/navbar.jsp" />

    <div class="details-wrap">

        <!-- BREADCRUMB -->
        <div class="breadcrumb">
            <a href="${ctx}/home">Home</a>
            <span class="breadcrumb-sep"><span class="material-symbols-outlined">chevron_right</span></span>
            <a href="${ctx}/products?category=<c:out value="${product.category}"/>"><c:out value="${product.category}"/></a>
            <span class="breadcrumb-sep"><span class="material-symbols-outlined">chevron_right</span></span>
            <span class="breadcrumb-active"><c:out value="${product.name}"/></span>
        </div>

        <div class="details-container">

            <!-- LEFT: IMAGE -->
            <div class="image-section">
                <img src="<c:choose><c:when test="${fn:startsWith(product.image, 'http')}">${product.image}</c:when><c:otherwise>${ctx}/assets/images/${product.image}</c:otherwise></c:choose>"
                     onerror="this.src='${ctx}/assets/images/fallback.jpg'"
                     alt="<c:out value="${product.name}"/>">
            </div>

            <!-- RIGHT: INFO -->
            <div class="info-section">
                <div class="product-category"><c:out value="${product.category}"/></div>
                <h1><c:out value="${product.name}"/></h1>

                <!-- RATING -->
                <div class="rating-row">
                    <c:choose>
                        <c:when test="${reviewsCount > 0}">
                            <span class="stars" style="display: inline-flex; align-items: center; gap: 2px;">
                                <c:forEach begin="1" end="${averageFullStars}">
                                    <span class="material-symbols-outlined" style="font-size: 14px; font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24; color: var(--pd-primary);">star</span>
                                </c:forEach>
                                <c:if test="${averageHalfStar}">
                                    <span class="material-symbols-outlined" style="font-size: 14px; font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24; color: var(--pd-primary);">star_half</span>
                                </c:if>
                                <c:forEach begin="1" end="${5 - averageFullStars - (averageHalfStar ? 1 : 0)}">
                                    <span class="material-symbols-outlined" style="font-size: 14px; font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; color: var(--pd-outline-variant);">star</span>
                                </c:forEach>
                            </span>
                            <span class="rating-value"><fmt:formatNumber value="${averageRating}" minFractionDigits="1" maxFractionDigits="1"/></span>
                            <span class="reviews-count">(${reviewsCount} review<c:if test="${reviewsCount != 1}">s</c:if>)</span>
                        </c:when>
                        <c:otherwise>
                            <span class="reviews-count">No reviews yet</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- PRICE ROW -->
                <div class="price-row">
                    <span class="price">₹<fmt:formatNumber value="${product.price}" maxFractionDigits="0"/></span>
                    <c:if test="${product.discount > 0}">
                        <span class="original-price">₹<fmt:formatNumber value="${product.originalPrice}" maxFractionDigits="0"/></span>
                        <span class="discount-badge">${product.discount}% OFF</span>
                    </c:if>
                </div>

                <div class="divider"></div>

                <!-- SIZE SELECTOR -->
                <c:choose>
                    <c:when test="${product.category eq 'Footwear'}">
                        <c:set var="availSizes" value="${fn:split('UK5,UK6,UK7,UK8,UK9,UK10', ',')}" />
                    </c:when>
                    <c:when test="${product.category eq 'Accessories'}">
                        <c:set var="availSizes" value="${fn:split('Free', ',')}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="availSizes" value="${fn:split('XS,S,M,L,XL', ',')}" />
                    </c:otherwise>
                </c:choose>

                <div>
                    <div class="size-selector-header">
                        <div class="size-label">SELECT SIZE</div>
                        <button type="button" class="size-guide-link" onclick="openSizeGuide()">Size Guide</button>
                    </div>
                     <div class="sizes">
                          <c:forEach var="sz" items="${availSizes}">
                              <button type="button" class="size-btn" data-size="${sz}" ${product.stockQuantity == 0 ? 'disabled' : ''}>${sz}</button>
                          </c:forEach>
                      </div>
                </div>

                <!-- COLOR INFO -->
                <div>
                    <div class="color-label-row">
                        <span class="color-title">Color:</span>
                        <span class="color-value"><c:out value="${product.color}"/></span>
                    </div>
                    <c:set var="colorLower" value="${fn:toLowerCase(product.color)}" />
                    <c:choose>
                        <c:when test="${colorLower eq 'sage'}"><c:set var="colorHex" value="#718063" /></c:when>
                        <c:when test="${colorLower eq 'off-white' or colorLower eq 'off white'}"><c:set var="colorHex" value="#f3efe0" /></c:when>
                        <c:when test="${colorLower eq 'charcoal'}"><c:set var="colorHex" value="#36454f" /></c:when>
                        <c:when test="${colorLower eq 'jet black' or colorLower eq 'black'}"><c:set var="colorHex" value="#000000" /></c:when>
                        <c:when test="${colorLower eq 'sand'}"><c:set var="colorHex" value="#d8cbb5" /></c:when>
                        <c:when test="${colorLower eq 'taupe'}"><c:set var="colorHex" value="#b38b6d" /></c:when>
                        <c:when test="${colorLower eq 'cream'}"><c:set var="colorHex" value="#fffdd0" /></c:when>
                        <c:when test="${colorLower eq 'olive'}"><c:set var="colorHex" value="#556b2f" /></c:when>
                        <c:when test="${colorLower eq 'white'}"><c:set var="colorHex" value="#ffffff" /></c:when>
                        <c:otherwise><c:set var="colorHex" value="${colorLower}" /></c:otherwise>
                    </c:choose>
                    <div class="colors" style="margin-top: 12px;">
                        <span class="color-dot active" style="background-color: <c:out value="${colorHex}"/>; border: 1px solid var(--pd-outline-variant);" title="<c:out value="${product.color}"/>"></span>
                    </div>
                </div>

                <!-- ACTION BUTTONS -->
                <div class="action-buttons">
                     <!-- ADD TO CART FORM (POST to /cart) or Out of Stock banner -->
                     <c:choose>
                          <c:when test="${product.stockQuantity == 0}">
                              <div class="oos-banner">Out of Stock</div>
                          </c:when>
                          <c:otherwise>
                              <c:if test="${product.stockQuantity <= 5}">
                                  <div class="limited-stock-warning">
                                      Only ${product.stockQuantity} left
                                  </div>
                              </c:if>
                              <form id="addToCartForm" action="${ctx}/cart" method="POST">
                                  <input type="hidden" name="_csrf" value="${_csrf}" />
                                  <input type="hidden" name="productId" value="${product.id}">
                                  <input type="hidden" name="price" value="${product.price}">
                                  <input type="hidden" name="size" id="selectedSizeInput" value="">
                                  <button type="submit" class="add-btn">Add to Cart</button>
                              </form>
                          </c:otherwise>
                     </c:choose>

                    <!-- WISHLIST BUTTON -->
                    <button class="pd-wishlist-btn ${isWishlisted ? 'wishlisted' : ''}" id="wishlistBtn"
                            onclick="toggleWishlist(${product.id}, this)">
                        <i class="${isWishlisted ? 'fa-solid' : 'fa-regular'} fa-heart"></i>
                        ${isWishlisted ? 'Wishlisted' : 'Add to Wishlist'}
                    </button>
                </div>

                <!-- DYNAMIC DESCRIPTION SECTION -->
                <div class="product-description-block">
                    <p class="description-text">
                        <c:choose>
                            <c:when test="${product.category eq 'Footwear'}">
                                A masterclass in ergonomic and technical design. This curation features a sculptural sole unit engineered for everyday resilience and modern proportions. Serving as a grounded foundation for the minimalist look.
                            </c:when>
                            <c:when test="${product.category eq 'Accessories'}">
                                A minimalist accompaniment designed for utility and aesthetic longevity. Engineered with tight fabric weaving and durable hardware, it complements the daily uniform with quiet distinction.
                            </c:when>
                            <c:otherwise>
                                A masterclass in technical precision and silhouette drape. Engineered from high-density premium materials, it offers wind resistance, thermal regulation, and structural integrity for the architectural wardrobe.
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <ul class="highlights-list">
                        <li class="highlight-item">
                            <span class="material-symbols-outlined highlight-icon">verified</span>
                            <span>Sustainably sourced premium fabrics</span>
                        </li>
                        <li class="highlight-item">
                            <span class="material-symbols-outlined highlight-icon">package_2</span>
                            <span>Complimentary shipping on orders above ₹999</span>
                        </li>
                    </ul>
                </div>

            </div>
            <!-- end .info-section -->

        </div>
        <!-- end .details-container -->

        <!-- DETAILS, FABRIC, CARE ACCORDION SECTION -->
        <section class="specs-section">
            <div class="specs-grid">
                <c:choose>
                    <c:when test="${product.category eq 'Footwear'}">
                        <div class="specs-col">
                            <h3 class="specs-title">DETAILS</h3>
                            <p class="specs-text">High-density outsole, custom traction pattern, breathable construction, premium eyelets, and reinforced support.</p>
                            <div class="specs-mini-list">
                                <div class="specs-mini-item"><span>Brand</span><strong><c:out value="${product.brand}" /></strong></div>
                                <div class="specs-mini-item"><span>Type</span><strong><c:out value="${product.type}" /></strong></div>
                                <div class="specs-mini-item"><span>Color</span><strong><c:out value="${product.color}" /></strong></div>
                                <div class="specs-mini-item"><span>Gender</span><strong><c:out value="${product.gender}" /></strong></div>
                            </div>
                        </div>
                        <div class="specs-col">
                            <h3 class="specs-title">FABRIC</h3>
                            <p class="specs-text">Upper: 100% Technical Knit / Leather. Midsole: Ortholite cushioned. Outsole: Durable vulcanized rubber.</p>
                        </div>
                        <div class="specs-col">
                            <h3 class="specs-title">CARE</h3>
                            <p class="specs-text">Wipe with a damp cloth or soft brush. Avoid full submersion in water. Do not machine wash.</p>
                        </div>
                    </c:when>
                    <c:when test="${product.category eq 'Accessories'}">
                        <div class="specs-col">
                            <h3 class="specs-title">DETAILS</h3>
                            <p class="specs-text">Compact profile, reinforced stitching, subtle branding, and high-durability metallic hardware.</p>
                            <div class="specs-mini-list">
                                <div class="specs-mini-item"><span>Brand</span><strong><c:out value="${product.brand}" /></strong></div>
                                <div class="specs-mini-item"><span>Type</span><strong><c:out value="${product.type}" /></strong></div>
                                <div class="specs-mini-item"><span>Color</span><strong><c:out value="${product.color}" /></strong></div>
                                <div class="specs-mini-item"><span>Gender</span><strong><c:out value="${product.gender}" /></strong></div>
                            </div>
                        </div>
                        <div class="specs-col">
                            <h3 class="specs-title">FABRIC</h3>
                            <p class="specs-text">100% Premium Organic Cotton / Heavy-weight Merino Wool Blend. High durability fibers.</p>
                        </div>
                        <div class="specs-col">
                            <h3 class="specs-title">CARE</h3>
                            <p class="specs-text">Hand wash cold. Dry flat in shade. Do not tumble dry. Iron on low heat if needed.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="specs-col">
                            <h3 class="specs-title">DETAILS</h3>
                            <p class="specs-text">Water-repellent finish, internal utility pockets, YKK Aquaguard zippers, and reinforced articulated seams.</p>
                            <div class="specs-mini-list">
                                <div class="specs-mini-item"><span>Brand</span><strong><c:out value="${product.brand}" /></strong></div>
                                <div class="specs-mini-item"><span>Type</span><strong><c:out value="${product.type}" /></strong></div>
                                <div class="specs-mini-item"><span>Color</span><strong><c:out value="${product.color}" /></strong></div>
                                <div class="specs-mini-item"><span>Gender</span><strong><c:out value="${product.gender}" /></strong></div>
                            </div>
                        </div>
                        <div class="specs-col">
                            <h3 class="specs-title">FABRIC</h3>
                            <p class="specs-text">Outer: 100% Recycled Technical Polyester. Lining: Lightweight breathable mesh. Origin: Shizuoka, Japan.</p>
                        </div>
                        <div class="specs-col">
                            <h3 class="specs-title">CARE</h3>
                            <p class="specs-text">Professional dry clean only. Store on a wide-shouldered hanger to maintain sculptural integrity.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- PRODUCT REVIEWS SECTION -->
        <div class="reviews-section">
            <h2 class="reviews-title">Customer Reviews</h2>
            
            <!-- review success/error messages -->
            <c:if test="${not empty param.reviewError}">
                <div class="error-banner" style="background: rgba(140, 59, 59, 0.1); border: 1.5px solid var(--error-color); color: var(--error-color); padding: 16px; font-family: var(--font-body); font-weight: 600; text-transform: uppercase; font-size: 12px; margin-bottom: 24px; letter-spacing: 0.5px; display: inline-flex; align-items: center; gap: 8px;">
                    <span class="material-symbols-outlined" style="font-size: 18px;">warning</span> <c:out value="${param.reviewError}" />
                </div>
            </c:if>
            <c:if test="${not empty param.reviewSuccess}">
                <div class="success-banner" style="background: rgba(91, 115, 88, 0.1); border: 1.5px solid var(--success-color); color: var(--success-color); padding: 16px; font-family: var(--font-body); font-weight: 600; text-transform: uppercase; font-size: 12px; margin-bottom: 24px; letter-spacing: 0.5px; display: inline-flex; align-items: center; gap: 8px;">
                    <span class="material-symbols-outlined" style="font-size: 18px;">check_circle</span> <c:out value="${param.reviewSuccess}" />
                </div>
            </c:if>

            <div class="reviews-container">
                
                <!-- LEFT: Reviews List -->
                <div class="reviews-list">
                    <c:choose>
                        <c:when test="${empty reviews}">
                            <div class="review-info-box" style="text-align: center; width: 100%;">
                                No reviews yet — be the first to review!
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="rev" items="${reviews}">
                                <div class="review-card">
                                    <div class="review-header">
                                        <div class="review-user-row">
                                            <span class="review-user"><c:out value="${rev.userName}" /></span>
                                            <span class="verified-badge">
                                                <span class="material-symbols-outlined" style="font-size: 14px; font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24; color: var(--success-color);">verified</span>
                                                Verified Purchase
                                            </span>
                                        </div>
                                        <span class="review-date">
                                            <fmt:formatDate value="${rev.createdAt}" pattern="yyyy-MM-dd" />
                                        </span>
                                    </div>
                                    <div class="review-stars" style="display: inline-flex; align-items: center; gap: 2px;">
                                        <c:forEach begin="1" end="${rev.rating}">
                                            <span class="material-symbols-outlined" style="font-size: 12px; font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24; color: var(--pd-primary);">star</span>
                                        </c:forEach>
                                        <c:forEach begin="1" end="${5 - rev.rating}">
                                            <span class="material-symbols-outlined" style="font-size: 12px; font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; color: var(--pd-outline-variant);">star</span>
                                        </c:forEach>
                                    </div>
                                    <p class="review-text"><c:out value="${rev.reviewText}" /></p>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- RIGHT: Write Review Form (Verified Purchase Only) -->
                <div>
                    <c:choose>
                        <c:when test="${hasPurchased}">
                            <c:choose>
                                <c:when test="${hasAlreadyReviewed}">
                                    <div class="review-info-box">
                                        You've already reviewed this product.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="review-form-container">
                                        <h3 class="review-form-title">Write a Review</h3>
                                        <form action="${ctx}/review" method="POST">
                                            <input type="hidden" name="_csrf" value="${_csrf}" />
                                            <input type="hidden" name="productId" value="${product.id}">
                                            
                                            <div class="review-form-group">
                                                <label>Rating</label>
                                                <div class="star-rating-input">
                                                    <input type="radio" id="star5" name="rating" value="5" required />
                                                    <label for="star5" title="5 stars"><i class="fa-solid fa-star"></i></label>
                                                    <input type="radio" id="star4" name="rating" value="4" />
                                                    <label for="star4" title="4 stars"><i class="fa-solid fa-star"></i></label>
                                                    <input type="radio" id="star3" name="rating" value="3" />
                                                    <label for="star3" title="3 stars"><i class="fa-solid fa-star"></i></label>
                                                    <input type="radio" id="star2" name="rating" value="2" />
                                                    <label for="star2" title="2 stars"><i class="fa-solid fa-star"></i></label>
                                                    <input type="radio" id="star1" name="rating" value="1" />
                                                    <label for="star1" title="1 star"><i class="fa-solid fa-star"></i></label>
                                                </div>
                                            </div>

                                            <div class="review-form-group">
                                                <label for="reviewText">Review Details</label>
                                                <textarea id="reviewText" name="reviewText" class="review-textarea" placeholder="Share your experience with this premium curation..." required></textarea>
                                            </div>

                                            <button type="submit" class="review-submit-btn">Submit Review</button>
                                        </form>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <!-- Not purchased, show nothing or brief banner about verified purchase -->
                            <div class="review-info-box" style="opacity: 0.7;">
                                <i class="fa-solid fa-circle-info"></i> Only verified purchasers can review this garment.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </div>

        <!-- YOU MAY ALSO LIKE SECTION -->
        <c:if test="${not empty relatedProducts}">
            <div class="related-products">
                <h2 class="related-title">You May Also Like</h2>
                <div class="related-grid">
                    <c:forEach var="p" items="${relatedProducts}">
                        <div class="related-card" onclick="window.location.href='${ctx}/product?id=${p.id}'">
                            <div class="related-img-wrap">
                                <img src="<c:choose><c:when test="${fn:startsWith(p.image, 'http')}">${p.image}</c:when><c:otherwise>${ctx}/assets/images/${p.image}</c:otherwise></c:choose>"
                                     onerror="this.src='${ctx}/assets/images/fallback.jpg'"
                                     alt="<c:out value="${p.name}"/>">
                                <c:if test="${p.discount > 0}">
                                    <span class="related-badge">${p.discount}% OFF</span>
                                </c:if>
                            </div>
                            <div class="related-info">
                                <span class="related-category"><c:out value="${p.category}"/></span>
                                <h4 class="related-name"><c:out value="${p.name}"/></h4>
                                <div class="related-bottom">
                                    <div class="related-price-row">
                                        <span class="related-price">₹<fmt:formatNumber value="${p.price}" maxFractionDigits="0"/></span>
                                        <c:if test="${p.discount > 0}">
                                            <span class="related-original-price">₹<fmt:formatNumber value="${p.originalPrice}" maxFractionDigits="0"/></span>
                                        </c:if>
                                    </div>
                                    <span class="related-rating" style="display: inline-flex; align-items: center; gap: 2px;">
                                        <span class="material-symbols-outlined" style="font-size: 12px; font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24; color: var(--pd-primary);">star</span>
                                        ${p.rating}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

    </div>
    <!-- end .details-wrap -->

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

    <!-- TOAST -->
    <div id="toast"></div>

    <script>
    const ctx = "${ctx}";
    const productId = ${product.id};
    let selectedSize = null;

    // Size selection handler
    document.querySelectorAll(".sizes button.size-btn").forEach(btn => {
        btn.addEventListener("click", () => {
            document.querySelectorAll(".sizes button.size-btn").forEach(b => b.classList.remove("active"));
            btn.classList.add("active");
            selectedSize = btn.dataset.size;
            document.getElementById("selectedSizeInput").value = selectedSize;
        });
    });

    // Cart form submit validation
    const cartForm = document.getElementById("addToCartForm");
    if (cartForm) {
        cartForm.addEventListener("submit", function(e) {
            if (!selectedSize) {
                e.preventDefault();
                showToast("Please select a size first ⚠️");
            }
        });
    }

    // Wishlist Toggle
    function toggleWishlist(id, btn) {
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
            if (res.status === 401) {
                showToast("Please login first ⚠️");
                setTimeout(() => {
                    window.location.href = ctx + "/login";
                }, 1500);
                return;
            }
            return res.text();
        })
        .then(status => {
            if (!status) return;
            if (status.trim() === "added") {
                btn.innerHTML = '<i class="fa-solid fa-heart"></i> Wishlisted';
                btn.classList.add("wishlisted");
                showToast("Added to wishlist ♡");
            } else {
                btn.innerHTML = '<i class="fa-regular fa-heart"></i> Add to Wishlist';
                btn.classList.remove("wishlisted");
                showToast("Removed from wishlist");
            }
        })
        .catch(() => showToast("Something went wrong"));
    }

    // Toast utility
    function showToast(msg) {
        const toast = document.getElementById("toast");
        toast.innerText = msg;
        toast.classList.add("active");
        setTimeout(() => toast.classList.remove("active"), 2500);
    }

    // Navbar scroll effect
    window.addEventListener("scroll", function () {
        const nav = document.querySelector(".navbar");
        if (nav) nav.classList.toggle("scrolled", window.scrollY > 80);
    });
    </script>

</body>
</html>
