package net.spb.spb.mapper;

import net.spb.spb.domain.ReportVO;
import net.spb.spb.domain.PostVO;
import net.spb.spb.dto.PostPageDTO;

import java.util.HashMap;
import java.util.List;

public interface BoardMapper {
    int getPostCount(PostPageDTO postPageDTO);
    List<PostVO> getPosts(PostPageDTO postPageDTO);
    PostVO getPostByIdx(int postIdx);
    PostVO getPostByIdxWithLike(HashMap<String, Object> param);
    int insertPost(PostVO vo);
    int modifyPost(PostVO vo);
    int deletePost(int postIdx);
    int setReadCnt(int postIdx);
    int insertPostReport(ReportVO reportVO);
}
