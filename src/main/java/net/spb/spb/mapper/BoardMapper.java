package net.spb.spb.mapper;

import net.spb.spb.domain.PostVO;
import net.spb.spb.domain.ReportVO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.PostPageDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.dto.post.PostDTO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface BoardMapper {
    int getPostCount(PostPageDTO postPageDTO);

    List<PostDTO> getPosts(PostPageDTO postPageDTO);

    PostDTO getPostByIdx(int postIdx);

    PostDTO getPostByIdxWithLike(HashMap<String, Object> param);

    int insertPost(PostVO vo);

    int modifyPost(PostVO vo);

    int deletePost(int postIdx);

    int setReadCnt(int postIdx);

    int insertPostReport(ReportVO postReportVO);

    //    news
    List<Map<String, Object>> selectNewsList(SearchDTO searchDTO, PageRequestDTO pageRequestDTO);

    int selectNewsTotalCount(SearchDTO searchDTO);
}
