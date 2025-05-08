package net.spb.spb.util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;


public class NoticePaging {

    public static int getOffset(int page, int size) {
        return (page - 1) * size;
    }

    public static int getTotalPage(int totalCount, int size) {
        return (int) Math.ceil((double) totalCount / size);
    }

    public static String getPagination(int currentPage, int totalPage, String basePath,
                                       String keyword, String searchType, int size) {
        StringBuilder pagination = new StringBuilder();
        int pageBlock = 5;
        int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
        int endPage = Math.min(startPage + pageBlock - 1, totalPage);

        String queryParams = getQueryParams(keyword, searchType, size);

        pagination.append("<nav aria-label=\"Page navigation\">");
        pagination.append("<ul class=\"pagination justify-content-center\">");

        // 첫 페이지로 이동 (<<)
        pagination.append("<li class=\"page-item").append(currentPage == 1 ? " disabled" : "").append("\">");
        pagination.append("<a class=\"page-link\" href=\"").append(currentPage == 1 ? "#" : basePath + "?page=1" + queryParams).append("\">");
        pagination.append("&laquo;&laquo;</a></li>");

        // 이전 페이지로 이동 (<)
        pagination.append("<li class=\"page-item").append(currentPage > 1 ? "" : " disabled").append("\">");
        pagination.append("<a class=\"page-link\" href=\"").append(currentPage > 1 ? basePath + "?page=" + (currentPage - 1) + queryParams : "#").append("\">");
        pagination.append("&laquo;</a></li>");

        // 페이지 번호
        for (int i = startPage; i <= endPage; i++) {
            pagination.append("<li class=\"page-item").append(i == currentPage ? " active" : "").append("\">");
            pagination.append("<a class=\"page-link\" href=\"").append(i == currentPage ? "#" : basePath + "?page=" + i + queryParams).append("\">");
            pagination.append(i).append("</a></li>");
        }

        // 다음 페이지로 이동 (>)
        pagination.append("<li class=\"page-item").append(currentPage < totalPage ? "" : " disabled").append("\">");
        pagination.append("<a class=\"page-link\" href=\"").append(currentPage < totalPage ? basePath + "?page=" + (currentPage + 1) + queryParams : "#").append("\">");
        pagination.append("&raquo;</a></li>");

        // 마지막 페이지로 이동 (>>)
        pagination.append("<li class=\"page-item").append(currentPage == totalPage ? " disabled" : "").append("\">");
        pagination.append("<a class=\"page-link\" href=\"").append(currentPage == totalPage ? "#" : basePath + "?page=" + totalPage + queryParams).append("\">");
        pagination.append("&raquo;&raquo;</a></li>");

        pagination.append("</ul>");
        pagination.append("</nav>");

        return pagination.toString();
    }

    private static String getQueryParams(String keyword, String searchType, int size) {
        StringBuilder params = new StringBuilder();

        params.append("&size=").append(size);

        if (keyword != null && !keyword.trim().isEmpty()) {
            params.append("&keyword=").append(URLEncoder.encode(keyword, StandardCharsets.UTF_8));

            if (searchType != null && !searchType.trim().isEmpty()) {
                params.append("&searchType=").append(searchType);
            }
        }

        return params.toString();
    }


    public static int getStartNum(int totalCount, int currentPage, int size) {
        return totalCount - ((currentPage - 1) * size);
    }
}