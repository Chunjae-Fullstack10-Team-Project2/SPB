package net.spb.spb.mapper;

import net.spb.spb.domain.FaqVO;
import net.spb.spb.domain.QnaVO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.dto.qna.QnaDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface FaqMapper {
    List<QnaDTO> faqList(@Param("searchDTO") SearchDTO searchDTO,
                           @Param("pageDTO") PageRequestDTO pageDTO);

    boolean create(FaqVO faqVO);

    boolean update(FaqVO faqVO);

    boolean delete(String faqIdx);

    int totalCount(@Param("searchDTO") SearchDTO searchDTO);
}
