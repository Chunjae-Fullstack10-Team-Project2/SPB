package net.spb.spb.util;

public class Paging {

    // 전체 페이지 수
    public static int getTotalPage(int totalCount, int pageSize) {
        return (int) Math.ceil((double) totalCount / pageSize);
    }

    public static int getOffset(int pageNo, int pageSize) {
        return (pageNo - 1) * pageSize;
    }

    // 시작 페이지
    public static int getStartPage(int currentPage, int totalPage) {
        return Math.max(1, currentPage - 2);
    }

    // 끝 페이지
    public static int getEndPage(int currentPage, int totalPage) {
        return Math.min(totalPage, currentPage + 2);
    }

    // 이전 페이지
    public static int getPrevPage(int currentPage) {
        return currentPage > 1 ? currentPage - 1 : 1;
    }

    // 다음 페이지
    public static int getNextPage(int currentPage, int totalPage) {
        return currentPage < totalPage ? currentPage + 1 : totalPage;
    }
}
