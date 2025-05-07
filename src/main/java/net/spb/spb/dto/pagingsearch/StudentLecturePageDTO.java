package net.spb.spb.dto.pagingsearch;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import net.spb.spb.dto.PageDTO;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class StudentLecturePageDTO extends PageDTO {
    @Builder.Default
    private int lecture_status = 0;
    private String search_category;
    private String search_word;
}
