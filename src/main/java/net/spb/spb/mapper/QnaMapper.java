package net.spb.spb.mapper;

import net.spb.spb.domain.QnaVO;
import net.spb.spb.dto.PageRequestDTO;
import net.spb.spb.dto.qna.QnaDTO;
import net.spb.spb.dto.qna.QnaSearchDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface QnaMapper {
    List<QnaDTO> qnaList();

    QnaVO view(String qnaIdx);

    List<QnaDTO> searchQna(@Param("searchDTO") QnaSearchDTO searchDTO,
                           @Param("pageDTO") PageRequestDTO pageDTO);

    boolean createQ(QnaVO qnaVO);

    boolean updateA(QnaVO qnaVO);

    boolean delete(String qnaIdx);

    int totalCount(QnaSearchDTO searchDTO);
}
