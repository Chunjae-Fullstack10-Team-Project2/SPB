package net.spb.spb.mapper.mystudy;

import net.spb.spb.domain.PlanVO;
import net.spb.spb.dto.mystudy.PlanDetailResponseDTO;
import net.spb.spb.dto.mystudy.PlanResponseDTO;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

public interface PlanMapper {
    public int insert(PlanVO planVO);
    public List<PlanResponseDTO> selectList(@Param("memberId") String memberId, @Param("date") YearMonth date);
    public List<PlanDetailResponseDTO> selectTodayList(@Param("memberId") String memberId, @Param("date") LocalDate date);
    public PlanDetailResponseDTO selectOne(int idx);
    public int update(PlanVO planVO);
    public int delete(int idx);
}
