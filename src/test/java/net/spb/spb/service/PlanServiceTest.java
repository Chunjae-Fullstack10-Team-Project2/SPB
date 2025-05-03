package net.spb.spb.service;

import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.PlanDTO;
import net.spb.spb.dto.PlanListRequestDTO;
import net.spb.spb.dto.PlanListResponseDTO;
import net.spb.spb.dto.PlanResponseDTO;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/root-context.xml")
public class PlanServiceTest {
    @Autowired(required = false)
    PlanServiceIf planService;

    @Test
    public void testInsert() {
        PlanDTO planDTO = PlanDTO.builder()
                .planLectureIdx(1)
                .planMemberId("user1")
                .planContent("Service > Insert Test")
                .planDate(LocalDate.now())
                .build();
        int result = planService.insert(planDTO);
        log.info("PlanServiceTest >> testInsert >> result : {}", result);
    }

    @Test
    public void testSelectList() {
        PlanListRequestDTO requestDTO = PlanListRequestDTO.builder()
                .memberId("user1")
                .currentMonth(YearMonth.now())
                .build();
        List<PlanListResponseDTO> list = planService.selectList(requestDTO);
        log.info("PlanServiceTest >> testSelectList >> list : {}", list);
    }

    @Test
    public void testSelectOne() {
        PlanResponseDTO planDTO = planService.selectOne(1);
        log.info("PlanServiceTest >> testSelectOne >> planDTO : {}", planDTO);
    }

    @Test
    public void testUpdate() {
        PlanDTO planDTO = PlanDTO.builder()
                .planIdx(1)
                .planLectureIdx(1)
                .planContent("Service > update Test")
                .planDate(LocalDate.now())
                .build();
        int result = planService.update(planDTO);
        log.info("PlanServiceTest >> testUpdate >> result : {}", result);
    }

    @Test
    public void testDelete() {
        int result = planService.delete(1);
        log.info("PlanServiceTest >> testDelete >> result : {}", result);
    }
}
