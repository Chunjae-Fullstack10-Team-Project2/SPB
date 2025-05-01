package net.spb.spb.util;

import net.spb.spb.dto.PostPageDTO;

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

    public static String pagingArea(PostPageDTO PostPageDTO) {

        if (PostPageDTO.getTotal_count() < 1) {
            return "";
        }

        StringBuilder sb = new StringBuilder();
        String baseUrl = !PostPageDTO.getLinkUrl().isEmpty() ? PostPageDTO.getLinkUrl() : "";
        String connector = baseUrl.contains("?") ? "&" : "?";

        int startPage = PostPageDTO.getStart_page();
        int endPage = PostPageDTO.getEnd_page();
        int currentPage = PostPageDTO.getPage_no();
        int totalPage = PostPageDTO.getTotal_page();

        if( currentPage != startPage) {
            sb.append(getFullLink(baseUrl, connector, 1, "<<"));
        }

        if (PostPageDTO.isHas_prev()) {
            int prevPage = startPage - 1;
            sb.append(getFullLink(baseUrl, connector, prevPage, "<"));
        }

        for(int i = startPage; i <= endPage; i++) {
            if(i == currentPage) {
                sb.append("<strong>").append(i).append("</strong>&nbsp;&nbsp;");
            } else {
                sb.append(getFullLink(baseUrl, connector, i, i+""));
            }
        }

        if(PostPageDTO.isHas_next()) {
            int nextPage = endPage + 1;
            sb.append(getFullLink(baseUrl, connector, nextPage, ">"));
        }

        if( currentPage != totalPage) {
            sb.append(getFullLink(baseUrl, connector, totalPage, ">>"));
        }

        return sb.toString();
    }
    private static String getFullLink(String baseUrl, String connector, int page_no, String s) {
        return "<a href='" + baseUrl + connector + "page_no=" + page_no + "'>" + s + "</a>" + "&nbsp;&nbsp;";
    }
}
