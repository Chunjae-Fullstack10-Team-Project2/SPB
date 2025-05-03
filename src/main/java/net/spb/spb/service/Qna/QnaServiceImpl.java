package net.spb.spb.service.Qna;

import net.spb.spb.domain.QnaVO;
import net.spb.spb.dto.PageRequestDTO;
import net.spb.spb.dto.qna.QnaDTO;
import net.spb.spb.dto.qna.SearchDTO;
import net.spb.spb.mapper.QnaMapper;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class QnaServiceImpl implements QnaService {
    private final ModelMapper modelMapper;
    private final QnaMapper qnaMapper;

    @Autowired
    public QnaServiceImpl(ModelMapper modelMapper, QnaMapper qnaMapper) {
        this.modelMapper = modelMapper;
        this.qnaMapper = qnaMapper;
    }

    @Override
    public List<QnaDTO> qnaList() {
        return qnaMapper.qnaList();
    }

    @Override
    public List<QnaDTO> searchQna(SearchDTO searchDTO, PageRequestDTO pageRequestDTO) {
        return qnaMapper.searchQna(searchDTO, pageRequestDTO);
    }

    @Override
    public QnaDTO view(String qnaIdx) {
        QnaVO qnaVO = qnaMapper.view(qnaIdx);
        return modelMapper.map(qnaVO, QnaDTO.class);
    }

    @Override
    public boolean createQ(QnaDTO qnaDTO) {
        QnaVO qnaVO = modelMapper.map(qnaDTO, QnaVO.class);
        return qnaMapper.createQ(qnaVO);
    }

    @Override
    public boolean updateA(QnaDTO qnaDTO) {
        QnaVO qnaVO = modelMapper.map(qnaDTO, QnaVO.class);
        return qnaMapper.updateA(qnaVO);
    }

    @Override
    public boolean delete(String qnaIdx) {
        return qnaMapper.delete(qnaIdx);
    }

    @Override
    public int totalCount(SearchDTO searchDTO) {
        return qnaMapper.totalCount(searchDTO);
    }

    @Override
    public List<QnaDTO> myQna(SearchDTO searchDTO, PageRequestDTO pageRequestDTO, String qnaQMemberId) {
        return qnaMapper.myQna(searchDTO, pageRequestDTO, qnaQMemberId);
    }
}
