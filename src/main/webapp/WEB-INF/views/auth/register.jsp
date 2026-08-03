<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%-- Cache bust: v200 --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html class="light" lang="en">
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

    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            display: inline-block;
            vertical-align: middle;
        }
        .interest-chip:checked + label {
            background-color: var(--primary-brand);
            color: var(--bg-color);
            border-color: var(--primary-brand);
        }
        input:focus {
            outline: none !important;
            border-color: var(--primary-brand) !important;
            box-shadow: none !important;
        }
        ::-webkit-scrollbar {
            width: 4px;
        }
        ::-webkit-scrollbar-track {
            background: transparent;
        }
        ::-webkit-scrollbar-thumb {
            background: var(--border-color);
        }
    </style>
</head>
<body class="bg-background text-on-background font-body-md min-h-screen flex flex-col selection:bg-secondary-container">

    <!-- Top Bar / Brand Anchor -->
    <header class="w-full top-0 sticky bg-background border-b border-outline-variant/30 z-50">
        <div class="flex justify-between items-center w-full px-margin-mobile desktop:px-margin-desktop py-6 max-w-container-max mx-auto">
            <a class="text-headline-sm font-headline-sm font-bold tracking-tight text-on-background" href="${ctx}/home">
                AuraWear
            </a>
            <div class="flex items-center gap-stack-md">
                <a class="font-label-md text-label-md text-on-surface-variant hover:text-primary transition-colors" href="${ctx}/home?login=true">Login</a>
            </div>
        </div>
    </header>

    <!-- Main Content Canvas -->
    <main class="flex-grow flex items-center justify-center py-section-gap-mobile desktop:py-section-gap px-margin-mobile bg-background">
        <div class="w-full max-w-[520px] mx-auto font-body-md">
        
            <!-- Heading & Step Indicator -->
            <div class="text-center mb-stack-lg">
                <h1 class="font-headline-md text-headline-md mb-stack-md">Create Account</h1>
                
                <!-- Step Indicator -->
                <nav class="flex justify-center items-center gap-stack-sm mb-stack-lg">
                    <div class="flex items-center gap-2">
                        <span class="w-2 h-2 rounded-full ${not empty showOtp ? 'bg-outline-variant' : 'bg-primary'}"></span>
                        <span class="font-label-caps text-label-caps ${not empty showOtp ? 'text-on-surface-variant' : 'text-primary'}">ACCOUNT</span>
                    </div>
                    <div class="w-8 h-[1px] bg-outline-variant"></div>
                    <div class="flex items-center gap-2">
                        <span class="w-2 h-2 rounded-full ${not empty showOtp ? 'bg-primary' : 'bg-outline-variant'}"></span>
                        <span class="font-label-caps text-label-caps ${not empty showOtp ? 'text-primary' : 'text-on-surface-variant'}">VERIFY</span>
                    </div>
                </nav>
            </div>

            <!-- STEP 1: Registration Form -->
            <div id="step1" ${not empty showOtp ? 'style="display:none"' : ''}>
                
                <c:if test="${not empty emailError}">
                    <div class="bg-error-container text-on-error-container border border-error px-4 py-3 mb-6 font-body-md text-center">
                        <c:out value="${emailError}" />
                    </div>
                </c:if>
                
                <form class="space-y-stack-lg" id="registrationForm" action="${ctx}/register" method="post" onsubmit="return checkPasswords()">
                    <input type="hidden" name="_csrf" value="${_csrf}" />
                    <!-- Personal Info Row -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-stack-md">
                        <div class="space-y-1">
                            <label class="font-label-caps text-label-caps text-on-surface-variant" for="firstName">FIRST NAME</label>
                            <input class="w-full bg-surface border border-outline py-3 px-4 rounded-none font-body-md transition-all text-on-background" id="firstName" name="firstName" required="" type="text"/>
                        </div>
                        <div class="space-y-1">
                            <label class="font-label-caps text-label-caps text-on-surface-variant" for="lastName">LAST NAME</label>
                            <input class="w-full bg-surface border border-outline py-3 px-4 rounded-none font-body-md transition-all text-on-background" id="lastName" name="lastName" required="" type="text"/>
                        </div>
                    </div>
                    
                    <!-- Credential Fields -->
                    <div class="space-y-stack-md">
                        <div class="space-y-1">
                            <label class="font-label-caps text-label-caps text-on-surface-variant" for="email">EMAIL ADDRESS</label>
                            <input class="w-full bg-surface border border-outline py-3 px-4 rounded-none font-body-md transition-all text-on-background" id="email" name="email" required="" type="email"/>
                        </div>
                        <div class="space-y-1">
                            <label class="font-label-caps text-label-caps text-on-surface-variant" for="username">USERNAME</label>
                            <input class="w-full bg-surface border border-outline py-3 px-4 rounded-none font-body-md transition-all text-on-background" id="username" name="username" required="" type="text"/>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-stack-md">
                            <div class="space-y-1">
                                <label class="font-label-caps text-label-caps text-on-surface-variant" for="password">PASSWORD</label>
                                <input class="w-full bg-surface border border-outline py-3 px-4 rounded-none font-body-md transition-all text-on-background" id="password" name="password" required="" type="password"/>
                            </div>
                            <div class="space-y-1">
                                <label class="font-label-caps text-label-caps text-on-surface-variant" for="confirmPassword">CONFIRM PASSWORD</label>
                                <input class="w-full bg-surface border border-outline py-3 px-4 rounded-none font-body-md transition-all text-on-background" id="confirmPassword" name="confirmPassword" required="" type="password"/>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Interests Section -->
                    <div class="space-y-stack-md pt-4">
                        <h3 class="font-label-caps text-label-caps text-on-surface-variant">INTERESTS</h3>
                        <div class="flex flex-wrap gap-stack-sm">
                            <div class="relative">
                                <input class="interest-chip sr-only" id="streetwear" name="interests" type="checkbox" value="Streetwear"/>
                                <label class="inline-block px-4 py-2 border border-outline-variant text-label-md font-label-md cursor-pointer transition-all hover:bg-surface-container-high active:scale-[0.98] text-on-background bg-surface" for="streetwear">Streetwear</label>
                            </div>
                            <div class="relative">
                                <input class="interest-chip sr-only" id="accessories" name="interests" type="checkbox" value="Accessories"/>
                                <label class="inline-block px-4 py-2 border border-outline-variant text-label-md font-label-md cursor-pointer transition-all hover:bg-surface-container-high active:scale-[0.98] text-on-background bg-surface" for="accessories">Accessories</label>
                            </div>
                            <div class="relative">
                                <input class="interest-chip sr-only" id="outerwear" name="interests" type="checkbox" value="Outerwear"/>
                                <label class="inline-block px-4 py-2 border border-outline-variant text-label-md font-label-md cursor-pointer transition-all hover:bg-surface-container-high active:scale-[0.98] text-on-background bg-surface" for="outerwear">Outerwear</label>
                            </div>
                            <div class="relative">
                                <input class="interest-chip sr-only" id="footwear" name="interests" type="checkbox" value="Footwear"/>
                                <label class="inline-block px-4 py-2 border border-outline-variant text-label-md font-label-md cursor-pointer transition-all hover:bg-surface-container-high active:scale-[0.98] text-on-background bg-surface" for="footwear">Footwear</label>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Terms & Actions -->
                    <div class="space-y-stack-lg pt-4">
                        <div class="flex items-start gap-3">
                            <input class="mt-1 w-4 h-4 rounded-none border-outline-variant text-primary focus:ring-0" id="terms" name="terms" required="" type="checkbox"/>
                            <label class="font-label-md text-label-md text-on-surface-variant" for="terms">
                                I agree to the <a class="underline hover:text-primary transition-colors text-on-background" href="#">Terms &amp; Privacy Policy</a>.
                            </label>
                        </div>
                        
                        <div class="text-red-600 font-bold text-center text-sm" id="passError" style="display:none;">
                            Passwords do not match!
                        </div>
                        
                        <button class="w-full bg-primary text-on-primary py-4 font-label-md text-label-md tracking-wider hover:opacity-90 transition-all active:scale-[0.99] uppercase" type="submit">
                            Create Account
                        </button>
                        <div class="text-center">
                            <p class="font-label-md text-label-md text-on-surface-variant">
                                Already have an account? <a class="text-primary font-bold hover:underline transition-all" href="${ctx}/home?login=true">Sign In</a>
                            </p>
                        </div>
                    </div>
                </form>
            </div>

            <!-- STEP 2: Verification Form -->
            <div id="step2" ${empty showOtp ? 'style="display:none"' : ''}>
                
                <c:if test="${not empty otpError}">
                    <div class="bg-error-container text-on-error-container border border-error px-4 py-3 mb-6 font-body-md text-center">
                        <c:out value="${otpError}" />
                    </div>
                </c:if>
                
                <form class="space-y-stack-lg" id="otpForm" action="${ctx}/otp-verify" method="post">
                    <input type="hidden" name="_csrf" value="${_csrf}" />
                    <input type="hidden" name="otp" id="fullOtp">

                    <p class="font-body-md text-on-surface-variant text-center mb-stack-lg">
                        Enter the 6-digit code sent to your email.
                    </p>

                    <div class="otp-boxes flex justify-center gap-3 mb-stack-lg">
                        <input maxlength="1" inputmode="numeric" class="w-12 h-14 bg-surface border border-outline text-center font-headline-md text-headline-md focus:border-primary transition-all rounded-none text-on-background"/>
                        <input maxlength="1" inputmode="numeric" class="w-12 h-14 bg-surface border border-outline text-center font-headline-md text-headline-md focus:border-primary transition-all rounded-none text-on-background"/>
                        <input maxlength="1" inputmode="numeric" class="w-12 h-14 bg-surface border border-outline text-center font-headline-md text-headline-md focus:border-primary transition-all rounded-none text-on-background"/>
                        <input maxlength="1" inputmode="numeric" class="w-12 h-14 bg-surface border border-outline text-center font-headline-md text-headline-md focus:border-primary transition-all rounded-none text-on-background"/>
                        <input maxlength="1" inputmode="numeric" class="w-12 h-14 bg-surface border border-outline text-center font-headline-md text-headline-md focus:border-primary transition-all rounded-none text-on-background"/>
                        <input maxlength="1" inputmode="numeric" class="w-12 h-14 bg-surface border border-outline text-center font-headline-md text-headline-md focus:border-primary transition-all rounded-none text-on-background"/>
                    </div>

                    <div class="otp-resend text-center font-label-md text-label-md text-on-surface-variant mb-stack-lg">
                        Resend code in <span id="timer" class="text-primary font-bold">30</span>s
                    </div>

                    <button id="resendBtn" class="w-full border border-primary text-primary py-4 font-label-md text-label-md tracking-wider hover:bg-surface-container-high transition-all active:scale-[0.99] uppercase mb-stack-md bg-surface" type="button" onclick="window.location='${ctx}/register?resend=true'" style="display:none;">
                        Resend Code
                    </button>

                    <button id="verifyBtn" class="w-full bg-primary text-on-primary py-4 font-label-md text-label-md tracking-wider hover:opacity-90 transition-all active:scale-[0.99] uppercase disabled:opacity-30 disabled:cursor-not-allowed" type="submit" disabled>
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
