package net.spb.spb.mapper;

import net.spb.spb.domain.PlanVO;
import net.spb.spb.dto.PlanListRequestDTO;

import java.util.List;

public interface PlanMapper {
    public int insert(PlanVO planVO);
    public List<PlanVO> selectList(PlanListRequestDTO requestDTO);
    public PlanVO selectOne(int idx);
    public int update(PlanVO planVO);
    public int delete(int idx);
}
