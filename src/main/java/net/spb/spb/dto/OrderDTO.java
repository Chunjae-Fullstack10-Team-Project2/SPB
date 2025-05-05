package net.spb.spb.dto;

import lombok.*;
import lombok.extern.log4j.Log4j2;

import java.util.List;

@Log4j2
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class OrderDTO {
    private int orderIdx;
    private String orderId;
    private int orderAmount;
    private String orderStatus;
    private String orderCreatedAt;
    private String orderUpdatedAt;
    private List<String> orderLectureList;
}
