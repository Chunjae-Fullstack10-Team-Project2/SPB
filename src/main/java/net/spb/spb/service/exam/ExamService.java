//package net.spb.spb.service.exam;
//
//import lombok.RequiredArgsConstructor;
//import lombok.extern.log4j.Log4j2;
//import net.spb.spb.dto.exam.ExamDTO;
//import net.spb.spb.dto.exam.ExamResponseDTO;
//import net.spb.spb.mapper.exam.ExamMapper;
//import org.modelmapper.ModelMapper;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//
//@Log4j2
//@Service
//@RequiredArgsConstructor
//public class ExamService implements ExamServiceIf {
//    private final ModelMapper modelMapper;
//    private final ExamMapper examMapper;
//
//
//    @Override
//    public int createExam(ExamDTO examDTO) {
//        ExamVO vo = modelMapper.map(examDTO, ExamVO.class);
//        return examMapper.insertExam(vo);
//    }
//
//    @Override
//    public List<ExamResponseDTO> getExamListByTeacherId(String teacherId, ExamPageDTO pageDTO) {
//        return examMapper.selectExamListByTeacherId(teacherId, pageDTO);
//    }
//
//    @Override
//    public ExamResponseDTO getExamByIdx(int idx) {
//        return examMapper.selectExamByIdx(idx);
//    }
//
//    @Override
//    public int deleteExamByIdx(int idx) {
//        return examMapper.deleteExamByIdx(idx);
//    }
//
//    @Override
//    public int getExamTotalCountByTeacherId(String teacherId, ExamPageDTO pageDTO) {
//        return examMapper.selectExamTotalCountByTeacherId(teacherId, pageDTO);
//    }
//}
