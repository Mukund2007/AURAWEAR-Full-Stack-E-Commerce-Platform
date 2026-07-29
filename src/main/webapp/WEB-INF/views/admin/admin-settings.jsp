<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraWear Admin - Settings</title>
    
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
            --bg-color: #ffffff;
            --text-color: #000000;
            --border-color: #e5e5e5;
            --border-color-solid: #000000;
            --accent-color: #000000;
            --card-bg: #f5f5f5;
            --input-bg: #f5f5f5;
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
            max-width: 600px;
            margin: 0 auto;
            padding: 60px 20px;
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
            color: #737373;
            letter-spacing: 2px;
            text-transform: uppercase;
            margin-top: 4px;
        }
        /* Form panels */
        .settings-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            padding: 40px;
            position: relative;
        }
        .settings-card::before {
            content: "";
            position: absolute;
            top: -1px;
            left: -1px;
            width: 60px;
            height: 2px;
            background-color: var(--accent-color);
        }
        .form-group {
            margin-bottom: 24px;
            display: flex;
            flex-direction: column;
        }
        .form-group label {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: #737373;
            margin-bottom: 8px;
        }
        .form-group input {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            padding: 14px 16px;
            color: var(--text-color);
            font-family: var(--font-body);
            font-size: 14px;
            outline: none;
            transition: border-color 0.25s;
        }
        .form-group input:focus {
            border-color: var(--border-color-solid);
        }
        /* Buttons */
        .btn-save {
            width: 100%;
            background-color: var(--accent-color);
            color: #ffffff;
            border: none;
            padding: 16px;
            font-family: var(--font-body);
            font-size: 12px;
            font-weight: 900;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            cursor: pointer;
            transition: opacity 0.25s;
        }
        .btn-save:hover {
            opacity: 0.9;
        }
        .alert-success {
            background-color: rgba(0, 255, 0, 0.08);
            border-left: 3px solid #16a34a;
            padding: 14px 20px;
            font-size: 14px;
            color: #16a34a;
            margin-bottom: 24px;
        }
        .alert-error {
            background-color: rgba(255, 0, 0, 0.08);
            border-left: 3px solid #dc2626;
            padding: 14px 20px;
            font-size: 14px;
            color: #dc2626;
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
        <li><a href="${ctx}/admin/orders">Orders</a></li>
        <li><a href="${ctx}/admin/products">Products</a></li>
        <li class="active"><a href="${ctx}/admin/settings">Settings</a></li>
        <li><a href="${ctx}/home" target="_blank">View Store</a></li>
        <li><a href="${ctx}/logout" class="btn-logout">Logout</a></li>
    </ul>
</nav>

<div class="admin-container">
    <div class="page-header">
        <h1 class="page-title">Store Settings</h1>
        <div class="page-subtitle">Configure shipping charges and promotional thresholds</div>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert-success">
            <i class="fa-solid fa-circle-check"></i> Shipping configuration saved successfully!
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert-error">
            <i class="fa-solid fa-triangle-exclamation"></i> Error updating settings. Please try again.
        </div>
    </c:if>

    <div class="settings-card">
        <form action="${ctx}/admin/settings" method="post">
            <input type="hidden" name="_csrf" value="${_csrf}" />
            <div class="form-group">
                <label>Shipping Charge (₹)</label>
                <input type="number" name="shippingCharge" value="${shippingCharge}" required min="0" placeholder="99">
            </div>
            
            <div class="form-group">
                <label>Free Shipping Threshold (₹)</label>
                <input type="number" name="freeShippingThreshold" value="${freeShippingThreshold}" required min="0" placeholder="999">
            </div>

            <button type="submit" class="btn-save">Save Configuration</button>
        </form>
    </div>
</div>

</body>
</html>
