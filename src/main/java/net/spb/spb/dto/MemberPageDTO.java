package net.spb.spb.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import lombok.*;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Getter
@Setter
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MemberPageDTO {

    private String search_member_state;
    private String search_member_grade;
    private String search_word;

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

    @Builder.Default
    private String sort_by = "memberIdx";
    private int total_count;
    private String linkUrl;

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

    public String toQueryString() {
        return String.format(
                "search_member_state=%s&search_member_grade=%s&search_type=%s&search_word=%s&page_no=%d&page_size=%d&page_block_size=%d&sort_by=%s",
                encode(search_member_state),
                encode(search_member_grade),
                encode(search_word),
                page_no,
                page_size,
                page_block_size,
                encode(sort_by)
        );
    }

    private String encode(String value) {
        return value == null ? "" : URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

}
