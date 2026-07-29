<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../partials/head-includes.jsp" />
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Account — AuraWear</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/home.css?v=300">
    <link rel="stylesheet" href="${ctx}/assets/css/profile.css?v=300">

</head>
<body>

    <jsp:include page="../partials/navbar.jsp" />

    <div class="profile-page-wrap">

        <!-- HERO BANNER -->
        <section class="profile-hero">
            <div class="profile-hero-left">
                <h1>
                    Hello,
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}"><c:out value="${sessionScope.user.name}" /></c:when>
                        <c:otherwise>Guest</c:otherwise>
                    </c:choose>
                </h1>
                <p>Manage your AuraWear account</p>
            </div>

            <div class="profile-avatar">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:out value="${fn:substring(sessionScope.user.name, 0, 1)}" />
                    </c:when>
                    <c:otherwise>
                        <i class="fa fa-user"></i>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- DASHBOARD GRID -->
        <section class="dashboard-grid">

            <a href="${ctx}/my-orders" class="dashboard-card">
                <div class="card-icon">
                    <i class="fa-solid fa-bag-shopping"></i>
                </div>
                <div class="card-text">
                    <h3>My Orders</h3>
                    <p>Track, return or buy again</p>
                </div>
            </a>

            <a href="${ctx}/wishlist" class="dashboard-card">
                <div class="card-icon">
                    <i class="fa-solid fa-heart"></i>
                </div>
                <div class="card-text">
                    <h3>Wishlist</h3>
                    <p>Items you've saved for later</p>
                </div>
            </a>



            <a href="${ctx}/logout" class="dashboard-card logout-card">
                <div class="card-icon">
                    <i class="fa-solid fa-right-from-bracket"></i>
                </div>
                <div class="card-text">
                    <h3>Logout</h3>
                    <p>Sign out of your account</p>
                </div>
            </a>

        </section>

    </div>


    <script>
        window.addEventListener('scroll', function () {
            const nav = document.querySelector('.navbar');
            if (nav) nav.classList.toggle('scrolled', window.scrollY > 80);
        });
    </script>

</body>
</html>
