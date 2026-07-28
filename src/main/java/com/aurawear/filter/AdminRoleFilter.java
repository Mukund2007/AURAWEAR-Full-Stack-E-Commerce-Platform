package com.aurawear.filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.aurawear.model.User;

/**
 * Filter that enforces role = "admin" for every URL under /admin/*.
 *
 * <p>This is a defence-in-depth backstop: individual admin servlets already
 * perform their own role checks, but having a centralized filter means a
 * newly-added admin servlet that forgets the per-method check is still
 * protected automatically.
 *
 * <p>The login page (/admin/login) is explicitly allowed through so
 * unauthenticated users can still reach it.
 */
@WebFilter("/admin/*")
public class AdminRoleFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException { }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getServletPath();

        // Allow the admin login page through without authentication
        if ("/admin/login".equals(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"admin".equals(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() { }
}
