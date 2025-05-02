package net.spb.spb.service.Qna;

import net.spb.spb.dto.QnaDTO;
import org.springframework.stereotype.Service;

import java.util.List;

public interface QnaService {
    List<QnaDTO> qnaList();

    QnaDTO view(String qnaIdx);

    boolean createQ(QnaDTO qnaDTO);

    boolean updateA(QnaDTO qnaDTO);

    boolean delete(String qnaIdx);
}
