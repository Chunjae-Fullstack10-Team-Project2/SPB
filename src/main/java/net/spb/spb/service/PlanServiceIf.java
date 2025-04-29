package net.spb.spb.service;

import net.spb.spb.dto.PlanDTO;
import net.spb.spb.dto.PlanRequestDTO;

import java.util.List;

public interface PlanServiceIf {
    public int insert(PlanDTO planDTO);
    public List<PlanDTO> selectList(PlanRequestDTO requestDTO);
    public PlanDTO selectOne(int idx);
    public int update(PlanDTO planDTO);
    public int delete(int idx);
}
