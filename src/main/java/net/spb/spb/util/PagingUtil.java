package net.spb.spb.util;


import net.spb.spb.dto.pagingsearch.*;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public class PagingUtil {
    public static String buildLinkUrl(String basePath, PostPageDTO dto) {
        StringBuilder linkUrl = new StringBuilder(basePath);
        boolean hasQuery = false;

        if (dto.getPage_size() > 0) {
            linkUrl.append(hasQuery ? "&" : "?").append("page_size=").append(dto.getPage_size());
            hasQuery = true;
        }
        if (dto.getSearch_type() != null && !dto.getSearch_type().isEmpty()) {
            linkUrl.append(hasQuery ? "&" : "?").append("search_type=").append(dto.getSearch_type());
            hasQuery = true;
        }
        if (dto.getSearch_word() != null && !dto.getSearch_word().isEmpty()) {
            linkUrl.append(hasQuery ? "&" : "?").append("search_word=").append(dto.getSearch_word());
            hasQuery = true;
        }
        if (dto.getSearch_date1() != null) {
            linkUrl.append(hasQuery ? "&" : "?").append("search_date1=").append(dto.getSearch_date1());
            hasQuery = true;
        }
        if (dto.getSearch_date2() != null) {
            linkUrl.append(hasQuery ? "&" : "?").append("search_date2=").append(dto.getSearch_date2());
            hasQuery = true;
        }
        return linkUrl.toString();
    }
    public static String buildLinkUrl(String basePath, MemberPageDTO dto) {
        StringBuilder linkUrl = new StringBuilder(basePath);
        boolean hasQuery = false;

        if (dto.getPage_size() > 0) {
            linkUrl.append(hasQuery ? "&" : "?").append("page_size=").append(dto.getPage_size());
            hasQuery = true;
        }
        if (dto.getSearch_word() != null && !dto.getSearch_word().isEmpty()) {
            linkUrl.append(hasQuery ? "&" : "?").append("search_word=").append(dto.getSearch_word());
            hasQuery = true;
        }
        if (dto.getSearch_member_state() != null) {
            linkUrl.append(hasQuery ? "&" : "?").append("search_member_state=").append(dto.getSearch_member_state());
            hasQuery = true;
        }
        if (dto.getSearch_member_grade() != null) {
            linkUrl.append(hasQuery ? "&" : "?").append("search_member_grade=").append(dto.getSearch_member_grade());
            hasQuery = true;
        }
        if (dto.getSort_by() != null) {
            linkUrl.append(hasQuery ? "&" : "?").append("sort_by=").append(dto.getSort_by());
            hasQuery = true;
        }
        if (dto.getSort_direction() != null) {
            linkUrl.append(hasQuery ? "&" : "?").append("sort_direction=").append(dto.getSort_direction());
            hasQuery = true;
        }
        return linkUrl.toString();
    }
    public static String buildLinkUrl(String basePath, LecturePageDTO dto) {
        StringBuilder linkUrl = new StringBuilder(basePath);
        boolean hasQuery = false;

        if (dto.getPage_size() > 0) {
            linkUrl.append(hasQuery ? "&" : "?").append("page_size=").append(dto.getPage_size());
            hasQuery = true;
        }
        if (dto.getSearch_word() != null && !dto.getSearch_word().isEmpty()) {
            linkUrl.append(hasQuery ? "&" : "?").append("search_word=").append(dto.getSearch_word());
            hasQuery = true;
        }
        if (dto.getSearch_type() != null) {
            linkUrl.append(hasQuery ? "&" : "?").append("search_type=").append(dto.getSearch_type());
            hasQuery = true;
        }
        if (dto.getSort_by() != null) {
            linkUrl.append(hasQuery ? "&" : "?").append("sort_by=").append(dto.getSort_by());
            hasQuery = true;
        }
        if (dto.getSort_direction() != null) {
            linkUrl.append(hasQuery ? "&" : "?").append("sort_direction=").append(dto.getSort_direction());
            hasQuery = true;
        }
        return linkUrl.toString();
    }

    public static String buildLinkUrl(String basePath, StudentLecturePageDTO dto) {
        StringBuilder linkUrl = new StringBuilder(basePath);
        List<String> params = new ArrayList<>();

        if (dto.getPage_size() > 0) {
            params.add("page_size=" + dto.getPage_size());
        }
        if (dto.getLecture_status() > 0) {
            params.add("lecture_status=" + dto.getLecture_status());
        }
        if (dto.getSearch_category() != null && dto.getSearch_word() != null && !dto.getSearch_category().isBlank() && !dto.getSearch_word().isBlank()) {
            params.add("search_category=" + dto.getSearch_category());
            params.add("search_word=" + URLEncoder.encode(dto.getSearch_word(), StandardCharsets.UTF_8));
        }

        if (!params.isEmpty()) {
            linkUrl.append("?").append(String.join("&", params));
        }

        return linkUrl.toString();
    }

    public static <T extends PageDTO> String pagingArea(T pageDTO) {
        if (pageDTO.getTotal_count() < 1) {
            return "";
        }

        StringBuilder sb = new StringBuilder();
        String baseUrl = !pageDTO.getLinkUrl().isEmpty() ? pageDTO.getLinkUrl() : "";
        String connector = baseUrl.contains("?") ? "&" : "?";

        int startPage = pageDTO.getStart_page();
        int endPage = pageDTO.getEnd_page();
        int currentPage = pageDTO.getPage_no();
        int totalPage = pageDTO.getTotal_page();

        if( currentPage != 1) {
            sb.append(getFullLink(baseUrl, connector, 1, "<<"));
        } else {

            sb.append("<span><<</span>").append("&nbsp;&nbsp;");
        }

        if (pageDTO.isHas_prev()) {
            int prevPage = startPage - 1;
            sb.append(getFullLink(baseUrl, connector, prevPage, "<"));
        } else {
            sb.append("<span><</span>").append("&nbsp;&nbsp;");
        }

        for(int i = startPage; i <= endPage; i++) {
            if(i == currentPage) {
                sb.append("<strong>").append(i).append("</strong>&nbsp;&nbsp;");
            } else {
                sb.append(getFullLink(baseUrl, connector, i, i+""));
            }
        }

        if(pageDTO.isHas_next()) {
            int nextPage = endPage + 1;
            sb.append(getFullLink(baseUrl, connector, nextPage, ">"));
        } else {
            sb.append("<span>></span>").append("&nbsp;&nbsp;");
        }

        if( currentPage != totalPage) {
            sb.append(getFullLink(baseUrl, connector, totalPage, ">>"));
        } else {
            sb.append("<span>>></span>").append("&nbsp;&nbsp;");
        }

        return sb.toString();
    }

    private static String getFullLink(String baseUrl, String connector, int page_no, String s) {
        return "<a href='" + baseUrl + connector + "page_no=" + page_no + "'>" + s + "</a>" + "&nbsp;&nbsp;";
    }

}
