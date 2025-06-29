package net.spb.spb.dto.pagingsearch;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class TeacherFilePageDTO extends PageDTO {
    private String teacherId;

    private String search_category;

    private LocalDate start_date;
    private LocalDate end_date;

    @Builder.Default
    private String sort_by = "teacherFileIdx";
    @Builder.Default
    private String sort_direction = "desc";

    private static final List<String> SORT_COLUMNS = List.of("teacherFileIdx", "teacherNoticeTitle", "teacherFileCreatedAt");
    private static final List<String> SORT_DIRECTIONS = List.of("asc", "desc");

    public String getSort_by() {
        return SORT_COLUMNS.contains(this.sort_by) ? this.sort_by : "teacherFileIdx";
    }
    public String getSort_direction() { return SORT_DIRECTIONS.contains(this.sort_direction) ? this.sort_direction : "desc"; }

    public String getLinkUrl() {
        StringBuilder sb = new StringBuilder();
        sb.append("page_no=" + super.getPage_no());
        sb.append("&page_size=" + super.getPage_size());
        sb.append("&page_bock_size=" + super.getPage_block_size());

        if (this.teacherId != null) {
            sb.append("&teacherId=" + this.teacherId);
        }
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