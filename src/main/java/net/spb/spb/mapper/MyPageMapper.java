package net.spb.spb.mapper;

import net.spb.spb.dto.BookmarkDTO;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.post.PostCommentDTO;
import net.spb.spb.dto.post.PostDTO;
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

    // 주문번호만 페이징해서 가져오기
    List<Integer> listMyOrdersByPage(@Param("searchDTO") SearchDTO searchDTO, @Param("pageDTO") PageRequestDTO pageDTO, @Param("orderMemberId") String orderMemberId);

    // 주문번호 기반으로 강좌까지 포함된 주문 상세 조회
    List<OrderDTO> listLecturesByOrderIdxList(@Param("orderIdxList") List<Integer> orderIdxList, @Param("searchDTO") SearchDTO searchDTO);

    boolean updateOrderStatus(@Param("orderIdx") int orderIdx,
                              @Param("orderStatus") String orderStatus,
                              @Param("memberId") String memberId);

    boolean changePwd(@Param("memberPwd") String memberPwd, @Param("memberId") String memberId);

    boolean deleteReport(@Param("reportIdx") String reportIdx);

    boolean cancelLike(@Param("postIdx") int postIdx);

    List<BookmarkDTO> listMyBookmark(@Param("searchDTO") SearchDTO searchDTO, @Param("pageDTO") PageRequestDTO pageDTO,
                                     @Param("bookmarkMemberId") String bookmarkMemberId);

    int bookmarkTotalCount(@Param("searchDTO") SearchDTO searchDTO, @Param("bookmarkMemberId") String bookmarkMemberId);

    boolean cancelBookmark(@Param("bookmarkIdx") int bookmarkIdx);

    List<PostDTO> listMyPost(@Param("searchDTO") SearchDTO searchDTO, @Param("pageDTO") PageRequestDTO pageDTO,
                             @Param("postMemberId") String postMemberId);

    int postTotalCount(@Param("searchDTO") SearchDTO searchDTO, @Param("postMemberId") String postMemberId);

    List<PostCommentDTO> listMyComment(@Param("searchDTO") SearchDTO searchDTO,
                                       @Param("pageDTO") PageRequestDTO pageDTO,
                                       @Param("postCommentMemberId") String postCommentMemberId);

    int commentTotalCount(@Param("searchDTO") SearchDTO searchDTO,
                          @Param("postCommentMemberId") String postCommentMemberId);

}