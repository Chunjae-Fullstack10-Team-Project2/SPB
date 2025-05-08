package net.spb.spb.dto;

import lombok.Data;

@Data
public class CancelRequestDTO {
    private String merchant_uid;
    private String reason;
    private int amount;
}