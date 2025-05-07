package net.spb.spb.util;

public class PagingUtil {

    public static String getPagination(int currentPage, int totalPage, String baseUrl, String params) {
        StringBuilder sb = new StringBuilder();

        sb.append("<div class='pagination'>");

        int startPage = Math.max(1, currentPage - 2);
        int endPage = Math.min(totalPage, currentPage + 2);

        if (currentPage > 1) {
            sb.append("<a href='").append(baseUrl).append("?page=1").append(params).append("'><<</a> ");
            sb.append("<a href='").append(baseUrl).append("?page=").append(currentPage - 1).append(params).append("'><</a> ");
        }

        for (int i = startPage; i <= endPage; i++) {
            if (i == currentPage) {
                sb.append("<strong>").append(i).append("</strong> ");
            } else {
                sb.append("<a href='").append(baseUrl).append("?page=").append(i).append(params).append("'>")
                        .append(i).append("</a> ");
            }
        }

        if (currentPage < totalPage) {
            sb.append("<a href='").append(baseUrl).append("?page=").append(currentPage + 1).append(params).append("'>></a> ");
            sb.append("<a href='").append(baseUrl).append("?page=").append(totalPage).append(params).append("'>>></a>");
        }

        sb.append("</div>");
        return sb.toString();
    }
}
