package net.spb.spb.service.board;

import net.spb.spb.dto.post.PostDTO;
import net.spb.spb.dto.pagingsearch.PostPageDTO;
import net.spb.spb.dto.post.PostReportDTO;

import java.util.HashMap;
import java.util.List;

public interface BoardServiceIf {
    int insertPost(PostDTO dto);
    int modifyPost(PostDTO dto);
    int deletePost(int postIdx);
    List<PostDTO> getPosts(PostPageDTO postPageDTO);
    PostDTO getPostByIdx(int postIdx);
    PostDTO getPostByIdx(HashMap<String, Object> param);
    int getPostCount(PostPageDTO postPageDTO);
    int setReadCnt(int postIdx);
    int insertPostReport(PostReportDTO postReportDTO);
}
