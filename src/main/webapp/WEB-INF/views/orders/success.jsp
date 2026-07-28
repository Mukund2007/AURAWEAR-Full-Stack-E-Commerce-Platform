<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../partials/head-includes.jsp" />
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Placed — AuraWear</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/home.css?v=200">
    <link rel="stylesheet" href="${ctx}/assets/css/success.css?v=200">
</head>
<body>

    <jsp:include page="../partials/navbar.jsp" />

    <div class="success-wrap">

        <div class="success-icon">
            <i class="fa-solid fa-check"></i>
        </div>

        <h1>Order Placed! 🎉</h1>
        <p>Thank you for shopping with AuraWear.<br>Your order is confirmed and will be shipped soon.</p>

        <div class="success-actions">
            <a href="${ctx}/my-orders" class="btn-dark">View My Orders</a>
            <a href="${ctx}/products"  class="btn-light">Continue Shopping</a>
        </div>

    </div>

    <script>
        window.addEventListener('scroll', function () {
            const nav = document.querySelector('.navbar');
            if (nav) nav.classList.toggle('scrolled', window.scrollY > 80);
        });
    </script>

    <c:if test="${sessionScope.justPurchased}">
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                if (typeof gtag === 'function') {
                    gtag('event', 'purchase', {
                        transaction_id: '${sessionScope.purchaseOrderId}',
                        value: parseFloat('${sessionScope.purchaseTotal}') || 0,
                        currency: 'INR',
                        items: [
                            <c:forEach var="item" items="${sessionScope.purchaseItems}" varStatus="status">
                            {
                                item_id: parseInt('${item.productId}') || 0,
                                item_name: '${fn:replace(fn:escapeXml(item.productName), "'", "\\'")}',
                                price: parseFloat('${item.price}') || 0,
                                quantity: parseInt('${item.quantity}') || 0,
                                item_size: '${fn:replace(fn:escapeXml(item.size), "'", "\\'")}'
                            }${not status.last ? ',' : ''}
                            </c:forEach>
                        ]
                    });
                }
            });
        </script>
        <%
            session.removeAttribute("justPurchased");
            session.removeAttribute("purchaseOrderId");
            session.removeAttribute("purchaseTotal");
            session.removeAttribute("purchaseItems");
        %>
    </c:if>

</body>
</html>
