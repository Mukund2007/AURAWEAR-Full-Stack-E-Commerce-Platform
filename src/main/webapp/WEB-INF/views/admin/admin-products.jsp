<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraWear Admin - Products</title>
    
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
        /* Form panels */
        .collapsible-form-panel {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            padding: 30px;
            margin-bottom: 40px;
            display: none;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
        }
        .form-group label {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: #66635E;
            margin-bottom: 6px;
        }
        .form-group input, .form-group select {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            padding: 10px 14px;
            color: var(--text-color);
            font-family: var(--font-body);
            font-size: 13px;
            outline: none;
            transition: border-color 0.25s;
        }
        .form-group input:focus, .form-group select:focus {
            border-color: var(--border-color-solid);
        }
        /* Buttons */
        .btn-action {
            background-color: transparent;
            color: var(--text-color);
            border: 1px solid var(--border-color-solid);
            padding: 10px 20px;
            font-family: var(--font-body);
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.25s;
        }
        .btn-action:hover {
            background-color: var(--text-color);
            color: var(--bg-color);
        }
        .btn-accent {
            background-color: var(--accent-color);
            border-color: var(--accent-color);
            color: #F7F2EC;
        }
        .btn-accent:hover {
            background-color: transparent;
            border-color: var(--accent-color);
            color: var(--accent-color);
        }
        .btn-edit {
            background-color: transparent;
            color: var(--text-color);
            border: 1px solid var(--border-color);
            padding: 6px 12px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            cursor: pointer;
            transition: border-color 0.25s;
            margin-right: 5px;
        }
        .btn-edit:hover {
            border-color: var(--text-color);
        }
        .btn-delete {
            background-color: transparent;
            color: #8C3B3B;
            border: 1px solid rgba(255, 77, 77, 0.3);
            padding: 6px 12px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.25s;
        }
        .btn-delete:hover {
            border-color: #8C3B3B;
            background-color: rgba(255, 77, 77, 0.1);
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
            padding: 14px 20px;
            border-bottom: 1px solid var(--border-color);
            font-size: 13px;
            vertical-align: middle;
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
        .product-thumbnail {
            width: 40px;
            height: 48px;
            object-fit: cover;
            border: 1.5px solid var(--border-color);
        }
        /* Modal Window styling */
        .admin-modal {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0, 0, 0, 0.85);
            align-items: center;
            justify-content: center;
            z-index: 1000;
            padding: 20px;
        }
        .modal-content {
            background-color: var(--card-bg);
            border: 1.5px solid var(--border-color);
            padding: 40px;
            width: 100%;
            max-width: 800px;
            position: relative;
        }
        .modal-close {
            position: absolute;
            top: 20px; right: 20px;
            color: #66635E;
            font-size: 24px;
            cursor: pointer;
            background: none;
            border: none;
        }
        .modal-close:hover {
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
        <li><a href="${ctx}/admin/orders">Orders</a></li>
        <li class="active"><a href="${ctx}/admin/products">Products</a></li>
        <li><a href="${ctx}/admin/settings">Settings</a></li>
        <li><a href="${ctx}/home" target="_blank">View Store</a></li>
        <li><a href="${ctx}/logout" class="btn-logout">Logout</a></li>
    </ul>
</nav>

<div class="admin-container">
    <div class="page-header">
        <div>
            <h1 class="page-title">Catalog Inventory</h1>
            <div class="page-subtitle">Add, edit, or remove products in storefront database</div>
        </div>
        <button class="btn-action btn-accent" onclick="toggleAddForm()"><i class="fa-solid fa-plus"></i> Add Product</button>
    </div>

    <c:if test="${not empty param.msg}">
        <div class="alert-success">
            <i class="fa-solid fa-circle-check"></i> <c:out value="${param.msg}" />
        </div>
    </c:if>

    <!-- Collapsible Add Product Panel -->
    <div class="collapsible-form-panel" id="addProductPanel">
        <h2 style="font-size: 16px; text-transform: uppercase; margin-bottom: 20px; border-bottom: 1px solid var(--border-color); padding-bottom: 10px;">Add New Product</h2>
        <form action="${ctx}/admin/products" method="post">
            <input type="hidden" name="_csrf" value="${_csrf}" />
            <input type="hidden" name="action" value="add">
            
            <div class="form-grid">
                <div class="form-group">
                    <label>Product Name</label>
                    <input type="text" name="name" required placeholder="Classic Oversized Tee">
                </div>
                <div class="form-group">
                    <label>Fulfillment Price (₹)</label>
                    <input type="number" name="price" required placeholder="2499">
                </div>
                <div class="form-group">
                    <label>Original Price (For Discount, ₹)</label>
                    <input type="number" name="originalPrice" placeholder="2999">
                </div>
                <div class="form-group">
                    <label>Discount Percentage (%)</label>
                    <input type="number" name="discount" value="0" placeholder="15">
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <select name="category" required>
                        <option value="Tops">Tops</option>
                        <option value="Bottoms">Bottoms</option>
                        <option value="Footwear">Footwear</option>
                        <option value="Accessories">Accessories</option>
                        <option value="Outerwear">Outerwear</option>
                        <option value="Sets">Sets</option>
                        <option value="Pants">Pants</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Apparel Type</label>
                    <input type="text" name="type" placeholder="Oversized Tee" required>
                </div>
                <div class="form-group">
                    <label>Sizes (Comma separated)</label>
                    <input type="text" name="size" value="S, M, L, XL" required placeholder="S, M, L, XL">
                </div>
                <div class="form-group">
                    <label>Colors (Comma separated)</label>
                    <input type="text" name="color" value="Black, White" required placeholder="Charcoal Noir">
                </div>
                <div class="form-group">
                    <label>Gender Targeting</label>
                    <select name="gender" required>
                        <option value="Unisex">Unisex</option>
                        <option value="Men">Men</option>
                        <option value="Women">Women</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Brand Name</label>
                    <input type="text" name="brand" value="AuraWear" required>
                </div>
                <div class="form-group">
                    <label>Stock Quantity</label>
                    <input type="number" name="stockQuantity" value="100" min="0" required>
                </div>
                <div class="form-group">
                    <label>Image Asset Name / URL</label>
                    <input type="text" name="image" value="fallback.jpg" required placeholder="assets/images/tee6.jpg or tee6.jpg">
                </div>
            </div>

            <button type="submit" class="btn-action btn-accent">Save Product</button>
            <button type="button" class="btn-action" onclick="toggleAddForm()" style="margin-left: 10px;">Cancel</button>
        </form>
    </div>

    <!-- Products Table -->
    <div class="table-container">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Asset</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Type</th>
                    <th>Price</th>
                    <th>Original</th>
                    <th>Sizes</th>
                    <th>Colors</th>
                    <th>Gender</th>
                    <th>Stock</th>
                    <th style="width: 180px;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="prod" items="${products}">
                    <tr>
                        <td>
                            <img src="<c:choose><c:when test="${fn:startsWith(prod.image, 'http')}">${prod.image}</c:when><c:otherwise>${ctx}/assets/images/${prod.image}</c:otherwise></c:choose>" class="product-thumbnail" alt="${prod.name}" onerror="this.src='${ctx}/assets/images/fallback.jpg';">
                        </td>
                        <td><strong><c:out value="${prod.name}" /></strong></td>
                        <td><c:out value="${prod.category}" /></td>
                        <td><c:out value="${prod.type}" /></td>
                        <td>₹<fmt:formatNumber value="${prod.price}" type="number" maxFractionDigits="0" /></td>
                        <td>₹<fmt:formatNumber value="${prod.originalPrice}" type="number" maxFractionDigits="0" /></td>
                        <td><c:out value="${prod.size}" /></td>
                        <td><c:out value="${prod.color}" /></td>
                        <td><c:out value="${prod.gender}" /></td>
                        <td>
                            <c:choose>
                                <c:when test="${prod.stockQuantity > 5}">
                                    <span style="color: #5B7358;"><i class="fa-solid fa-circle" style="font-size: 8px; vertical-align: middle; margin-right: 4px;"></i> In Stock (${prod.stockQuantity})</span>
                                </c:when>
                                <c:when test="${prod.stockQuantity > 0}">
                                    <span style="color: #B89A63;"><i class="fa-solid fa-circle" style="font-size: 8px; vertical-align: middle; margin-right: 4px;"></i> Low Stock (${prod.stockQuantity})</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #8C3B3B;"><i class="fa-solid fa-circle" style="font-size: 8px; vertical-align: middle; margin-right: 4px;"></i> Out of Stock</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <%-- ✅ SECURITY: pass only the numeric ID to JS; all text fields are
                                 stored in a data-json attribute with fn:escapeXml HTML-escaping,
                                 then read by openEditModal() via JSON.parse. This prevents any
                                 product field containing quotes/HTML/JS from injecting into the
                                 onclick attribute. --%>
                            <button class="btn-edit"
                                    data-product-id="${prod.id}"
                                    data-product-json="{
                                        &quot;id&quot;:${prod.id},
                                        &quot;name&quot;:&quot;<c:out value="${prod.name}" />&quot;,
                                        &quot;price&quot;:${prod.price},
                                        &quot;originalPrice&quot;:${prod.originalPrice},
                                        &quot;discount&quot;:${prod.discount},
                                        &quot;category&quot;:&quot;<c:out value="${prod.category}" />&quot;,
                                        &quot;type&quot;:&quot;<c:out value="${prod.type}" />&quot;,
                                        &quot;size&quot;:&quot;<c:out value="${prod.size}" />&quot;,
                                        &quot;color&quot;:&quot;<c:out value="${prod.color}" />&quot;,
                                        &quot;gender&quot;:&quot;<c:out value="${prod.gender}" />&quot;,
                                        &quot;rating&quot;:${prod.rating},
                                        &quot;reviews&quot;:${prod.reviews},
                                        &quot;brand&quot;:&quot;<c:out value="${prod.brand}" />&quot;,
                                        &quot;image&quot;:&quot;<c:out value="${prod.image}" />&quot;,
                                        &quot;stockQuantity&quot;:${prod.stockQuantity}
                                    }"
                                    onclick="openEditModalFromData(this)">Edit</button>
                            <form action="${ctx}/admin/products" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this product?');">
                                <input type="hidden" name="_csrf" value="${_csrf}" />
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="productId" value="${prod.id}">
                                <button type="submit" class="btn-delete">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Edit Modal Box -->
<div class="admin-modal" id="editModal">
    <div class="modal-content">
        <button class="modal-close" onclick="closeEditModal()">&times;</button>
        <h2 style="font-size: 16px; text-transform: uppercase; margin-bottom: 20px; border-bottom: 1px solid var(--border-color); padding-bottom: 10px;">Edit Product Info</h2>
        <form action="${ctx}/admin/products" method="post">
            <input type="hidden" name="_csrf" value="${_csrf}" />
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="productId" id="editProductId">
            
            <div class="form-grid">
                <div class="form-group">
                    <label>Product Name</label>
                    <input type="text" name="name" id="editName" required>
                </div>
                <div class="form-group">
                    <label>Fulfillment Price (₹)</label>
                    <input type="number" name="price" id="editPrice" required>
                </div>
                <div class="form-group">
                    <label>Original Price (₹)</label>
                    <input type="number" name="originalPrice" id="editOriginalPrice">
                </div>
                <div class="form-group">
                    <label>Discount Percentage (%)</label>
                    <input type="number" name="discount" id="editDiscount" value="0">
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <select name="category" id="editCategory" required>
                        <option value="Tops">Tops</option>
                        <option value="Bottoms">Bottoms</option>
                        <option value="Footwear">Footwear</option>
                        <option value="Accessories">Accessories</option>
                        <option value="Outerwear">Outerwear</option>
                        <option value="Sets">Sets</option>
                        <option value="Pants">Pants</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Apparel Type</label>
                    <input type="text" name="type" id="editType" required>
                </div>
                <div class="form-group">
                    <label>Sizes (Comma separated)</label>
                    <input type="text" name="size" id="editSize" required>
                </div>
                <div class="form-group">
                    <label>Colors (Comma separated)</label>
                    <input type="text" name="color" id="editColor" required>
                </div>
                <div class="form-group">
                    <label>Gender Targeting</label>
                    <select name="gender" id="editGender" required>
                        <option value="Unisex">Unisex</option>
                        <option value="Men">Men</option>
                        <option value="Women">Women</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Brand Name</label>
                    <input type="text" name="brand" id="editBrand" required>
                </div>
                <div class="form-group">
                    <label>Stock Quantity</label>
                    <input type="number" name="stockQuantity" id="editStockQuantity" min="0" required>
                </div>
                <div class="form-group">
                    <label>Image Asset Name / URL</label>
                    <input type="text" name="image" id="editImage" required>
                </div>
            </div>

            <button type="submit" class="btn-action btn-accent">Save Changes</button>
            <button type="button" class="btn-action" onclick="closeEditModal()" style="margin-left: 10px;">Cancel</button>
        </form>
    </div>
</div>

<script>
    function toggleAddForm() {
        const panel = document.getElementById("addProductPanel");
        if (panel.style.display === "block") {
            panel.style.display = "none";
        } else {
            panel.style.display = "block";
        }
    }

    function openEditModal(id, name, price, originalPrice, discount, category, type, size, color, gender, rating, reviews, brand, image, stockQuantity) {
        document.getElementById('editProductId').value = id;
        document.getElementById('editName').value = name;
        document.getElementById('editPrice').value = Math.round(price);
        document.getElementById('editOriginalPrice').value = Math.round(originalPrice);
        document.getElementById('editDiscount').value = discount;
        document.getElementById('editCategory').value = category;
        document.getElementById('editType').value = type;
        document.getElementById('editSize').value = size;
        document.getElementById('editColor').value = color;
        document.getElementById('editGender').value = gender;
        document.getElementById('editBrand').value = brand;
        document.getElementById('editImage').value = image;
        document.getElementById('editStockQuantity').value = stockQuantity;
        document.getElementById('editModal').style.display = 'flex';
    }

    /**
     * Safe edit-modal opener: reads product data from a data attribute
     * (HTML-escaped by c:out server-side) and parses it as JSON.
     * Never interpolates user-controlled text directly into JS string arguments.
     */
    function openEditModalFromData(btn) {
        const raw = btn.getAttribute('data-product-json');
        // The attribute value is HTML-encoded by JSP; decode it then parse JSON.
        const decoded = raw
            .replace(/&quot;/g, '"')
            .replace(/&amp;/g, '&')
            .replace(/&lt;/g,  '<')
            .replace(/&gt;/g,  '>');
        const p = JSON.parse(decoded);
        document.getElementById('editProductId').value    = p.id;
        document.getElementById('editName').value         = p.name;
        document.getElementById('editPrice').value        = Math.round(p.price);
        document.getElementById('editOriginalPrice').value= Math.round(p.originalPrice);
        document.getElementById('editDiscount').value     = p.discount;
        document.getElementById('editCategory').value     = p.category;
        document.getElementById('editType').value         = p.type;
        document.getElementById('editSize').value         = p.size;
        document.getElementById('editColor').value        = p.color;
        document.getElementById('editGender').value       = p.gender;
        document.getElementById('editBrand').value        = p.brand;
        document.getElementById('editImage').value        = p.image;
        document.getElementById('editStockQuantity').value= p.stockQuantity;
        document.getElementById('editModal').style.display = 'flex';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }
</script>

</body>
</html>
