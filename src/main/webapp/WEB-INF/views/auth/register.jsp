<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Create Account — AuraWear</title>
    
    <!-- Google Analytics GA4 -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-EG16LNFXMK"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'G-EG16LNFXMK');
    </script>

    
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/design-tokens.css?v=300">
    <link rel="stylesheet" href="${ctx}/assets/css/auth-theme.css">

</head>
<body class="auth-page">

    <!-- Top Bar / Brand Anchor -->
    <header class="auth-header">
        <div class="auth-header-inner">
            <a class="auth-header-brand" href="${ctx}/home">
                AuraWear
            </a>
            <div class="auth-header-actions">
                <a class="auth-header-link" href="${ctx}/home?login=true">Login</a>
            </div>
        </div>
    </header>

    <!-- Main Content Canvas -->
    <main class="auth-main">
        <div class="auth-form-container">
        
            <!-- Heading & Step Indicator -->
            <div class="auth-form-heading">
                <h1 class="auth-heading">Create Account</h1>
                
                <!-- Step Indicator -->
                <nav class="auth-step-indicator">
                    <div class="auth-step">
                        <span class="auth-step-dot ${not empty showOtp ? '' : 'active'}"></span>
                        <span class="auth-step-label ${not empty showOtp ? '' : 'active'}">ACCOUNT</span>
                    </div>
                    <div class="auth-step-connector"></div>
                    <div class="auth-step">
                        <span class="auth-step-dot ${not empty showOtp ? 'active' : ''}"></span>
                        <span class="auth-step-label ${not empty showOtp ? 'active' : ''}">VERIFY</span>
                    </div>
                </nav>
            </div>

            <!-- STEP 1: Registration Form -->
            <div id="step1" ${not empty showOtp ? 'style="display:none"' : ''}>
                
                <c:if test="${not empty emailError}">
                    <div class="auth-error">
                        <c:out value="${emailError}" />
                    </div>
                </c:if>
                
                <form class="auth-form" id="registrationForm" action="${ctx}/register" method="post" onsubmit="return checkPasswords()">
                    <input type="hidden" name="_csrf" value="${_csrf}" />
                    <!-- Personal Info Row -->
                    <div class="auth-row">
                        <div class="auth-field">
                            <label class="auth-label" for="firstName">FIRST NAME</label>
                            <input class="auth-input" id="firstName" name="firstName" required="" type="text"/>
                        </div>
                        <div class="auth-field">
                            <label class="auth-label" for="lastName">LAST NAME</label>
                            <input class="auth-input" id="lastName" name="lastName" required="" type="text"/>
                        </div>
                    </div>
                    
                    <!-- Credential Fields -->
                    <div style="display: contents;">
                        <div class="auth-field">
                            <label class="auth-label" for="email">EMAIL ADDRESS</label>
                            <input class="auth-input" id="email" name="email" required="" type="email"/>
                        </div>
                        <div class="auth-field">
                            <label class="auth-label" for="username">USERNAME</label>
                            <input class="auth-input" id="username" name="username" required="" type="text"/>
                        </div>
                        <div class="auth-row">
                            <div class="auth-field">
                                <label class="auth-label" for="password">PASSWORD</label>
                                <input class="auth-input" id="password" name="password" required="" type="password"/>
                            </div>
                            <div class="auth-field">
                                <label class="auth-label" for="confirmPassword">CONFIRM PASSWORD</label>
                                <input class="auth-input" id="confirmPassword" name="confirmPassword" required="" type="password"/>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Interests Section -->
                    <div class="auth-field">
                        <h3 class="interests-label">INTERESTS</h3>
                        <div class="auth-interest-wrap">
                            <div class="otp-box-wrapper">
                                <input class="interest-chip sr-only" id="streetwear" name="interests" type="checkbox" value="Streetwear"/>
                                <label class="auth-interest-label" for="streetwear">Streetwear</label>
                            </div>
                            <div class="otp-box-wrapper">
                                <input class="interest-chip sr-only" id="accessories" name="interests" type="checkbox" value="Accessories"/>
                                <label class="auth-interest-label" for="accessories">Accessories</label>
                            </div>
                            <div class="otp-box-wrapper">
                                <input class="interest-chip sr-only" id="outerwear" name="interests" type="checkbox" value="Outerwear"/>
                                <label class="auth-interest-label" for="outerwear">Outerwear</label>
                            </div>
                            <div class="otp-box-wrapper">
                                <input class="interest-chip sr-only" id="footwear" name="interests" type="checkbox" value="Footwear"/>
                                <label class="auth-interest-label" for="footwear">Footwear</label>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Terms & Actions -->
                    <div style="display: contents;">
                        <div class="auth-terms">
                            <input id="terms" name="terms" required="" type="checkbox"/>
                            <label class="auth-terms-label" for="terms">
                                I agree to the <a class="auth-terms-link" href="#">Terms &amp; Privacy Policy</a>.
                            </label>
                        </div>
                        
                        <div class="auth-pass-error" id="passError">
                            Passwords do not match!
                        </div>
                        
                        <button class="auth-btn" type="submit">
                            Create Account
                        </button>
                        <div class="auth-signin-link">
                            <p>
                                Already have an account? <a href="${ctx}/home?login=true">Sign In</a>
                            </p>
                        </div>
                    </div>
                </form>
            </div>

            <!-- STEP 2: Verification Form -->
            <div id="step2" ${empty showOtp ? 'style="display:none"' : ''}>
                
                <c:if test="${not empty otpError}">
                    <div class="auth-error">
                        <c:out value="${otpError}" />
                    </div>
                </c:if>
                
                <form class="auth-form" id="otpForm" action="${ctx}/otp-verify" method="post">
                    <input type="hidden" name="_csrf" value="${_csrf}" />
                    <input type="hidden" name="otp" id="fullOtp">

                    <p class="auth-sub" style="text-align:center;">
                        Enter the 6-digit code sent to your email.
                    </p>

                    <div class="otp-boxes">
                        <input maxlength="1" inputmode="numeric" class="auth-otp-input"/>
                        <input maxlength="1" inputmode="numeric" class="auth-otp-input"/>
                        <input maxlength="1" inputmode="numeric" class="auth-otp-input"/>
                        <input maxlength="1" inputmode="numeric" class="auth-otp-input"/>
                        <input maxlength="1" inputmode="numeric" class="auth-otp-input"/>
                        <input maxlength="1" inputmode="numeric" class="auth-otp-input"/>
                    </div>

                    <div class="otp-resend">
                        Resend code in <span id="timer" class="otp-timer">30</span>s
                    </div>

                    <button id="resendBtn" class="auth-btn auth-btn-outline" type="button" onclick="window.location='${ctx}/register?resend=true'" style="display:none;">
                        Resend Code
                    </button>

                    <button id="verifyBtn" class="auth-btn" type="submit" disabled>
                        Verify Email
                    </button>
                </form>
            </div>

        </div>
    </main>

    <!-- ══ FOOTER ═══════════════════════════════════════════ -->
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

    <script>
    // OTP navigation
    const otpInputs = document.querySelectorAll('.otp-boxes input');
    otpInputs.forEach((input, i) => {
        input.addEventListener('input', function () {
            if (this.value.length === 1 && i < otpInputs.length - 1)
                otpInputs[i + 1].focus();
            updateOtp();
        });
        input.addEventListener('keydown', function (e) {
            if (e.key === "Backspace" && !this.value && i > 0)
                otpInputs[i - 1].focus();
        });
    });

    function updateOtp() {
        let code = "";
        otpInputs.forEach(b => code += b.value);
        document.getElementById("fullOtp").value = code;
        document.getElementById("verifyBtn").disabled = code.length !== 6;
    }

    document.getElementById("otpForm")?.addEventListener("submit", updateOtp);

    // Countdown
    let seconds = 30;
    const timerEl = document.getElementById("timer");
    if (timerEl) {
        let countdown = setInterval(() => {
            seconds--;
            timerEl.innerText = seconds;
            if (seconds <= 0) {
                clearInterval(countdown);
                document.querySelector(".otp-resend").style.display = "none";
                document.getElementById("resendBtn").style.display = "block";
            }
        }, 1000);
    }

    // Password validation
    function checkPasswords() {
        const pass    = document.getElementById("password").value;
        const confirm = document.getElementById("confirmPassword").value;
        const errEl   = document.getElementById("passError");

        if (pass.length < 8) {
            errEl.innerText = "Password must be at least 8 characters!";
            errEl.style.display = "block";
            return false;
        }

        if (pass !== confirm) {
            errEl.innerText = "Passwords do not match!";
            errEl.style.display = "block";
            document.getElementById("confirmPassword").style.borderColor = "var(--error-color)";
            return false;
        }

        errEl.style.display = "none";
        return true;
    }

    // Hover effect for labels linked to inputs
    const inputs = document.querySelectorAll('input:not([type="checkbox"])');
    inputs.forEach(input => {
        input.addEventListener('focus', () => {
            const label = input.previousElementSibling;
            if(label && label.tagName === 'LABEL') {
                label.style.color = 'var(--primary-text)';
            }
        });
        input.addEventListener('blur', () => {
            const label = input.previousElementSibling;
            if(label && label.tagName === 'LABEL') {
                label.style.color = '';
            }
        });
    });
    </script>
</body>
</html>
