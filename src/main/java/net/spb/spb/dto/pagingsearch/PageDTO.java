package net.spb.spb.dto.pagingsearch;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import lombok.*;
import lombok.experimental.SuperBuilder;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Getter
@Setter
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class PageDTO {
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

    protected String encode(String value) {
        return value == null ? "" : URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}

