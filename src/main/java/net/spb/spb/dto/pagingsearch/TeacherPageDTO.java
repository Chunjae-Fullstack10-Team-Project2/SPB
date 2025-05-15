package net.spb.spb.dto.pagingsearch;

import lombok.*;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class TeacherPageDTO extends PageDTO{

    @Builder.Default
    private String sort_by = "memberIdx";
    @Builder.Default
    private String sort_direction = "desc";

    public String toQueryString() {
        return String.format(
                        "search_word=%s" +
                        "&page_no=%d" +
                        "&page_size=%d" +
                        "&page_block_size=%d" +
                        "&sort_by=%s" +
                        "&sort_direction=%s",

                encode(super.getSearch_word()),
                super.getPage_no(),
                super.getPage_size(),
                super.getPage_block_size(),
                encode(sort_by),
                encode(sort_direction)
        );
    }

}
