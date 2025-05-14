package net.spb.spb.service.exam;

import net.spb.spb.dto.exam.ExamDTO;
import net.spb.spb.dto.exam.ExamResponseDTO;
import net.spb.spb.dto.pagingsearch.ExamPageDTO;

import java.util.List;

public interface ExamServiceIf {
    public int createExam(ExamDTO examDTO);
    public List<ExamResponseDTO> getExamListByTeacherId(String teacherId, ExamPageDTO pageDTO);
    public ExamResponseDTO getExamByIdx(int idx);
    public int deleteExamByIdx(int idx);

    public int getExamTotalCountByTeacherId(String teacherId, ExamPageDTO pageDTO);
}
