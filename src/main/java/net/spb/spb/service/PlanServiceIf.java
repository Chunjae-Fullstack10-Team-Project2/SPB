package net.spb.spb.service;

import net.spb.spb.dto.PlanDTO;
import net.spb.spb.dto.PlanListRequestDTO;
import net.spb.spb.dto.PlanListResponseDTO;
import net.spb.spb.dto.PlanResponseDTO;

import java.util.List;

public interface PlanServiceIf {
    public int insert(PlanDTO planDTO);
    public List<PlanListResponseDTO> selectList(PlanListRequestDTO requestDTO);
    public PlanResponseDTO selectOne(int idx);
    public int update(PlanDTO planDTO);
    public int delete(int idx);
}
