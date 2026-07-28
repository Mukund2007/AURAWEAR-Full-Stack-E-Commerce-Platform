<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="login-overlay" id="loginOverlay" onclick="closeLoginModal(event)">
    <div class="login-modal" id="loginModal">

        <button class="modal-close" onclick="closeLoginModal()">
            <i class="fa-solid fa-xmark"></i>
        </button>

        <div class="modal-brand">
            <span class="modal-brand-logo">AW</span>
            <div>
                <div class="modal-brand-name">AURAWEAR</div>
                <div class="modal-brand-sub">WEAR YOUR AURA</div>
            </div>
        </div>

        <h2 class="modal-title">Sign In</h2>
        <p class="modal-sub">Sign in to your account</p>

        <div class="modal-error" id="modalError" <c:if test="${empty param.loginError}">style="display:none;"</c:if>>
            <c:choose>
                <c:when test="${param.loginError == 'unverified'}">
                    Please verify your account first.
                </c:when>
                <c:when test="${not empty param.loginError}">
                    Invalid email or password.
                </c:when>
            </c:choose>
        </div>

        <form action="${ctx}/login" method="post">
            <div class="modal-field">
                <label>Email</label>
                <input type="email" name="email" placeholder="your@email.com" required autocomplete="email">
            </div>
            <div class="modal-field">
                <label>Password</label>
                <input type="password" name="password" placeholder="••••••••" required autocomplete="current-password">
                <a href="#" class="modal-forgot">Forgot password?</a>
            </div>
            <button type="submit" class="modal-signin-btn">Sign In</button>
        </form>

        <div class="modal-divider"><span>or</span></div>

        <div class="modal-register-cta">
            Not a member? <a href="${ctx}/register">Create Account &rarr;</a>
        </div>

    </div>
</div>
