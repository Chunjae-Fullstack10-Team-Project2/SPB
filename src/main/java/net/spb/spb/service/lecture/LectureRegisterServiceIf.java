package net.spb.spb.service.lecture;

import net.spb.spb.dto.member.MemberDTO;

import java.util.List;

public interface LectureRegisterServiceIf {
    public int getStudentListTotalCountByIdx(int idx);
    public List<MemberDTO> getStudentListByIdx(int idx);
}
