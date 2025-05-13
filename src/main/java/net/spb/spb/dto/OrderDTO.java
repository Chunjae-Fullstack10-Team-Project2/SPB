package net.spb.spb.dto;

import lombok.*;
import lombok.extern.log4j.Log4j2;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Log4j2
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class OrderDTO {
    private int orderIdx;
    private String orderMemberId;
    private int orderAmount;
    private String orderStatus;
    private LocalDateTime orderCreatedAt;
    private LocalDateTime orderUpdatedAt;
    private List<String> orderLectureList;
    private List<OrderLectureDTO> orderLectureDTOList;

    //    tbl_order_lecture
    private int orderLectureIdx;

    //    tbl_lecture
    private int lectureIdx;
    private String lectureTitle;
    private String lectureDescription;
    private String lectureTeacherId;
    private Date lectureCreatedAt;
    private String lectureThumbnailImg;
    private int lectureAmount;
}
