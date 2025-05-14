package net.spb.spb.util;

import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.PageResponseDTO;

import java.util.Collections;
import java.util.List;
import java.util.function.Supplier;

public class PageUtil {

    public static <E> PageResponseDTO<E> buildAndCorrectPageResponse(
            PageRequestDTO pageRequestDTO,
            int totalCount,
            Supplier<List<E>> dataSupplier) {

        PageResponseDTO<E> temp = PageResponseDTO.<E>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(totalCount)
                .dtoList(Collections.emptyList())
                .build();

        pageRequestDTO.setPageNo(temp.getPageNo());

        List<E> correctedList = dataSupplier.get();

        temp.setDtoList(correctedList);
        return temp;
    }
}
