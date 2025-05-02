package net.spb.spb.service;

import net.spb.spb.dto.PostDTO;
import net.spb.spb.dto.PostPageDTO;

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
}
