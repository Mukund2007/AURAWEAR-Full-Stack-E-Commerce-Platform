<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraWear Admin - Orders</title>
    
    <!-- Google Analytics GA4 -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-EG16LNFXMK"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'G-EG16LNFXMK');
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/admin-responsive.css">

    <style>
        :root {
            --bg-color: #F7F2EC;
            --text-color: #000000;
            --border-color: #D8D1CA;
            --border-color-solid: #000000;
            --accent-color: #000000;
            --card-bg: #D9CDC2;
            --input-bg: #D9CDC2;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: var(--font-body);
            background-color: var(--bg-color);
            color: var(--text-color);
            min-height: 100vh;
        }
        /* Navigation */
        .admin-nav {
            border-bottom: 1.5px solid var(--border-color);
            padding: 20px 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: #000000;
        }
        .nav-brand {
            font-size: 20px;
            font-weight: 900;
            letter-spacing: 3px;
            text-transform: uppercase;
        }
        .nav-brand span {
            color: var(--accent-color);
        }
        .nav-links {
            display: flex;
            gap: 30px;
            list-style: none;
            align-items: center;
        }
        .nav-links a {
            color: var(--text-color);
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            opacity: 0.7;
            transition: opacity 0.25s, color 0.3s;
        }
        .nav-links a:hover, .nav-links .active a {
            opacity: 1;
            color: var(--accent-color);
        }
        .btn-logout {
            border: 1px solid var(--border-color);
            padding: 8px 16px;
            transition: border-color 0.25s;
        }
        .btn-logout:hover {
            border-color: var(--accent-color);
        }
        /* Content Layout */
        .admin-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        .page-header {
            margin-bottom: 40px;
        }
        .page-title {
            font-size: 32px;
            font-weight: 900;
            letter-spacing: -1.5px;
            text-transform: uppercase;
        }
        .page-subtitle {
            font-size: 12px;
            color: #66635E;
            letter-spacing: 2px;
            text-transform: uppercase;
            margin-top: 4px;
        }
        /* Tables */
        .table-container {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            overflow-x: auto;
        }
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        .admin-table th, .admin-table td {
            padding: 18px 24px;
            border-bottom: 1px solid var(--border-color);
            font-size: 14px;
            vertical-align: top;
        }
        .admin-table th {
            background-color: #000000;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: #66635E;
        }
        .admin-table tbody tr:hover {
            background-color: rgba(28, 46, 74, 0.05);
        }
        /* Items list inner styling */
        .order-items-list {
            list-style: none;
        }
        .order-item-detail {
            font-size: 13px;
            margin-bottom: 6px;
            color: #D8D1CA;
            border-bottom: 1px dashed rgba(237, 228, 221, 0.08);
            padding-bottom: 6px;
        }
        .order-item-detail:last-child {
            margin-bottom: 0;
            border-bottom: none;
            padding-bottom: 0;
        }
        .item-qty {
            color: #66635E;
            margin-left: 5px;
        }
        .item-size {
            background-color: rgba(28, 46, 74, 0.08);
            padding: 1px 5px;
            font-size: 10px;
            font-weight: 700;
            margin-left: 5px;
        }
        /* Shipping address cell */
        .shipping-cell {
            font-size: 12px;
            line-height: 1.6;
            color: #D8D1CA;
        }
        .shipping-cell .ship-name {
            font-weight: 700;
            color: var(--text-color);
            display: block;
            margin-bottom: 2px;
        }
        .shipping-cell .ship-phone {
            color: var(--accent-color);
            font-weight: 600;
        }
        /* Status selector form */
        .status-select {
            background-color: var(--input-bg);
            color: var(--text-color);
            border: 1px solid var(--border-color);
            padding: 8px 12px;
            font-family: var(--font-body);
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.5px;
            outline: none;
            cursor: pointer;
            transition: border-color 0.25s;
        }
        .status-select:focus {
            border-color: var(--accent-color);
        }
        .status-select option {
            background-color: var(--card-bg);
            color: var(--text-color);
        }
        .alert-success {
            background-color: rgba(0, 255, 0, 0.08);
            border-left: 3px solid #4cd137;
            padding: 14px 20px;
            font-size: 14px;
            color: #5B7358;
            margin-bottom: 24px;
        }
    </style>
</head>
<body>

<!-- Navigation Header -->
<nav class="admin-nav">
    <div class="nav-brand">AW <span>ADMIN</span></div>
    <ul class="nav-links">
        <li><a href="${ctx}/admin/dashboard">Dashboard</a></li>
        <li class="active"><a href="${ctx}/admin/orders">Orders</a></li>
        <li><a href="${ctx}/admin/products">Products</a></li>
        <li><a href="${ctx}/admin/settings">Settings</a></li>
        <li><a href="${ctx}/home" target="_blank">View Store</a></li>
        <li><a href="${ctx}/logout" class="btn-logout">Logout</a></li>
    </ul>
</nav>

<div class="admin-container">
    <div class="page-header">
        <h1 class="page-title">Order Management</h1>
        <div class="page-subtitle">Track receipts and change shipping fulfillment statuses</div>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert-success">
            <i class="fa-solid fa-circle-check"></i> Order status updated successfully!
        </div>
    </c:if>

    <!-- Orders Table -->
    <div class="table-container">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>User Email</th>
                    <th>Date</th>
                    <th>Items Details</th>
                    <th>Shipping Address</th>
                    <th>Total</th>
                    <th>Status Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty orders}">
                        <tr>
                            <td colspan="7" style="text-align: center; color: #66635E;">No orders placed yet.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td><strong>#${order.id}</strong></td>
                                <td><c:out value="${order.userEmail}" /></td>
                                <td>
                                    <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                </td>
                                <td>
                                    <ul class="order-items-list">
                                        <c:forEach var="item" items="${order.items}">
                                            <li class="order-item-detail">
                                                <span><c:out value="${item.productName}" /></span>
                                                <span class="item-size"><c:out value="${item.size}" /></span>
                                                <span class="item-qty">x${item.quantity}</span>
                                                <span style="float: right;">₹<fmt:formatNumber value="${item.price * item.quantity}" type="number" maxFractionDigits="0" /></span>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty order.shippingName}">
                                            <div class="shipping-cell">
                                                <span class="ship-name"><c:out value="${order.shippingName}" /></span>
                                                <span class="ship-phone"><i class="fa-solid fa-phone" style="font-size:10px;"></i> <c:out value="${order.shippingPhone}" /></span><br>
                                                <c:out value="${order.shippingAddress}" /><br>
                                                <c:out value="${order.shippingCity}" />, <c:out value="${order.shippingState}" /> - <c:out value="${order.shippingPincode}" />
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #555;">—</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><strong>₹<fmt:formatNumber value="${order.total}" type="number" maxFractionDigits="0" /></strong></td>
                                <td>
                                    <form action="${ctx}/admin/orders" method="post" style="display:inline;">
                                        <input type="hidden" name="_csrf" value="${_csrf}" />
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <select name="status" class="status-select" onchange="this.form.submit()">
                                            <option value="COD_PENDING" ${order.status == 'COD_PENDING' ? 'selected' : ''}>COD_PENDING</option>
                                            <option value="COD_CONFIRMED" ${order.status == 'COD_CONFIRMED' ? 'selected' : ''}>COD_CONFIRMED</option>
                                            <option value="PAID" ${order.status == 'PAID' ? 'selected' : ''}>PAID</option>
                                            <option value="SHIPPED" ${order.status == 'SHIPPED' ? 'selected' : ''}>SHIPPED</option>
                                            <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                            <option value="Placed" ${order.status == 'Placed' ? 'selected' : ''}>Placed</option>
                                            <option value="Canceled" ${order.status == 'Canceled' ? 'selected' : ''}>Canceled</option>
                                        </select>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
