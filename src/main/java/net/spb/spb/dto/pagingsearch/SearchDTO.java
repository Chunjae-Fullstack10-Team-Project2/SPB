package net.spb.spb.dto.pagingsearch;

import lombok.Data;


@Data
public class SearchDTO {
    private String query;
    private String searchWord;
    private String searchType;
    private Integer answered;
    private String dateType;
    private String startDate;
    private String endDate;
    private String sortColumn;
    private String sortOrder;
    private String reportState;
}
