package net.spb.spb.dto.pagingsearch;

import lombok.*;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;

@Getter
@Setter
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class PostPageDTO extends PageDTO {

    private String postCategory;

    @Builder.Default
    private String search_type = "";

    private String search_date1;
    private String search_date2;

    public void normalizeSearchType() {
        if (this.search_type == null || this.search_type.isBlank()) {
            this.search_type = null;
            return;
        }

        switch (this.search_type) {
            case "title":
                this.search_type = "postTitle";
                break;
            case "content":
                this.search_type = "postContent";
                break;
            case "author":
                this.search_type = "postMemberId";
                break;
            default:
                this.search_type = null;
        }
    }

    @Builder.Default
    public String sort_by = "postIdx";
    @Builder.Default
    public String sort_direction = "desc";

    public String toQueryString() {
        return String.format(
                "page_no=%d" +
                        "&page_size=%d" +
                        "&page_block_size=%d" +
                        "&search_word=%s" +
                        "&search_type=%s" +
                        "&search_date1=%s" +
                        "&search_date2=%s" +
                        "&sort_by=%s"+
                "&sort_direction=%s",
                super.getPage_no(),
                super.getPage_size(),
                super.getPage_block_size(),
                encode(super.getSearch_word()),
                encode(search_type),
                encode(search_date1),
                encode(search_date2),
                encode(sort_by),
                encode(sort_direction)
        );
    }
}
