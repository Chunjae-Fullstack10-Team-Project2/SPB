package net.spb.spb.dto.pagingsearch;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class LectureReviewPageDTO extends PageDTO {
    private String where_column;
    private String where_value;

    private String search_category;
    private String search_word;
    private LocalDate search_start_date;
    private LocalDate search_end_date;

    private String sort_by;
    private String sort_direction;

    private static final List<String> SORT_COLUMNS = List.of("lectureReviewIdx", "lectureTitle", "teacherName", "lectureReviewContent", "lectureReviewGrade");
    private static final List<String> SORT_DIRECTIONS = List.of("asc", "desc");

    public String getSort_by() {
        return SORT_COLUMNS.contains(this.sort_by) ? this.sort_by : "lectureReviewIdx";
    }

    public String getSort_direction() {
        return SORT_DIRECTIONS.contains(this.sort_direction) ? this.sort_direction : "desc";
    }
}
