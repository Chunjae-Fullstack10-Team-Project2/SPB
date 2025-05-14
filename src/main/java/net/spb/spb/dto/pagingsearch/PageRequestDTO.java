package net.spb.spb.dto.pagingsearch;

import lombok.*;

@ToString
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageRequestDTO {
    private int pageSkipCount = 0;

    @Builder.Default
    private int pageNo = 1;

    @Builder.Default
    private int pageSize = 10;

    @Builder.Default
    private int pageBlockSize = 10;

    public int getPageNo() {
        return pageNo < 1 ? 1 : pageNo;
    }

    public int getPageSize() {
        return pageSize < 1 ? 10 : pageSize;
    }

    public int getPageSkipCount() {
        return Math.max((getPageNo() - 1) * getPageSize(), 0);
    }
}
