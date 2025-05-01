package net.spb.spb.mapper;

import net.spb.spb.domain.QnaVO;
import net.spb.spb.dto.QnaDTO;

import java.util.List;

public interface QnaMapper {
    List<QnaDTO> qnaList();

    QnaVO view(String qnaIdx);

    boolean createQ(QnaVO qnaVO);

    boolean updateA(QnaVO qnaVO);

    boolean delete(String qnaIdx);
}
