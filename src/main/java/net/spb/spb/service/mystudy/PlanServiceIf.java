package net.spb.spb.service.mystudy;

import net.spb.spb.dto.PlanDTO;
import net.spb.spb.dto.mystudy.PlanDetailResponseDTO;
import net.spb.spb.dto.mystudy.PlanResponseDTO;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

public interface PlanServiceIf {
    public int insert(PlanDTO planDTO);
    public List<PlanResponseDTO> selectList(String memberId, YearMonth date);
    public List<PlanDetailResponseDTO> selectTodayList(String memberId, LocalDate date);
    public PlanDetailResponseDTO selectOne(int idx);
    public int update(PlanDTO planDTO);
    public int delete(int idx);
}
