package net.spb.spb.util;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class StringEscapeUtils {

    // 매핑 테이블: 특수문자 → HTML 엔티티
    private static final Map<String, String> ESCAPE_MAP = new HashMap<>();
    private static final Map<String, String> UNESCAPE_MAP = new HashMap<>();

    static {
        ESCAPE_MAP.put("&", "&amp;");
        ESCAPE_MAP.put("<", "&lt;");
        ESCAPE_MAP.put(">", "&gt;");
        ESCAPE_MAP.put("\"", "&quot;");
        ESCAPE_MAP.put("'", "&#39;");

        // 역매핑 테이블 자동 생성
        ESCAPE_MAP.forEach((k, v) -> UNESCAPE_MAP.put(v, k));
    }

    /**
     * HTML 특수문자를 엔티티(&amp;lt; 같은)로 변환
     */
    public static String escapeHtml4(String input) {
        if (input == null) return null;
        StringBuilder sb = new StringBuilder(input.length() * 2);
        for (char c : input.toCharArray()) {
            String s = String.valueOf(c);
            sb.append(ESCAPE_MAP.getOrDefault(s, s));
        }
        return sb.toString().replace("\n", "<br/>");
    }

    /**
     * HTML 엔티티(&amp;lt; 등)를 원래 문자로 복원
     */
    public static String unescapeHtml4(String input) {
        if (input == null) return null;
        String output = input;
        // 1. 이름 기반 매핑 복원
        for (Map.Entry<String, String> e : UNESCAPE_MAP.entrySet()) {
            output = output.replace(e.getKey(), e.getValue());
        }
        // 2. 숫자형 엔티티 복원
        Pattern pattern = Pattern.compile("&#(\\d+);");
        Matcher matcher = pattern.matcher(output);
        StringBuffer sb = new StringBuffer();
        while (matcher.find()) {
            int codePoint = Integer.parseInt(matcher.group(1));
            matcher.appendReplacement(sb, Matcher.quoteReplacement(String.valueOf((char) codePoint)));
        }
        matcher.appendTail(sb);
        return sb.toString();
    }
}
