package net.spb.spb.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderLectureDTO {
    private int lectureIdx;
    private String lectureTitle;
}
