package net.spb.spb.dto;

import lombok.*;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class PaymentDTO {
    //private int paymentIdx;
    private int paymentOrderIdx;
    private String paymentMethod;
    private String paymentStatus;
    private String paymentTransactionId;
    private String paymentApprovedAt;
    private String paymentCanceledAt;
    private String paymentCreatedAt;
    private String paymentUpdateAt;

}