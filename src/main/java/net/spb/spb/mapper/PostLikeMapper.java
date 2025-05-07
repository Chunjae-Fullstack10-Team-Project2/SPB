package net.spb.spb.mapper;

import net.spb.spb.dto.post.PostLikeRequestDTO;

public interface PostLikeMapper {
    int insertLike(PostLikeRequestDTO postLikeRequestDTO);

    int deleteLike(PostLikeRequestDTO postLikeRequestDTO);
}
