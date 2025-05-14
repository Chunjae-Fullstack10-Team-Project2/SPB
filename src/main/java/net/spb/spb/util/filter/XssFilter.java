package net.spb.spb.util.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterConfig;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;

public class XssFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        chain.doFilter(new XssHttpServletRequestWrapper(req), response);
    }

    @Override
    public void destroy() {
    }
}
