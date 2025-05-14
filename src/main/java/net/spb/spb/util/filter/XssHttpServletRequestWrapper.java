package net.spb.spb.util.filter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class XssHttpServletRequestWrapper extends HttpServletRequestWrapper {

    public XssHttpServletRequestWrapper(HttpServletRequest request) {
        super(request);
    }

    private String cleanXSS(String value) {
        if (value == null) return null;
        return value
                .replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                .replaceAll("\\(", "&#40;")
                .replaceAll("\\)", "&#41;")
                .replaceAll("'", "&#39;")
                .replaceAll("\"", "&quot;");
    }

    @Override
    public String getParameter(String name) {
        String value = super.getParameter(name);
        return cleanXSS(value);
    }

    @Override
    public String[] getParameterValues(String name) {
        String[] values = super.getParameterValues(name);
        if (values == null) return null;

        for (int i = 0; i < values.length; i++) {
            values[i] = cleanXSS(values[i]);
        }
        return values;
    }

    @Override
    public Map<String, String[]> getParameterMap() {
        Map<String, String[]> paramMap = super.getParameterMap();
        Map<String, String[]> xssMap = new HashMap<>();

        for (Map.Entry<String, String[]> entry : paramMap.entrySet()) {
            String[] cleanedValues = Arrays.stream(entry.getValue())
                    .map(this::cleanXSS)
                    .toArray(String[]::new);
            xssMap.put(entry.getKey(), cleanedValues);
        }
        return xssMap;
    }
}
