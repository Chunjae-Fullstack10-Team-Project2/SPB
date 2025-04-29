package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.PostVO;
import net.spb.spb.dto.PostDTO;
import net.spb.spb.mapper.BoardMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Log4j2
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardServiceIf{

    private final BoardMapper boardMapper;
    private final ModelMapper modelMapper;

    /**
     * @param dto
     * @return
     */
    @Override
    public int insertPost(PostDTO dto) {
        PostVO vo = modelMapper.map(dto, PostVO.class);
        int rtnResult = boardMapper.insertPost(vo);
        log.info("=============================");
        log.info("BoardServiceImpl  >>  insertPost");
        log.info("vo: " + vo);
        log.info("dto: " + dto);
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");
        return rtnResult;
    }

    /**
     * @param dto
     * @return
     */
    @Override
    public int modifyPost(PostDTO dto) {
        PostVO vo = modelMapper.map(dto, PostVO.class);
        int rtnResult = boardMapper.modifyPost(vo);
        log.info("=============================");
        log.info("BoardServiceImpl  >>  insertPost");
        log.info("vo: " + vo);
        log.info("dto: " + dto);
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");
        return rtnResult;
    }

    /**
     * @param postIdx
     * @return
     */
    @Override
    public int deletePost(int postIdx) {
        int rtnResult = boardMapper.deletePost(postIdx);
        log.info("=============================");
        log.info("BoardServiceImpl  >>  insertPost");
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");
        return rtnResult;
    }

    /**
     * @return
     */
    @Override
    public List<PostDTO> getPosts() {
        List<PostVO> vos = boardMapper.getPosts("FREEBOARD");
        List<PostDTO> dtos = vos.stream().map(vo -> modelMapper.map(vo, PostDTO.class)).collect(Collectors.toList());
        log.info("=============================");
        log.info("BoardServiceImpl  >>  getPosts");
        log.info(dtos);
        log.info("=============================");
        return dtos;
    }

    /**
     * @param postIdx
     * @return
     */
    @Override
    public PostDTO getPostByIdx(int postIdx) {
        PostDTO dto = modelMapper.map(boardMapper.getPostByIdx(postIdx), PostDTO.class);
        log.info("=============================");
        log.info("BoardServiceImpl  >>  getPostByIdx");
        log.info(dto);
        log.info("=============================");
        return dto;
    }
}
