package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.PostLikeRequestDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.mapper.PostLikeMapper;
import org.springframework.stereotype.Service;

import java.util.List;

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

    public List<PostLikeRequestDTO> listMyLikes(SearchDTO searchDTO, PageRequestDTO pageRequestDTO, String postLikeMemberId) {
        return postLikeMapper.listMyLikes(searchDTO, pageRequestDTO, postLikeMemberId);
    }

    public int totalCount(SearchDTO searchDTO, String postLikeMemberId) {
        return postLikeMapper.totalCount(searchDTO, postLikeMemberId);
    }
}
