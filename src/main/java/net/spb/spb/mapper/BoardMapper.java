package net.spb.spb.mapper;

import net.spb.spb.domain.PostVO;
import net.spb.spb.dto.PostPageDTO;

import java.util.List;

public interface BoardMapper {
    int getPostCount(PostPageDTO postPageDTO);
    List<PostVO> getPosts(PostPageDTO postPageDTO);
    PostVO getPostByIdx(int postIdx);
    int insertPost(PostVO vo);
    int modifyPost(PostVO vo);
    int deletePost(int postIdx);

}
