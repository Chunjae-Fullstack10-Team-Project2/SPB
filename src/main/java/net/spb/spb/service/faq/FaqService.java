package net.spb.spb.service.faq;

import net.spb.spb.dto.FaqDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.dto.qna.QnaDTO;

import java.util.List;

public interface FaqService {
    List<QnaDTO> faqList(SearchDTO searchDTO, PageRequestDTO pageRequestDTO);

    boolean create(FaqDTO faqDTO);

    boolean update(FaqDTO faqDTO);

    boolean delete(String faqIdx);

    int totalCount(SearchDTO searchDTO);
}
