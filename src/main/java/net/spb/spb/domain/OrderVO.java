package net.spb.spb.domain;

import lombok.*;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class OrderVO {
    private int orderIdx;
    private String orderMemberId;
    private int orderAmount;
    private String orderStatus;
    private String orderCreatedAt;
    private String orderUpdatedAt;
}
