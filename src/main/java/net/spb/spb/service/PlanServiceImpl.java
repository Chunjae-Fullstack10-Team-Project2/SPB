package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.PlanVO;
import net.spb.spb.dto.PlanDTO;
import net.spb.spb.dto.PlanListRequestDTO;
import net.spb.spb.dto.PlanListResponseDTO;
import net.spb.spb.dto.PlanResponseDTO;
import net.spb.spb.mapper.PlanMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Log4j2
@Service
@Transactional
@RequiredArgsConstructor
public class PlanServiceImpl implements PlanServiceIf {
    private final PlanMapper planMapper;
    private final ModelMapper modelMapper;

    @Override
    public int insert(PlanDTO planDTO) {
        PlanVO planVO = modelMapper.map(planDTO, PlanVO.class);
        int result = planMapper.insert(planVO);
        return result;
    }

    @Override
    public List<PlanListResponseDTO> selectList(PlanListRequestDTO requestDTO) {
        List<PlanVO> planVOList = planMapper.selectList(requestDTO);
        List<PlanListResponseDTO> planDTOList =
                planVOList.stream().map(
                    vo -> modelMapper.map(vo, PlanListResponseDTO.class)
                ).collect(Collectors.toList());
        return planDTOList;
    }

    @Override
    public PlanResponseDTO selectOne(int idx) {
        PlanVO planVO = planMapper.selectOne(idx);
        return modelMapper.map(planVO, PlanResponseDTO.class);
    }

    @Override
    public int update(PlanDTO planDTO) {
        PlanVO planVO = modelMapper.map(planDTO, PlanVO.class);
        int result = planMapper.update(planVO);
        return result;
    }

    @Override
    public int delete(int idx) {
        int result = planMapper.delete(idx);
        return result;
    }
}
