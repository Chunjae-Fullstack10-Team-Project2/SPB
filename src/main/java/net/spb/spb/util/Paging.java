package net.spb.spb.util;

public class Paging {

    public static int getTotalPage(int totalCount, int pageSize) {
        return (int) Math.ceil((double) totalCount / pageSize);
    }

    public static int getOffset(int pageNo, int pageSize) {
        return (pageNo - 1) * pageSize;
    }
}
