package net.spb.spb.dto.pagingsearch;

import lombok.*;
import lombok.experimental.SuperBuilder;
import net.spb.spb.dto.pagingsearch.PageDTO;
import net.spb.spb.util.ReportRefType;

@Getter
@Setter
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class ReportPageDTO extends PageDTO {
    private ReportRefType reportRefType;
    private int search_report_state;
    private String search_start_date;
    private String search_end_date;
    private String search_report_member;
    @Builder.Default
    private String sort_by = "reportIdx";
    @Builder.Default
    private String sort_direction = "desc";
}