package net.spb.spb.mapper;

import net.spb.spb.dto.PostLikeRequestDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PostLikeMapper {
    int insertLike(PostLikeRequestDTO postLikeRequestDTO);

    int deleteLike(PostLikeRequestDTO postLikeRequestDTO);

    List<PostLikeRequestDTO> listMyLikes(@Param("searchDTO") SearchDTO searchDTO, @Param("pageDTO") PageRequestDTO pageDTO, @Param("postLikeMemberId") String postLikeMemberId);

    int totalCount(@Param("searchDTO") SearchDTO searchDTO, @Param("postLikeMemberId") String postLikeMemberId);
}
