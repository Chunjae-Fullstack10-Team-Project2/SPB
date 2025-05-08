package net.spb.spb.service.faq;

import net.spb.spb.domain.FaqVO;
import net.spb.spb.domain.QnaVO;
import net.spb.spb.dto.FaqDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.dto.qna.QnaDTO;
import net.spb.spb.mapper.FaqMapper;
import net.spb.spb.mapper.QnaMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FaqServiceImpl implements FaqService {
    private final ModelMapper modelMapper;
    private final FaqMapper faqMapper;

    public FaqServiceImpl(ModelMapper modelMapper, FaqMapper faqMapper) {
        this.modelMapper = modelMapper;
        this.faqMapper = faqMapper;
    }

    @Override
    public List<QnaDTO> faqList(SearchDTO searchDTO, PageRequestDTO pageRequestDTO) {
        return faqMapper.faqList(searchDTO, pageRequestDTO);
    }

    @Override
    public boolean create(FaqDTO faqDTO) {
        FaqVO faqVO = modelMapper.map(faqDTO, FaqVO.class);
        return faqMapper.create(faqVO);
    }

    @Override
    public boolean update(FaqDTO faqDTO) {
        FaqVO faqVO = modelMapper.map(faqDTO, FaqVO.class);
        return faqMapper.update(faqVO);
    }

    @Override
    public boolean delete(String faqIdx) {
        return faqMapper.delete(faqIdx);
    }

    @Override
    public int totalCount(SearchDTO searchDTO) {
        return faqMapper.totalCount(searchDTO);
    }
}
