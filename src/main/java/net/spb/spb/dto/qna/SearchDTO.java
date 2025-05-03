package net.spb.spb.dto.qna;

import lombok.Data;


@Data
public class SearchDTO {
    private String searchWord;
    private String searchType;
    private String answered;
    private String startDate;
    private String endDate;
}
