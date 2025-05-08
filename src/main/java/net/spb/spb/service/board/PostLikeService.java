package net.spb.spb.service.board;

import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.post.PostLikeRequestDTO;
import net.spb.spb.mapper.PostLikeMapper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PostLikeService {
    public final PostLikeMapper postLikeMapper;

    public int insertLike(PostLikeRequestDTO postLikeRequestDTO) {
        return postLikeMapper.insertLike(postLikeRequestDTO);
    }

    public int deleteLike(PostLikeRequestDTO postLikeRequestDTO) {
        return postLikeMapper.deleteLike(postLikeRequestDTO);
    }
}
