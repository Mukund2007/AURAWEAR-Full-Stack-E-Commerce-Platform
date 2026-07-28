<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraWear Admin - Dashboard</title>
    
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
            display: flex;
            justify-content: space-between;
            align-items: center;
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
        /* Metrics Grid */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }
        .metric-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            padding: 30px;
            position: relative;
        }
        .metric-card::before {
            content: "";
            position: absolute;
            top: -1px;
            left: -1px;
            width: 40px;
            height: 2px;
            background-color: var(--accent-color);
        }
        .metric-label {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #66635E;
            margin-bottom: 12px;
        }
        .metric-value {
            font-size: 38px;
            font-weight: 900;
            letter-spacing: -1px;
        }
        .metric-value.accent {
            color: var(--accent-color);
        }
        /* Section styling */
        .section-title {
            font-size: 18px;
            font-weight: 900;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-title i {
            color: var(--accent-color);
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
        /* Status Badges */
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        .status-paid {
            background-color: rgba(0, 255, 0, 0.08);
            color: #5B7358;
            border: 1px solid rgba(0, 255, 0, 0.2);
        }
        .status-shipped {
            background-color: rgba(0, 150, 255, 0.08);
            color: #465F7D;
            border: 1px solid rgba(0, 150, 255, 0.2);
        }
        .status-delivered {
            background-color: rgba(76, 209, 55, 0.15);
            color: #5B7358;
            border: 1px solid rgba(76, 209, 55, 0.3);
        }
        .status-cod_pending, .status-pending, .status-placed {
            background-color: rgba(255, 165, 0, 0.08);
            color: #B89A63;
            border: 1px solid rgba(255, 165, 0, 0.2);
        }
        .status-cod_confirmed {
            background-color: rgba(0, 150, 255, 0.08);
            color: #465F7D;
            border: 1px solid rgba(0, 150, 255, 0.2);
        }
        .status-canceled {
            background-color: rgba(255, 0, 0, 0.08);
            color: #8C3B3B;
            border: 1px solid rgba(255, 0, 0, 0.2);
        }
    </style>
</head>
<body>

<!-- Navigation Header -->
<nav class="admin-nav">
    <div class="nav-brand">AW <span>ADMIN</span></div>
    <ul class="nav-links">
        <li class="active"><a href="${ctx}/admin/dashboard">Dashboard</a></li>
        <li><a href="${ctx}/admin/orders">Orders</a></li>
        <li><a href="${ctx}/admin/products">Products</a></li>
        <li><a href="${ctx}/admin/settings">Settings</a></li>
        <li><a href="${ctx}/home" target="_blank">View Store</a></li>
        <li><a href="${ctx}/logout" class="btn-logout">Logout</a></li>
    </ul>
</nav>

<div class="admin-container">
    <div class="page-header">
        <div>
            <h1 class="page-title">Dashboard Overview</h1>
            <div class="page-subtitle">AuraWear Analytics & Operations Console</div>
        </div>
    </div>

    <!-- Metrics Grid -->
    <div class="metrics-grid">
        <div class="metric-card">
            <div class="metric-label">Total Revenue (Paid)</div>
            <div class="metric-value accent">
                ₹<fmt:formatNumber value="${revenue}" type="number" maxFractionDigits="0" />
            </div>
        </div>
        <div class="metric-card">
            <div class="metric-label">Total Orders Placed</div>
            <div class="metric-value">${ordersCount}</div>
        </div>
        <div class="metric-card">
            <div class="metric-label">Products in Catalog</div>
            <div class="metric-value">${productsCount}</div>
        </div>
    </div>

    <!-- Recent Orders -->
    <h2 class="section-title"><i class="fa-solid fa-clock-rotate-left"></i> Recent 10 Orders</h2>
    <div class="table-container">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>User Email</th>
                    <th>Date</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty recentOrders}">
                        <tr>
                            <td colspan="5" style="text-align: center; color: #66635E;">No orders found in the database.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="order" items="${recentOrders}">
                            <tr>
                                <td><strong>#${order.id}</strong></td>
                                <td><c:out value="${order.userEmail}" /></td>
                                <td>
                                    <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                </td>
                                <td>₹<fmt:formatNumber value="${order.total}" type="number" maxFractionDigits="0" /></td>
                                <td>
                                    <span class="status-badge status-<c:out value="${fn:toLowerCase(order.status)}" />"><c:out value="${order.status}" /></span>
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
