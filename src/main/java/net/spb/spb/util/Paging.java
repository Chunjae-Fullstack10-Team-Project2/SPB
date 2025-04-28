package net.spb.spb.util;

import java.util.HashMap;
import java.util.Map;

public class Paging {
    public static Map<String, Object> getPagingData(int total_count, int page_no, int page_size, int page_block_size) {
        // String tempLinkUrl;

        Map<String, Object> pagingData = new HashMap<>();

        int total_page = (int) Math.ceil(total_count / (double) page_size);
        total_page = Math.max(total_page, 1);

        // << < 1 2 > >> 일지 << < 3 4 > >> 일지
        int page_block_start = (int) Math.floor((page_no - 1) / (double) page_block_size) * page_block_size + 1;
        int page_block_end = page_block_start + page_block_size - 1;
        page_block_end = Math.min(page_block_end, total_page);

        pagingData.put("total_page", total_page);
        pagingData.put("page_no", page_no);
        pagingData.put("page_block_start", page_block_start);
        pagingData.put("page_block_end", page_block_end);
        pagingData.put("prev_page", page_block_start > 1 ? page_block_start - 1 : null);
        pagingData.put("next_page", page_block_end < total_page ? page_block_end + 1 : null);
        return pagingData;
    }
}
