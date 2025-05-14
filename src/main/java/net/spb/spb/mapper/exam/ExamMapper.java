//package net.spb.spb.mapper.exam;
//
//import net.spb.spb.dto.exam.ExamResponseDTO;
//import org.apache.ibatis.annotations.Param;
//
//import java.util.List;
//
//public interface ExamMapper {
//    public int insertExam(ExamVO examVO);
//    public List<ExamResponseDTO> selectExamListByTeacherId(@Param("teacherId") String teacherId, @Param("pageDTO") ExamPageDTO pageDTO);
//    public ExamResponseDTO selectExamByIdx(int idx);
//    public int deleteExamByIdx(int idx);
//
//    public int selectExamTotalCountByTeacherId(@Param("teacherId") String teacherId, @Param("pageDTO") ExamPageDTO pageDTO);
//}
