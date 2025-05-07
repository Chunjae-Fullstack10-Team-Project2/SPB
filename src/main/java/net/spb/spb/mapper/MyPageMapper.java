package net.spb.spb.mapper;

import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.post.PostLikeRequestDTO;
import net.spb.spb.dto.post.PostReportDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MyPageMapper {

    List<PostLikeRequestDTO> listMyLikes(@Param("searchDTO") SearchDTO searchDTO, @Param("pageDTO") PageRequestDTO pageDTO, @Param("postLikeMemberId") String postLikeMemberId);

    int likesTotalCount(@Param("searchDTO") SearchDTO searchDTO, @Param("postLikeMemberId") String postLikeMemberId);

    List<PostReportDTO> listMyReport(@Param("searchDTO") SearchDTO searchDTO, @Param("pageDTO") PageRequestDTO pageRequestDTO, @Param("reportMemberId") String reportMemberId);

    int reportTotalCount(@Param("searchDTO") SearchDTO searchDTO, @Param("reportMemberId") String reportMemberId);

    List<OrderDTO> listMyOrder(@Param("searchDTO") SearchDTO searchDTO, @Param("pageDTO") PageRequestDTO pageDTO, @Param("orderMemberId") String orderMemberId);

    int orderTotalCount(@Param("searchDTO") SearchDTO searchDTO, @Param("orderMemberId") String orderMemberId);
}