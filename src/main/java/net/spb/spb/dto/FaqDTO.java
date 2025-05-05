package net.spb.spb.dto;

import lombok.*;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
@ToString
public class FaqDTO {
    private String faqIdx;
    private String faqQuestion;
    private String faqAnswer;
    private Date faqCreatedAt;
    private Date faqUpdatedAt;
    private String faqState;
}
