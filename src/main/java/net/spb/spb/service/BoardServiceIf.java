package net.spb.spb.service;

import net.spb.spb.dto.PostDTO;

import java.util.List;

public interface BoardServiceIf {
    int insertPost(PostDTO dto);
    int modifyPost(PostDTO dto);
    int deletePost(int postIdx);
    List<PostDTO> getPosts();
    PostDTO getPostByIdx(int postIdx);
}
