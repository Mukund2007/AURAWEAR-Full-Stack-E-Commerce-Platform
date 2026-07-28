<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../partials/head-includes.jsp" />
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders — AuraWear</title>
    <link rel="stylesheet" href="${ctx}/assets/css/home.css?v=200">
    <link rel="stylesheet" href="${ctx}/assets/css/orders.css?v=200">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="bg-background text-on-background min-h-screen flex flex-col font-body-md antialiased">

    <jsp:include page="../partials/navbar.jsp" />

    <div class="orders-page">
        <!-- MAIN CONTENT -->
        <div class="orders-container">
            <!-- PAGE HEADER -->
            <header class="orders-header">
                <div class="orders-header-inner">
                    <h1>My Orders</h1>
                    <p>
                        <c:choose>
                            <c:when test="${not empty orders}">
                                ${orders.size()} premium selection<c:if test="${orders.size() != 1}">s</c:if> curated
                            </c:when>
                            <c:otherwise>Track and manage your high-end acquisitions</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </header>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="orders-empty">
                        <h3>No curated orders</h3>
                        <p>Your luxury collection is waiting.<br>Explore outstanding style narratives.</p>
                        <a href="${ctx}/products" class="orders-empty-link">Explore Collection</a>
                    </div>
                </c:when>

                <c:otherwise>
                    <!-- DYNAMIC JSTL STATS CALCULATOR -->
                    <c:set var="placedCount" value="0" />
                    <c:set var="shippedCount" value="0" />
                    <c:set var="deliveredCount" value="0" />
                    <c:set var="cancelledCount" value="0" />
                    <c:forEach var="item" items="${orders}">
                        <c:set var="s" value="${item[2]}" />
                        <c:choose>
                            <c:when test="${s == 'Placed' || s == 'COD_PENDING' || s == 'COD_CONFIRMED'}"><c:set var="placedCount" value="${placedCount + 1}" /></c:when>
                            <c:when test="${s == 'Shipped'}"><c:set var="shippedCount" value="${shippedCount + 1}" /></c:when>
                            <c:when test="${s == 'Delivered'}"><c:set var="deliveredCount" value="${deliveredCount + 1}" /></c:when>
                            <c:when test="${s == 'Cancelled'}"><c:set var="cancelledCount" value="${cancelledCount + 1}" /></c:when>
                        </c:choose>
                    </c:forEach>

                    <!-- STATS DASHBOARD -->
                    <section class="orders-stats-dashboard">
                        <div class="stat-widget">
                            <div class="stat-widget-header">
                                <span class="stat-label">Total Curated</span>
                                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0, 'wght' 200;">inventory_2</span>
                            </div>
                            <div class="stat-value">${orders.size()}</div>
                        </div>
                        <div class="stat-widget">
                            <div class="stat-widget-header">
                                <span class="stat-label">Active Transit</span>
                                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0, 'wght' 200;">local_shipping</span>
                            </div>
                            <div class="stat-value">${shippedCount + placedCount}</div>
                        </div>
                        <div class="stat-widget">
                            <div class="stat-widget-header">
                                <span class="stat-label">Delivered</span>
                                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0, 'wght' 200;">check_circle</span>
                            </div>
                            <div class="stat-value">${deliveredCount}</div>
                        </div>
                    </section>

                    <!-- ORDERS LIST -->
                    <section class="orders-list">
                        <c:forEach var="order" items="${orders}" varStatus="loop">
                            <c:set var="status" value="${order[2]}" />

                            <article class="order-card" onclick="window.location.href='${ctx}/product?id=${order[5]}'">
                                <!-- Left Image Box -->
                                <div class="order-card-image-box">
                                    <c:choose>
                                        <c:when test="${not empty order[8]}">
                                            <img src="<c:choose><c:when test="${fn:startsWith(order[8], 'http')}">${order[8]}</c:when><c:otherwise>${ctx}/assets/images/${order[8]}</c:otherwise></c:choose>" alt="${order[3]}" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                                            <div class="order-img-fallback" style="display:none; width:100%; height:100%; align-items:center; justify-content:center; background:var(--orders-surface-low);">
                                                <span class="material-symbols-outlined" style="font-size: 48px; color: var(--orders-outline); font-variation-settings: 'FILL' 0, 'wght' 200;">package_2</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="material-symbols-outlined" style="font-size: 48px; color: var(--orders-outline); font-variation-settings: 'FILL' 0, 'wght' 200;">package_2</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Right Content Panel (Middle + Right Columns) -->
                                <div class="order-card-content">
                                    <!-- Middle Column: Details -->
                                    <div class="order-card-details">
                                        <span class="order-date-id">
                                            Order #${order[0]} &middot; 
                                            <c:catch var="parseEx">
                                                <fmt:parseDate value="${order[4]}" pattern="yyyy-MM-dd" var="parsedDate" />
                                            </c:catch>
                                            <c:choose>
                                                <c:when test="${not empty parsedDate}">
                                                    <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${order[4]}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                        <h3 class="order-product-name"><c:out value="${order[3]}" /></h3>
                                        
                                        <!-- Specs Row -->
                                        <div class="order-specs-row">
                                            <c:if test="${not empty order[6]}">
                                                <span>Size: <c:out value="${order[6]}" /></span>
                                            </c:if>
                                            <c:if test="${not empty order[6] && not empty order[7]}">
                                                <span>&nbsp;&nbsp;</span>
                                            </c:if>
                                            <c:if test="${not empty order[7]}">
                                                <span>Qty: ${order[7]}</span>
                                            </c:if>
                                        </div>
                                        
                                        <!-- Price -->
                                        <span class="order-card-price">₹<fmt:formatNumber value="${order[1]}" maxFractionDigits="0"/></span>
                                    </div>

                                    <!-- Right Column: Status & Actions -->
                                    <div class="order-card-status-actions">
                                        <!-- Badge Status -->
                                        <c:choose>
                                            <c:when test="${status == 'Placed'}">
                                                <span class="order-badge placed">
                                                    <span class="badge-dot"></span> Placed
                                                </span>
                                            </c:when>
                                            <c:when test="${status == 'COD_PENDING'}">
                                                <span class="order-badge cod_pending">
                                                    <span class="badge-dot"></span> COD Pending
                                                </span>
                                            </c:when>
                                            <c:when test="${status == 'COD_CONFIRMED'}">
                                                <span class="order-badge cod_confirmed">
                                                    <span class="badge-dot"></span> COD Confirmed
                                                </span>
                                            </c:when>
                                            <c:when test="${status == 'PAID'}">
                                                <span class="order-badge paid">
                                                    <span class="badge-dot"></span> Paid
                                                </span>
                                            </c:when>
                                            <c:when test="${status == 'Shipped'}">
                                                <span class="order-badge shipped">
                                                    <span class="badge-dot"></span> Shipped
                                                </span>
                                            </c:when>
                                            <c:when test="${status == 'Delivered'}">
                                                <span class="order-badge delivered">
                                                    <span class="badge-dot"></span> Delivered
                                                </span>
                                            </c:when>
                                            <c:when test="${status == 'Cancelled'}">
                                                <span class="order-badge cancelled">
                                                    <span class="badge-dot"></span> Cancelled
                                                </span>
                                            </c:when>
                                            <c:when test="${status == 'Returned'}">
                                                <span class="order-badge returned">
                                                    <span class="badge-dot"></span> Returned
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="order-badge">
                                                    <span class="badge-dot"></span> <c:out value="${status}" />
                                                </span>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Actions Row -->
                                        <div class="order-actions-wrap">
                                            <!-- Cancel Action (Plain link) -->
                                            <c:choose>
                                                <c:when test="${status == 'Placed' || status == 'COD_PENDING' || status == 'COD_CONFIRMED' || status == 'PAID'}">
                                                    <button class="order-action-link" onclick="event.stopPropagation(); performOrderAction('${order[0]}', 'cancel')">
                                                        Cancel Order
                                                    </button>
                                                </c:when>
                                                <c:when test="${status == 'Delivered'}">
                                                    <button class="order-action-link" onclick="event.stopPropagation(); performOrderAction('${order[0]}', 'return')">
                                                        Return Item
                                                    </button>
                                                </c:when>
                                            </c:choose>

                                            <!-- Main Action Button (Outline button) -->
                                            <c:choose>
                                                <c:when test="${status == 'Placed' || status == 'COD_PENDING' || status == 'COD_CONFIRMED' || status == 'Shipped' || status == 'PAID'}">
                                                    <button class="order-action-btn" onclick="event.stopPropagation(); openTracker('${order[0]}', '${fn:replace(fn:escapeXml(order[3]), "'", "\\'")}', '${fn:replace(fn:escapeXml(status), "'", "\\'")}', '${order[4]}')">
                                                        + Track Order
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="order-action-btn" onclick="event.stopPropagation(); window.location.href='${ctx}/product?id=${order[5]}'">
                                                        View Details
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </section>
                </c:otherwise>
            </c:choose>
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

    <!-- MINIMALIST TIMELINE TRACKING MODAL -->
    <div id="trackerModal" class="tracker-overlay" onclick="closeTracker()">
        <div class="tracker-modal" onclick="event.stopPropagation()">
            <button class="tracker-close-btn" onclick="closeTracker()">
                <span class="material-symbols-outlined">close</span>
            </button>
            
            <div class="tracker-modal-header">
                <h2>Real-Time Tracking</h2>
                <div class="tracker-subtitle">
                    <span id="trackerProductName">Curated Garment</span> &middot; Order #<span id="trackerOrderId">10000</span>
                </div>
            </div>
            
            <div class="tracker-timeline">
                <div class="tracker-progress-line">
                    <div id="trackerProgressFill" class="tracker-progress-fill"></div>
                </div>
                
                <div id="step-placed" class="tracker-step">
                    <div class="step-dot">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0, 'wght' 300;">receipt_long</span>
                    </div>
                    <div class="step-info">
                        <h3>Order Placed</h3>
                        <p>Atelier received your curation choices.</p>
                    </div>
                </div>
                
                <div id="step-processing" class="tracker-step">
                    <div class="step-dot">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0, 'wght' 300;">package_2</span>
                    </div>
                    <div class="step-info">
                        <h3>In Production</h3>
                        <p>Crafting, detailing, and sizing at our Atelier.</p>
                    </div>
                </div>
                
                <div id="step-shipped" class="tracker-step">
                    <div class="step-dot">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0, 'wght' 300;">local_shipping</span>
                    </div>
                    <div class="step-info">
                        <h3>Shipped</h3>
                        <p>Dispatched via high-end courier service.</p>
                    </div>
                </div>
                
                <div id="step-delivered" class="tracker-step">
                    <div class="step-dot">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0, 'wght' 300;">check_circle</span>
                    </div>
                    <div class="step-info">
                        <h3>Delivered</h3>
                        <p>Acquisition successfully reached its destination.</p>
                    </div>
                </div>
            </div>
            
            <div class="tracker-details">
                <div class="tracker-details-header">Curation Milestones</div>
                <div class="tracker-milestone">
                    <span class="milestone-time">14:20 PM</span>
                    <span class="milestone-text">Logistics courier routed to regional sorting hub</span>
                </div>
                <div class="tracker-milestone">
                    <span class="milestone-time">09:15 AM</span>
                    <span class="milestone-text">Atelier quality checks passed & vacuum sealed</span>
                </div>
                <div class="tracker-milestone">
                    <span class="milestone-time">08:00 AM</span>
                    <span class="milestone-text">Bespoke tailoring and alignment finalized</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        // TRACKER CONTROLLER
        function openTracker(orderId, productName, status, date) {
            document.getElementById('trackerOrderId').innerText = orderId;
            document.getElementById('trackerProductName').innerText = productName;
            
            const steps = ['placed', 'processing', 'shipped', 'delivered'];
            steps.forEach(step => {
                document.getElementById('step-' + step).className = 'tracker-step';
            });
            
            const progressFill = document.getElementById('trackerProgressFill');
            
            if (status === 'Placed' || status === 'COD_PENDING' || status === 'COD_CONFIRMED' || status === 'PAID') {
                document.getElementById('step-placed').className = 'tracker-step active';
                document.getElementById('step-processing').className = 'tracker-step active';
                progressFill.style.height = '33%';
            } else if (status === 'Shipped') {
                document.getElementById('step-placed').className = 'tracker-step completed';
                document.getElementById('step-processing').className = 'tracker-step completed';
                document.getElementById('step-shipped').className = 'tracker-step active';
                progressFill.style.height = '66%';
            } else if (status === 'Delivered') {
                document.getElementById('step-placed').className = 'tracker-step completed';
                document.getElementById('step-processing').className = 'tracker-step completed';
                document.getElementById('step-shipped').className = 'tracker-step completed';
                document.getElementById('step-delivered').className = 'tracker-step completed';
                progressFill.style.height = '100%';
            } else if (status === 'Cancelled') {
                document.getElementById('step-placed').className = 'tracker-step completed';
                document.getElementById('step-processing').className = 'tracker-step cancelled';
                progressFill.style.height = '33%';
            }
            
            document.getElementById('trackerModal').classList.add('open');
            document.body.style.overflow = 'hidden';
        }

        function closeTracker() {
            document.getElementById('trackerModal').classList.remove('open');
            document.body.style.overflow = '';
        }

        // Close on escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') closeTracker();
        });

        // ORDER ACTION CONTROLLER (CANCEL & RETURN)
        function performOrderAction(orderId, action) {
            const displayAction = action === 'cancel' ? 'cancel' : 'return';
            if (confirm("Are you sure you want to " + displayAction + " Order #" + orderId + "?")) {
                fetch('${ctx}/update-order-status', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-CSRF-Token': '${_csrf}'
                    },
                    body: 'orderId=' + encodeURIComponent(orderId) + '&action=' + encodeURIComponent(action)
                })
                .then(response => {
                    if (response.ok) {
                        window.location.reload();
                    } else {
                        response.text().then(text => alert('Error: ' + text));
                    }
                })
                .catch(error => {
                    console.error('Error updating order:', error);
                    alert('An error occurred. Please try again.');
                });
            }
        }
    </script>
</body>
</html>
