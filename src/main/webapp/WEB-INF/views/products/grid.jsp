<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%-- Cache bust: v300 --%>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<c:choose>
    <c:when test="${empty products}">
        <div class="no-products">
            <span class="material-symbols-outlined no-products-icon">search_off</span>
            No products found. Try adjusting your filters.
        </div>
    </c:when>
    <c:otherwise>
        <c:forEach var="p" items="${products}">
            <div class="product-card ${p.stockQuantity == 0 ? 'oos-card' : ''}" onclick="goToProduct('${p.id}')" data-id="${p.id}" data-name="${p.name}" data-price="${p.price}" data-size="${p.size}">

                <div class="product-image">
                    <img class="img-main"
                         src="<c:choose><c:when test="${fn:startsWith(p.image, 'http')}">${p.image}</c:when><c:otherwise>${ctx}/assets/images/${p.image}</c:otherwise></c:choose>"
                         onerror="this.src='${ctx}/assets/images/fallback.jpg'"
                         alt="${p.name}">
                    <c:choose>
                        <c:when test="${p.stockQuantity == 0}">
                            <div class="badge badge-oos">OUT OF STOCK</div>
                        </c:when>
                        <c:when test="${p.stockQuantity <= 5}">
                            <div class="badge badge-limited">Only ${p.stockQuantity} left</div>
                        </c:when>
                        <c:otherwise>
                            <div class="badge">NEW</div>
                        </c:otherwise>
                    </c:choose>

                    <%-- WISHLIST BUTTON --%>
                    <div class="wishlist ${not empty wishlistNames and wishlistNames.contains(p.id) ? 'active' : ''}"
                         data-id="${p.id}"
                         onclick="toggleWishlist(event, this)">
                         <span class="material-symbols-outlined wishlist-heart-icon">favorite</span>
                    </div>

                    <%-- QUICK ADD --%>
                    <button class="quick-add ${p.stockQuantity == 0 ? 'disabled' : ''}"
                            data-id="${p.id}"
                            data-size="${p.size}"
                            data-price="${p.price}"
                            onclick="quickAdd(event)"
                            ${p.stockQuantity == 0 ? 'disabled' : ''}>
                        ${p.stockQuantity == 0 ? 'Out of Stock' : 'Quick Add'}
                    </button>
                </div>

                <div class="product-info">
                    <span class="product-category-tag">${p.category}</span>
                    <h3 class="product-title-text">${p.name}</h3>
                    <div class="product-meta-specs">${p.size} &bull; ${p.color}</div>
                    <div class="price-row" style="display: flex; align-items: center; gap: 8px; margin-top: 4px;">
                        <div class="price-tag" style="font-size: 14px; font-weight: 500; color: var(--text-color);">&#8377;<fmt:formatNumber value="${p.price}" maxFractionDigits="0"/></div>
                        <c:if test="${p.discount > 0}">
                            <span class="original-price" style="font-size: 12px; color: var(--text-muted); text-decoration: line-through; font-family: var(--font-body);">&#8377;<fmt:formatNumber value="${p.originalPrice}" maxFractionDigits="0"/></span>
                            <span class="discount-badge" style="display: inline-block; background-color: rgba(220, 38, 38, 0.08); color: var(--error-color); font-size: 11px; font-weight: 600; padding: 2px 6px; border-radius: 0px; font-family: var(--font-body); letter-spacing: 0.02em;">${p.discount}% OFF</span>
                        </c:if>
                    </div>
                </div>

            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>