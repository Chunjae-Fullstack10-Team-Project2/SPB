package net.spb.spb.mapper.lecture;

import net.spb.spb.domain.MemberVO;

import java.util.List;

public interface LectureRegisterMapper {
    public int selectStudentListTotalCountByIdx(int idx);
    public List<MemberVO> selectStudentListByIdx(int Idx);
}
