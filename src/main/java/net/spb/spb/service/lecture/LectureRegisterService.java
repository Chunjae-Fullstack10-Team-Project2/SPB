package net.spb.spb.service.lecture;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.MemberVO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.mapper.lecture.LectureRegisterMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Log4j2
@Service
@RequiredArgsConstructor
public class LectureRegisterService implements LectureRegisterServiceIf {

    private final ModelMapper modelMapper;
    private final LectureRegisterMapper lectureRegisterMapper;

    @Override
    public int getStudentListTotalCountByIdx(int idx) {
        return lectureRegisterMapper.selectStudentListTotalCountByIdx(idx);
    }

    @Override
    public List<MemberDTO> getStudentListByIdx(int idx) {
        List<MemberVO> voList = lectureRegisterMapper.selectStudentListByIdx(idx);
        return voList.stream().map(
                vo -> modelMapper.map(vo, MemberDTO.class)
        ).collect(Collectors.toList());
    }
}
