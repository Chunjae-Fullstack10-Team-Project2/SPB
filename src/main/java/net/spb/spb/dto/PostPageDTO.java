package net.spb.spb.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PostPageDTO {

    private String postCategory;

    @Builder.Default
    private String search_type="";

    @Builder.Default
    private String search_word="";

    @Positive
    @Min(0)
    @Builder.Default
    private int page_no=1;

    @Positive
    @Min(0)
    @Builder.Default
    private int page_size=10;

    @Positive
    @Min(0)
    @Builder.Default
    private int page_block_size=10;

    private int total_count;
    private String linkUrl;

    private LocalDate search_date1;
    private LocalDate search_date2;

    public int getPage_skip_count() {
        return (page_no-1)*page_size;
    }
    public int getTotal_page() {
        return (int) Math.ceil((double) total_count / page_size);
    }
    public int getStart_page() {
        return ((page_no-1)/page_block_size)*page_block_size+1;
    }
    public int getEnd_page() {
        int end = getStart_page() + page_block_size -1;
        return Math.min(end, getTotal_page());
    }
    public boolean isHas_prev() {
        return getStart_page() > 1;
    }
    public boolean isHas_next() {
        return getEnd_page() < getTotal_page();
    }
    public void setSearch_type() {
        switch (search_type) {
            case "title": this.search_type = "postTitle"; break;
            case "content": this.search_type = "postContent"; break;
            case "author": this.search_type = "postMemberId"; break;
            default: this.search_type = "";break;
        }
    }
}
