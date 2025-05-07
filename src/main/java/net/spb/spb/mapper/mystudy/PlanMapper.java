package net.spb.spb.mapper.mystudy;

import net.spb.spb.domain.PlanVO;
import net.spb.spb.dto.mystudy.PlanResponseDTO;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

public interface PlanMapper {
    public int insert(PlanVO planVO);
    public List<PlanResponseDTO> selectPlanListByDay(@Param("memberId") String memberId, @Param("date") LocalDate date);
    public List<PlanResponseDTO> selectPlanListByMonth(@Param("memberId") String memberId, @Param("date1") LocalDate date1, @Param("date2") LocalDate date2);
    public PlanResponseDTO selectPlanByIdx(int idx);
    public int update(PlanVO planVO);
    public int delete(int idx);
}
