package net.spb.spb.dto.pagingsearch;

import lombok.*;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class LecturePageDTO extends PageDTO {
    @Builder.Default
    private String search_type="";

    private String search_category;

    private LocalDate start_date;
    private LocalDate end_date;

    @Builder.Default
    private String sort_by = "lectureIdx";
    @Builder.Default
    private String sort_direction = "desc";

    private static final List<String> SORT_COLUMNS = List.of("lectureIdx", "lectureTitle", "lectureAmount", "lectureCreatedAt");
    private static final List<String> SORT_DIRECTIONS = List.of("asc", "desc");

    public String getSort_by() {
        return SORT_COLUMNS.contains(this.sort_by) ? this.sort_by : "lectureIdx";
    }
    public String getSort_direction() {
        return SORT_DIRECTIONS.contains(this.sort_direction) ? this.sort_direction : "desc";
    }

    public String getLinkUrl() {
        StringBuilder sb = new StringBuilder();
        sb.append("page_no=" + super.getPage_no());
        sb.append("&page_size=" + super.getPage_size());
        sb.append("&page_bock_size=" + super.getPage_block_size());

        if (this.search_category != null && super.getSearch_word() != null) {
            sb.append("&search_category=" + this.search_category);
            sb.append("&search_word=" + encode(super.getSearch_word()));
        }

        if (this.start_date != null && this.end_date != null) {
            sb.append("&start_date=" + this.start_date);
            sb.append("&end_date=" + this.end_date);
        }

        if (this.sort_by != null && this.sort_direction != null) {
            sb.append("&sort_by=" + this.sort_by);
            sb.append("&sort_direction=" + this.sort_direction);
        }

        return sb.toString();
    }
}
