package net.spb.spb.mapper;

import net.spb.spb.domain.PostVO;

import java.util.List;

public interface BoardMapper {
    List<PostVO> getPosts(String postCategory);
    PostVO getPostByIdx(int postIdx);
    int insertPost(PostVO vo);
    int modifyPost(PostVO vo);
    int deletePost(int postIdx);

}
