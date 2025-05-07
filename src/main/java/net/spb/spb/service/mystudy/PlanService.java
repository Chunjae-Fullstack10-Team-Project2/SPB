package net.spb.spb.service.mystudy;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.PlanVO;
import net.spb.spb.dto.PlanDTO;
import net.spb.spb.dto.mystudy.PlanResponseDTO;
import net.spb.spb.mapper.mystudy.PlanMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Log4j2
@Service
@Transactional
@RequiredArgsConstructor
public class PlanService implements PlanServiceIf {
    private final ModelMapper modelMapper;
    private final PlanMapper planMapper;

    @Override
    public int insert(PlanDTO planDTO) {
        PlanVO planVO = modelMapper.map(planDTO, PlanVO.class);
        int result = planMapper.insert(planVO);
        return result;
    }

    @Override
    public List<PlanResponseDTO> getPlanListByDay(String memberId, LocalDate date) {
        return planMapper.selectPlanListByDay(memberId, date);
    }

    @Override
    public List<PlanResponseDTO> getPlanListByMonth(String memberId, LocalDate date1, LocalDate date2) {
        return planMapper.selectPlanListByMonth(memberId, date1, date2);
    }

    @Override
    public PlanResponseDTO getPlanByIdx(int idx) {
        return planMapper.selectPlanByIdx(idx);
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
