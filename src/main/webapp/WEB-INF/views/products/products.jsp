<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false"%>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../partials/head-includes.jsp" />
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${not empty param.gender}"><c:out value="${param.gender}"/>'s Collection</c:when>
            <c:when test="${not empty param.category}"><c:out value="${param.category}"/>s</c:when>
            <c:when test="${not empty param.keyword}">"<c:out value='${param.keyword}'/>"</c:when>
            <c:otherwise>All Products</c:otherwise>
        </c:choose>
        — AuraWear
    </title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/home.css?v=200">
    <link class="products-style" rel="stylesheet" href="${ctx}/assets/css/products.css?v=200">

</head>
<body class="products-page">

    <jsp:include page="../partials/navbar.jsp" />

    <!-- ══ BREADCRUMB ════════════════════════════════════════ -->
    <div class="breadcrumb-nav">
        <div class="breadcrumb-container">
            <a href="${ctx}/home">Home</a>
            <span class="sep">/</span>
            <c:choose>
                <c:when test="${not empty param.gender}"><c:out value="${param.gender}"/></c:when>
                <c:when test="${not empty param.category}"><c:out value="${param.category}"/></c:when>
                <c:when test="${not empty param.keyword}">Search: "<c:out value='${param.keyword}'/>"</c:when>
                <c:otherwise>All Products</c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- ══ PAGE HEADER ══════════════════════════════════════ -->
    <header class="products-header">
        <h1 class="page-title">
            <c:choose>
                <c:when test="${not empty param.category}"><c:out value="${param.category}"/>s</c:when>
                <c:when test="${not empty param.gender}"><c:out value="${param.gender}"/>'s Collection</c:when>
                <c:when test="${not empty param.keyword}">"<c:out value='${param.keyword}'/>"</c:when>
                <c:otherwise>The Archive</c:otherwise>
            </c:choose>
        </h1>
        <p class="page-subtitle">
            <c:choose>
                <c:when test="${not empty param.category}">Curated <c:out value="${fn:toLowerCase(param.category)}"/> apparel designed for longevity, precision, and architectural balance.</c:when>
                <c:when test="${not empty param.gender}">Curated technical apparel for <c:out value="${fn:toLowerCase(param.gender)}"/>, designed for longevity, precision, and architectural balance.</c:when>
                <c:otherwise>Curated technical apparel designed for longevity, precision, and architectural balance. Every piece is a testament to restrained luxury.</c:otherwise>
            </c:choose>
        </p>
    </header>

    <!-- ══ STICKY FILTER & SORT BAR ═════════════════════════ -->
    <form id="filterForm" method="get" action="${ctx}/products">
        <input type="hidden" name="sort" id="sortHidden" value="${fn:escapeXml(param.sort)}">
        <input type="hidden" name="keyword" value="${fn:escapeXml(param.keyword)}">

        <section class="sticky-filter-bar">
            <div class="filter-groups">
                <!-- Dropdown: Category -->
                <div class="filter-dropdown">
                    <button type="button" class="filter-dropdown-btn">
                        <span>Category</span>
                        <span class="material-symbols-outlined dropdown-chevron">expand_more</span>
                    </button>
                    <div class="dropdown-content">
                        <label><input type="checkbox" name="category" value="Tops"> Tops</label>
                        <label><input type="checkbox" name="category" value="Bottoms"> Bottoms</label>
                        <label><input type="checkbox" name="category" value="Pants"> Pants</label>
                        <label><input type="checkbox" name="category" value="Sets"> Sets</label>
                        <label><input type="checkbox" name="category" value="Outerwear"> Outerwear</label>
                        <label><input type="checkbox" name="category" value="Footwear"> Footwear</label>
                        <label><input type="checkbox" name="category" value="Accessories"> Accessories</label>
                    </div>
                </div>

                <!-- Dropdown: Gender -->
                <div class="filter-dropdown">
                    <button type="button" class="filter-dropdown-btn">
                        <span>Gender</span>
                        <span class="material-symbols-outlined dropdown-chevron">expand_more</span>
                    </button>
                    <div class="dropdown-content">
                        <label><input type="radio" name="gender" value="Men"> Men</label>
                        <label><input type="radio" name="gender" value="Women"> Women</label>
                        <label><input type="radio" name="gender" value="" ${empty param.gender ? 'checked' : ''}> All Genders</label>
                    </div>
                </div>

                <!-- Dropdown: Size -->
                <div class="filter-dropdown">
                    <button type="button" class="filter-dropdown-btn">
                        <span>Size</span>
                        <span class="material-symbols-outlined dropdown-chevron">expand_more</span>
                    </button>
                    <div class="dropdown-content">
                        <label><input type="checkbox" name="size" value="S"> S</label>
                        <label><input type="checkbox" name="size" value="M"> M</label>
                        <label><input type="checkbox" name="size" value="L"> L</label>
                        <label><input type="checkbox" name="size" value="XL"> XL</label>
                    </div>
                </div>

                <!-- Dropdown: Color -->
                <div class="filter-dropdown">
                    <button type="button" class="filter-dropdown-btn">
                        <span>Color</span>
                        <span class="material-symbols-outlined dropdown-chevron">expand_more</span>
                    </button>
                    <div class="dropdown-content">
                        <label><input type="checkbox" name="color" value="Black"> Black</label>
                        <label><input type="checkbox" name="color" value="White"> White</label>
                        <label><input type="checkbox" name="color" value="Grey"> Grey</label>
                        <label><input type="checkbox" name="color" value="Beige"> Beige</label>
                        <label><input type="checkbox" name="color" value="Navy"> Navy</label>
                        <label><input type="checkbox" name="color" value="Brown"> Brown</label>
                        <label><input type="checkbox" name="color" value="Olive"> Olive</label>
                        <label><input type="checkbox" name="color" value="Blue"> Blue</label>
                        <label><input type="checkbox" name="color" value="Pink"> Pink</label>
                    </div>
                </div>

                <!-- Dropdown: Price -->
                <div class="filter-dropdown">
                    <button type="button" class="filter-dropdown-btn">
                        <span>Price</span>
                        <span class="material-symbols-outlined dropdown-chevron">expand_more</span>
                    </button>
                    <div class="dropdown-content price-dropdown-content">
                        <div class="price-slider">
                           <div class="slider-track"></div>
                           <input type="range" id="minRange" name="minPrice" min="0" max="10000" step="100" value="0">
                           <input type="range" id="maxRange" name="maxPrice" min="0" max="10000" step="100" value="10000">
                        </div>
                        <div class="price-label" id="priceLabel">₹0 – ₹10,000+</div>
                    </div>
                </div>
            </div>

            <div class="filter-actions-right">
                <span class="products-count-label"><span id="productsCount">${fn:length(products)}</span> Products Found</span>
                <div class="filter-dropdown sort-dropdown">
                    <button type="button" class="filter-dropdown-btn sort-btn">
                        <span>Sort By</span>
                        <span class="material-symbols-outlined dropdown-chevron">expand_more</span>
                    </button>
                    <div class="dropdown-content sort-dropdown-content">
                        <div class="sort-option ${empty param.sort ? 'selected' : ''}" data-value="" onclick="selectSortOption(this)">Sort By</div>
                        <div class="sort-option ${param.sort == 'priceHigh' ? 'selected' : ''}" data-value="priceHigh" onclick="selectSortOption(this)">Price: High → Low</div>
                        <div class="sort-option ${param.sort == 'priceLow' ? 'selected' : ''}" data-value="priceLow" onclick="selectSortOption(this)">Price: Low → High</div>
                        <div class="sort-option ${param.sort == 'rating' ? 'selected' : ''}" data-value="rating" onclick="selectSortOption(this)">Top Rated</div>
                        <div class="sort-option ${param.sort == 'newest' ? 'selected' : ''}" data-value="newest" onclick="selectSortOption(this)">Newest</div>
                    </div>
                </div>
            </div>
        </section>
    </form>

    <!-- ══ MAIN PRODUCTS CONTAINER ══════════════════════════ -->
    <main class="page-wrap">
        <!-- Active Filter Chips -->
        <div id="activeFilters" class="active-filters"></div>

        <!-- Product Grid -->
        <div class="product-grid">
            <jsp:include page="grid.jsp" />
        </div>


    </main>

    <!-- TOAST NOTIFICATION -->
    <div id="toast" class="toast-msg"></div>

    <script>
    const ctx = "${ctx}";

    function submitForm() {
        const form = document.getElementById("filterForm");
        const formData = new FormData(form);
        const params = new URLSearchParams();
        
        for (const [key, val] of formData.entries()) {
            if (val) params.append(key, val);
        }
        
        const url = ctx + "/products?" + params.toString();
        
        // update address bar
        window.history.pushState({}, "", url);
        
        // Update slider UI and chips locally
        updateSlider();
        renderChips();
        
        const grid = document.querySelector(".product-grid");
        if (grid) grid.style.opacity = "0.5";
        
        fetch(url, {
            headers: {
                "X-Requested-With": "XMLHttpRequest"
            }
        })
        .then(res => {
            if (!res.ok) throw new Error("Filter request failed");
            return res.text();
        })
        .then(html => {
            if (grid) {
                grid.innerHTML = html;
                grid.style.opacity = "1";
                
                // Update product count label
                const count = grid.querySelectorAll(".product-card").length;
                const countEl = document.getElementById("productsCount");
                if (countEl) countEl.innerText = count;
                
                // Re-init interactions
                if (typeof init3DTilt === "function") init3DTilt();
                if (typeof initDragToCart === "function") initDragToCart();
            }
        })
        .catch(err => {
            console.warn("AJAX filter failed, falling back to page reload:", err);
            form.submit();
        });
    }

    function selectSortOption(el) {
        const value = el.getAttribute("data-value");
        document.getElementById("sortHidden").value = value;
        
        document.querySelectorAll(".sort-option").forEach(opt => {
            opt.classList.toggle("selected", opt === el);
        });
        
        const btnText = el.textContent;
        document.querySelector(".sort-btn span").textContent = btnText;
        
        submitForm();
    }

    function goToProduct(id) {
        const card = document.querySelector(`.product-card[data-id="${id}"]`);
        if (card && card.classList.contains('oos-card')) {
            return;
        }
        window.location.href = ctx + "/product?id=" + id;
    }

    /* ── QUICK ADD ────────── */
    function quickAdd(e) {
        e.stopPropagation();
        const btn = e.currentTarget;
        const id = btn.getAttribute("data-id");
        const size = btn.getAttribute("data-size");
        const price = btn.getAttribute("data-price");
        btn.disabled  = true;
        btn.innerText = "Adding...";

        fetch(ctx + "/add-to-cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "X-CSRF-Token": window._csrf
            },
            body: "id=" + encodeURIComponent(id) + "&size=" + encodeURIComponent(size) + "&price=" + encodeURIComponent(price),
            credentials: "include"
        })
            .then(res => {
                if (res.status === 401) {
                    window.location.href = ctx + "/login";
                    return;
                }
                if (!res.ok) throw new Error("Failed");
                return res.json();
            })
            .then(data => {
                if (!data) return;
                if (data.success) {
                    btn.innerText = "Added ✓";
                    const pName = btn.closest(".product-card").querySelector(".product-title-text").innerText;
                    showToast(pName + " added to cart!");
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
                                item_size: size
                            }]
                        });
                    }
                } else {
                    btn.innerText = "Out of Stock";
                    showToast(data.message || "This item is out of stock");
                }
                setTimeout(() => {
                    btn.innerText = data.success ? "Quick Add" : "Out of Stock";
                    btn.disabled  = !data.success;
                }, 1400);
            })
            .catch(() => {
                btn.innerText = "Quick Add";
                btn.disabled  = false;
                showToast("Could not add to cart. Try again.");
            });
    }

    /* ── WISHLIST TOGGLE ──────────────────────────────────── */
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
            if (res.status === 401) {
                window.location.href = ctx + "/login";
                return res.text();
            }
            if (!res.ok) throw new Error("Server error");
            return res.text();
        })
        .then(status => {
            if (!status) return;
            if (status.trim() === "added") {
                el.classList.add("active");
                showToast("Added to wishlist ♡");
            } else {
                el.classList.remove("active");
                showToast("Removed from wishlist");
            }
        })
        .catch(() => {
            showToast("Could not update wishlist. Try again.");
        });
    }

    /* ── CART COUNT ─────────────────────────────────────── */
    function updateCartCount() {
        fetch(ctx + "/cart-count", { credentials: "include" })
            .then(res => res.text())
            .then(count => {
                const el = document.getElementById("cart-count");
                if (el) el.innerText = count;
            });
    }

    /* ── TOAST ──────────────────────────────────────────── */
    function showToast(msg) {
        const toast = document.getElementById("toast");
        toast.innerText = msg;
        toast.classList.add("show");
        setTimeout(() => toast.classList.remove("show"), 2400);
    }

    function restoreFiltersFromURL() {
        const params = new URLSearchParams(window.location.search);
        
        // checkboxes
        document.querySelectorAll("#filterForm input[type='checkbox']").forEach(input => {
            input.checked = params.getAll(input.name).includes(input.value);
        });
        
        // gender radio
        const gender = params.get("gender");
        if (gender) {
            const radio = document.querySelector("input[name='gender'][value='" + gender + "']");
            if (radio) radio.checked = true;
        } else {
            const radioAll = document.querySelector("input[name='gender'][value='']");
            if (radioAll) radioAll.checked = true;
        }
        
        // ranges
        const min = params.get("minPrice");
        const max = params.get("maxPrice");
        if (min) document.getElementById("minRange").value = min;
        if (max) document.getElementById("maxRange").value = max;
        
        // custom sort dropdown selection
        const sort = params.get("sort");
        if (sort) {
            const opt = document.querySelector(`.sort-option[data-value='${sort}']`);
            if (opt) {
                document.querySelectorAll(".sort-option").forEach(o => o.classList.remove("selected"));
                opt.classList.add("selected");
                document.querySelector(".sort-btn span").textContent = opt.textContent;
            }
        } else {
            const optDefault = document.querySelector(".sort-option[data-value='']");
            if (optDefault) {
                document.querySelectorAll(".sort-option").forEach(o => o.classList.remove("selected"));
                optDefault.classList.add("selected");
                document.querySelector(".sort-btn span").textContent = "Sort By";
            }
        }
        updateSlider();
    }

    function renderChips() {
        const container = document.getElementById("activeFilters");
        if (!container) return;
        container.innerHTML = "";
        const params = new URLSearchParams(window.location.search);
        
        ["category", "size", "color", "gender"].forEach(key => {
            params.getAll(key).forEach(value => {
                if (!value) return;
                container.appendChild(makeChip(value, () => {
                    const url     = new URL(window.location);
                    const updated = url.searchParams.getAll(key).filter(v => v !== value);
                    url.searchParams.delete(key);
                    updated.forEach(v => url.searchParams.append(key, v));
                    window.location.href = url.toString();
                }));
            });
        });
        
        const min = params.get("minPrice");
        const max = params.get("maxPrice");
        if ((min && min !== "0") || (max && max !== "10000")) {
            container.appendChild(makeChip("₹" + (min || 0) + " – ₹" + (max || "∞"), () => {
                const url = new URL(window.location);
                url.searchParams.delete("minPrice");
                url.searchParams.delete("maxPrice");
                window.location.href = url.toString();
            }));
        }
        
        const keyword = params.get("keyword");
        if (keyword) {
            container.appendChild(makeChip('"' + keyword + '"', () => {
                const url = new URL(window.location);
                url.searchParams.delete("keyword");
                window.location.href = url.toString();
            }));
        }
    }

    function makeChip(label, onClose) {
        const chip  = document.createElement("div");
        chip.className = "filter-chip";
        const text  = document.createElement("span");
        text.textContent = label;
        const close = document.createElement("span");
        close.className  = "chip-close";
        close.textContent = "×";
        close.onclick = (e) => { e.stopPropagation(); onClose(); };
        chip.appendChild(text);
        chip.appendChild(close);
        return chip;
    }

    /* ── PRICE SLIDER ───────────────────────────────────── */
    const minRange   = document.getElementById("minRange");
    const maxRange   = document.getElementById("maxRange");
    const priceLabel = document.getElementById("priceLabel");
    const track      = document.querySelector(".slider-track");

    function updateSlider() {
        if (!minRange || !maxRange) return;
        let min = parseInt(minRange.value);
        let max = parseInt(maxRange.value);
        if (min > max - 100) { min = max - 100; minRange.value = min; }
        if (max < min + 100) { max = min + 100; maxRange.value = max; }
        priceLabel.innerText = "₹" + min.toLocaleString("en-IN") + " – ₹" + max.toLocaleString("en-IN") + (max >= 10000 ? "+" : "");
        const pMin = (min / 10000) * 100;
        const pMax = (max / 10000) * 100;
        if (track) {
            track.style.background = `linear-gradient(to right, var(--border-color) ${pMin}%, var(--accent-color) ${pMin}%, var(--accent-color) ${pMax}%, var(--border-color) ${pMax}%)`;
        }
    }



    minRange?.addEventListener("input",  updateSlider);
    maxRange?.addEventListener("input",  updateSlider);
    minRange?.addEventListener("change", submitForm);
    maxRange?.addEventListener("change", submitForm);

    /* ── INIT ───────────────────────────────────────────── */
    document.addEventListener("DOMContentLoaded", () => {
        // Submit on form inputs change
        document.querySelectorAll("#filterForm input[type='checkbox'], #filterForm input[type='radio']")
            .forEach(input => input.addEventListener("change", submitForm));
            
        // Dropdown toggle listeners for touch/click (primarily mobile)
        document.querySelectorAll('.filter-dropdown-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const dropdown = btn.closest('.filter-dropdown');
                const isOpen = dropdown.classList.toggle('open');
                
                document.querySelectorAll('.filter-dropdown').forEach(d => {
                    if (d !== dropdown) d.classList.remove('open');
                });
                
                const icon = btn.querySelector('.dropdown-chevron');
                if (icon) {
                    icon.textContent = isOpen ? 'expand_less' : 'expand_more';
                }
            });
        });

        // Close dropdowns on outside clicks
        document.addEventListener('click', () => {
            document.querySelectorAll('.filter-dropdown').forEach(d => {
                d.classList.remove('open');
                const icon = d.querySelector('.dropdown-chevron');
                if (icon) icon.textContent = 'expand_more';
            });
        });

        // Prevent dropdowns closing when clicking inside
        document.querySelectorAll('.dropdown-content').forEach(content => {
            content.addEventListener('click', (e) => {
                e.stopPropagation();
            });
        });

        restoreFiltersFromURL();
        renderChips();
        updateCartCount();
    });

    window.showToast = showToast;
    </script>
    <script src="${ctx}/assets/js/app-interactions.js?v=11"></script>

    <c:if test="${not empty keyword}">
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                if (typeof gtag === 'function') {
                    gtag('event', 'search', {
                        search_term: '${fn:escapeXml(keyword)}'
                    });
                }
            });
        </script>
    </c:if>

</body>
</html>
