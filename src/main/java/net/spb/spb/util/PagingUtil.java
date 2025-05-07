package net.spb.spb.util;

public class PagingUtil {

    public static String getPagination(int currentPage, int totalPage, String baseUrl) {
        StringBuilder sb = new StringBuilder();

        if (currentPage > 1) {
            sb.append("<a href='").append(baseUrl).append("?page=").append(1).append("'>[처음]</a> ");
            sb.append("<a href='").append(baseUrl).append("?page=").append(currentPage - 1).append("'>[이전]</a> ");
        }

        for (int i = 1; i <= totalPage; i++) {
            if (i == currentPage) {
                sb.append("<strong>").append(i).append("</strong> ");
            } else {
                sb.append("<a href='").append(baseUrl).append("?page=").append(i).append("'>").append(i).append("</a> ");
            }
        }

        if (currentPage < totalPage) {
            sb.append("<a href='").append(baseUrl).append("?page=").append(currentPage + 1).append("'>[다음]</a> ");
            sb.append("<a href='").append(baseUrl).append("?page=").append(totalPage).append("'>[마지막]</a>");
        }

        return sb.toString();
    }
}
