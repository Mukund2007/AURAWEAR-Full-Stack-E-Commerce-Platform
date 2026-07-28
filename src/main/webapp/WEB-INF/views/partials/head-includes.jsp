<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- Google Analytics GA4 -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-EG16LNFXMK"></script>
<script>
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());
gtag('config', 'G-EG16LNFXMK');
</script>

<c:if test="${sessionScope.loginSuccess}">
    <script>
        gtag('event', 'login', { method: 'Email' });
    </script>
    <c:remove var="loginSuccess" scope="session" />
</c:if>
<c:if test="${sessionScope.registrationSuccess}">
    <script>
        gtag('event', 'sign_up', { method: 'Email' });
    </script>
    <c:remove var="registrationSuccess" scope="session" />
</c:if>

<!-- Global Resource Links -->
<link rel="stylesheet" href="${ctx}/assets/css/design-tokens.css?v=200">
<link rel="stylesheet" href="${ctx}/assets/css/navbar.css?v=200">
<link rel="stylesheet" href="${ctx}/assets/css/login-modal.css?v=200">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,100..1000;1,9..40,100..1000&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />

<script>
window._csrf = "${_csrf}";
window.ctx = "${ctx}";

function updateCartCount() {
    fetch("${ctx}/cart-count", { credentials: "include" })
        .then(res => res.text())
        .then(count => {
            const trimmed = count.trim();
            const value = (!isNaN(trimmed) && trimmed !== "") ? trimmed : "0";
            const badges = document.querySelectorAll(".cart-badge");
            badges.forEach(el => {
                el.innerText = value;
            });
        });
}

function openMenuOverlay() {
    const el = document.getElementById("menuOverlay");
    if (el) {
        el.classList.add("active");
        document.body.style.overflow = "hidden";
    }
}

function closeMenuOverlay() {
    const el = document.getElementById("menuOverlay");
    if (el) {
        el.classList.remove("active");
        document.body.style.overflow = "";
    }
}

function toggleMenuSearch() {
    const el = document.getElementById("menuSearchInline");
    if (el) {
        if (el.style.display === "none") {
            el.style.display = "flex";
            const input = el.querySelector("input");
            if (input) input.focus();
        } else {
            el.style.display = "none";
        }
    }
}




function initAuraInteractive() {
    // ── Update Cart Count
    updateCartCount();

    // ── Scroll Reveal Intersection Observer Setup
    const revealObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add("reveal-active");
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1,
        rootMargin: "0px 0px -40px 0px"
    });

    const setupScrollObserver = () => {
        const elms = document.querySelectorAll("[data-scroll-reveal]:not(.observed)");
        elms.forEach(el => {
            el.classList.add("observed");
            revealObserver.observe(el);
        });
    };
    setupScrollObserver();

    // ── Typographical Entrance Reveal
    setTimeout(() => {
        const firstFoldElements = document.querySelectorAll(
            ".hero [data-scroll-reveal], .cat-panels [data-scroll-reveal], .statement [data-scroll-reveal]"
        );
        firstFoldElements.forEach(el => {
            el.classList.add("reveal-active");
        });
    }, 0);

    // Re-bind scroll reveal for dynamically parsed elements
    const scrollMutationObserver = new MutationObserver(setupScrollObserver);
    scrollMutationObserver.observe(document.body, { childList: true, subtree: true });
}

if (document.readyState === "loading") {
    window.addEventListener("DOMContentLoaded", initAuraInteractive);
} else {
    initAuraInteractive();
}

// ── SIZE GUIDE MODAL FUNCTIONS ───────────────────────────
function openSizeGuide() {
    const el = document.getElementById("sizeOverlay");
    if (el) {
        el.classList.add("active");
        document.body.style.overflow = "hidden";
    }
}

function closeSizeGuide(e) {
    if (e && e.target !== document.getElementById("sizeOverlay")) return;
    const el = document.getElementById("sizeOverlay");
    if (el) {
        el.classList.remove("active");
        document.body.style.overflow = "";
    }
}

function switchSizeTab(tabId, btn) {
    if (btn) {
        const buttons = btn.parentElement.querySelectorAll('.size-tab-btn');
        buttons.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
    }
    
    const contents = document.querySelectorAll('.size-tab-content');
    contents.forEach(c => c.classList.remove('active'));
    
    const activeContent = document.getElementById('tab-' + tabId);
    if (activeContent) {
        activeContent.classList.add('active');
    }
}

document.addEventListener("keydown", function(e) {
    if (e.key === "Escape") {
        const sizeOverlay = document.getElementById("sizeOverlay");
        if (sizeOverlay && sizeOverlay.classList.contains("active")) {
            sizeOverlay.classList.remove("active");
            document.body.style.overflow = "";
        }
    }
});

// ── DYNAMIC GLOBAL FAVICON INJECTION ──────────────────────────
(function() {
    let link = document.querySelector("link[rel*='icon']");
    if (!link) {
        link = document.createElement('link');
        link.rel = 'icon';
        document.head.appendChild(link);
    }
    link.type = 'image/svg+xml';
    link.href = 'data:image/svg+xml;utf8,%3Csvg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32"%3E%3Ccircle cx="16" cy="16" r="16" fill="%23000000"/%3E%3Ctext x="50%" y="58%" dominant-baseline="middle" text-anchor="middle" font-family="%27DM Sans%27, sans-serif" font-weight="900" font-size="12" fill="%23F7F2EC" letter-spacing="-0.5"%3EAW%3C/text%3E%3C/svg%3E';
})();

// ── LOGIN MODAL FUNCTIONS ─────────────────────────────────────
function openLoginModal() {
    const overlay = document.getElementById("loginOverlay");
    if (overlay) {
        overlay.classList.add("active");
        document.body.style.overflow = "hidden";
        setTimeout(() => {
            const inp = document.querySelector("#loginModal input[type='email']");
            if (inp) inp.focus();
        }, 300);
    }
}
function closeLoginModal(e) {
    const overlay = document.getElementById("loginOverlay");
    if (overlay) {
        if (e && e.target !== overlay) return;
        overlay.classList.remove("active");
        document.body.style.overflow = "";
    }
}
document.addEventListener("keydown", function(e) {
    if (e.key === "Escape") {
        const overlay = document.getElementById("loginOverlay");
        if (overlay) {
            overlay.classList.remove("active");
            document.body.style.overflow = "";
        }
    }
});
document.addEventListener("DOMContentLoaded", function() {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('login') || urlParams.has('loginError')) {
        openLoginModal();
    }
});
</script>
