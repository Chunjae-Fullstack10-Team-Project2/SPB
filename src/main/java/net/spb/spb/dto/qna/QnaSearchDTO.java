package net.spb.spb.dto.qna;

import lombok.Data;


@Data
public class QnaSearchDTO {
    private String searchWord;
    private String searchType;
    private String answered;
    private String startDate;
    private String endDate;
}
