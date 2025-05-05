package net.spb.spb.dto.pagingsearch;

import lombok.*;
import lombok.extern.log4j.Log4j2;
import org.checkerframework.checker.index.qual.Positive;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.PositiveOrZero;

@Log4j2
@Data
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageRequestDTO {
    @Builder.Default
    @Positive
    @Min(value = 1)
    private int pageNo = 1;
    @Builder.Default
    @Positive
    @Min(value = 1)
    private int pageSize = 10;
    @Builder.Default
    @PositiveOrZero
    @Min(value = 0)
    private int pageSkipCount = 0;
    @Builder.Default
    @Positive
    @Min(value = 1)
    private int pageBlockSize = 10;

    public int getPageSkipCount() {
        return (this.pageNo - 1) * this.pageSize;
    }
}
