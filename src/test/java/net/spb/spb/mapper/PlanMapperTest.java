package net.spb.spb.mapper;

import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.PlanVO;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.time.LocalDate;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/root-context.xml")
public class PlanMapperTest {
    @Autowired(required = false)
    PlanMapper planMapper;

    @Test
    public void testInsert() {
        PlanVO vo = PlanVO.builder()
                .planLectureIdx(1)
                .planMemberId("user1")
                .planContent("계획 등록 테스트")
                .planDate(LocalDate.now())
                .build();
        int result = planMapper.insert(vo);
        log.info("PlanMapperTest >> testInsert >> result : {}", result);
    }

//    @Test
//    public void testSelectList() {
//        PlanListRequestDTO requestDTO = PlanListRequestDTO.builder()
//                .memberId("user1")
//                .currentMonth(YearMonth.now())
//                .build();
//        List<PlanVO> list = planMapper.selectList(requestDTO);
//        log.info("PlanMapperTest >> testSelectList >> list : {}", list);
//    }
//
//    @Test
//    public void testSelectOne() {
//        PlanVO vo = planMapper.selectOne(1);
//        log.info("PlanMapperTest >> testSelectOne >> vo : {}", vo);
//    }

    @Test
    public void testUpdate() {
        PlanVO vo = PlanVO.builder()
                .planIdx(1)
                .planLectureIdx(1)
                .planContent("계획 수정 테스트")
                .planDate(LocalDate.now())
                .build();
        int result = planMapper.update(vo);
        log.info("PlanMapperTest >> testUpdate >> result : {}", result);
    }

    @Test
    public void testDelete() {
        int result = planMapper.delete(1);
        log.info("PlanMapperTest >> testDelete >> result : {}", result);
    }
}
