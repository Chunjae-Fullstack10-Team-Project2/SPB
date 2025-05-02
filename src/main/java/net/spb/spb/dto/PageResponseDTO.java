package net.spb.spb.dto;

import lombok.Builder;
import lombok.Data;
import lombok.extern.log4j.Log4j2;

import java.util.List;

@Log4j2
@Data
public class PageResponseDTO<E> {
    private int totalCount;
    private int pageNo;
    private int pageSize;
    private int totalPage;
    private int pageSkipCount;
    private int pageBlockSize;
    private int pageBlockStart;
    private int pageBlockEnd;

    private int firstPage;
    private int lastPage;
    private boolean prevPageFlag;
    private boolean nextPageFlag;

    private List<E> dtoList;

    public PageResponseDTO() {
    }

    @Builder(builderMethodName = "withAll")
    public PageResponseDTO(PageRequestDTO pageRequestDTO, int totalCount, List<E> dtoList) {
        this.totalCount = totalCount;
        this.pageNo = pageRequestDTO.getPageNo();
        this.pageSize = pageRequestDTO.getPageSize();
        this.pageSkipCount = pageRequestDTO.getPageSkipCount();
        this.totalPage = this.totalCount > 0 ? (int) Math.ceil((double) this.totalCount / this.pageSize) : 1;
        this.pageBlockSize = pageRequestDTO.getPageBlockSize();
        this.setPageBlockStart((int) Math.floor((pageNo - 1) / (double) pageBlockSize) * pageBlockSize + 1);
        this.setPageBlockEnd(pageBlockStart + pageBlockSize - 1);
        this.prevPageFlag = this.pageBlockStart > 1;
        this.nextPageFlag = this.pageBlockEnd < totalPage;
        this.dtoList = dtoList;
    }

    public int getTotalPage() {
        return (int) Math.ceil((double) this.totalCount / this.pageSize);
    }

    public int getPageSkipCount() {
        return (this.pageNo - 1) * this.pageSize;
    }

    public void setPageBlockStart() {
        if (this.pageNo % this.pageBlockSize == 0) {
            this.pageBlockStart = this.pageNo - this.pageBlockSize - 1;
        } else {
            this.pageBlockStart = (int) Math.floor(((double) this.pageNo / this.pageBlockSize)) * this.pageBlockSize + 1;
        }
    }

    public void setPageBlockEnd() {
        this.pageBlockEnd = (int) (Math.ceil((double) this.pageNo / this.pageBlockSize) * this.pageBlockSize);
        this.pageBlockEnd = Math.min(this.pageBlockEnd, this.totalPage);
    }
}
