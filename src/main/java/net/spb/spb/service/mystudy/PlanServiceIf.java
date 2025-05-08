package net.spb.spb.service.mystudy;

import net.spb.spb.dto.mystudy.PlanDTO;
import net.spb.spb.dto.mystudy.PlanResponseDTO;

import java.time.LocalDate;
import java.util.List;

public interface PlanServiceIf {
    public int insert(PlanDTO planDTO);
    public List<PlanResponseDTO> getPlanListByDay(String memberId, LocalDate date);
    public List<PlanResponseDTO> getPlanListByMonth(String memberId, LocalDate date1, LocalDate date2);
    public PlanResponseDTO getPlanByIdx(int idx);
    public int update(PlanDTO planDTO);
    public int delete(int idx);
}
