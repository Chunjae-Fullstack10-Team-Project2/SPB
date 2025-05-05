package net.spb.spb.service.qna;

import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.qna.QnaDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;

import java.util.List;

public interface QnaService {
    List<QnaDTO> qnaList();

    List<QnaDTO> searchQna(SearchDTO searchDTO, PageRequestDTO pageRequestDTO);

    QnaDTO view(String qnaIdx);

    boolean createQ(QnaDTO qnaDTO);

    boolean updateA(QnaDTO qnaDTO);

    boolean delete(String qnaIdx);

    int totalCount(SearchDTO searchDTO);

    List<QnaDTO> myQna(SearchDTO searchDTO, PageRequestDTO pageRequestDTO, String qnaQMemberId);
}
