package net.spb.spb.dto.pagingsearch;

import lombok.*;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class LecturePageDTO extends PageDTO {

    @Builder.Default
    private String search_type="";
    @Builder.Default
    private String search_word="";

    @Builder.Default
    private String sort_by = "lectureIdx";
    @Builder.Default
    private String sort_direction = "desc";
}
