package net.spb.spb.service.Qna;

import net.spb.spb.dto.PageRequestDTO;
import net.spb.spb.dto.qna.QnaDTO;
import net.spb.spb.dto.qna.QnaSearchDTO;

import java.util.List;

public interface QnaService {
    List<QnaDTO> qnaList();

    List<QnaDTO> searchQna(QnaSearchDTO searchDTO, PageRequestDTO pageRequestDTO);

    QnaDTO view(String qnaIdx);

    boolean createQ(QnaDTO qnaDTO);

    boolean updateA(QnaDTO qnaDTO);

    boolean delete(String qnaIdx);

    int totalCount(QnaSearchDTO searchDTO);
}
