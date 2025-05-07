package net.spb.spb.dto.pagingsearch;

import lombok.*;
import lombok.experimental.SuperBuilder;
import net.spb.spb.util.ReportRefType;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Getter
@Setter
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class ReportPageDTO extends PageDTO{
    private ReportRefType reportRefType;
    private int search_report_state;
    private String search_start_date;
    private String search_end_date;
    private String search_report_member;
    @Builder.Default
    private String sort_by = "reportIdx";
    @Builder.Default
    private String sort_direction = "desc";

    @Getter
    @Setter
    @Data
    @ToString
    @AllArgsConstructor
    @NoArgsConstructor
    @SuperBuilder
    public static class MemberPageDTO extends PageDTO {

        private String search_member_state;
        private String search_member_grade;

        @Builder.Default
        private String sort_by = "memberIdx";
        @Builder.Default
        private String sort_direction = "desc";

        public String toQueryString() {
            return String.format(
                    "search_member_state=%s&search_member_grade=%s&search_type=%s&search_word=%s&page_no=%d&page_size=%d&page_block_size=%d&sort_by=%s",
                    encode(search_member_state),
                    encode(search_member_grade),
                    encode(super.getSearch_word()),
                    super.getPage_no(),
                    super.getPage_size(),
                    super.getPage_block_size(),
                    encode(sort_by)
            );
        }

        private String encode(String value) {
            return value == null ? "" : URLEncoder.encode(value, StandardCharsets.UTF_8);
        }

    }
}
