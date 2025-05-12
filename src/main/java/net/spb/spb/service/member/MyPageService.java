package net.spb.spb.service.member;

import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.BookmarkDTO;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.post.PostDTO;
import net.spb.spb.dto.post.PostLikeRequestDTO;
import net.spb.spb.dto.post.PostReportDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.mapper.MyPageMapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MyPageService {
    public final MyPageMapper myPageMapper;

    public List<PostLikeRequestDTO> listMyLikes(SearchDTO searchDTO, PageRequestDTO pageRequestDTO, String postLikeMemberId) {
        return myPageMapper.listMyLikes(searchDTO, pageRequestDTO, postLikeMemberId);
    }

    public int likesTotalCount(SearchDTO searchDTO, String postLikeMemberId) {
        return myPageMapper.likesTotalCount(searchDTO, postLikeMemberId);
    }

    public List<PostReportDTO> listMyReport(SearchDTO searchDTO, PageRequestDTO pageRequestDTO, String reportMemberId) {
        return myPageMapper.listMyReport(searchDTO, pageRequestDTO, reportMemberId);
    }

    public int reportTotalCount(SearchDTO searchDTO, String reportMemberId) {
        return myPageMapper.reportTotalCount(searchDTO, reportMemberId);
    }

    public List<OrderDTO> listMyOrder(SearchDTO searchDTO, PageRequestDTO pageRequestDTO, String orderMemberId) {
        return myPageMapper.listMyOrder(searchDTO, pageRequestDTO, orderMemberId);
    }

    public int orderTotalCount(SearchDTO searchDTO, String orderMemberId) {
        return myPageMapper.orderTotalCount(searchDTO, orderMemberId);
    }

    public List<Integer> getPagedOrderIdxList(SearchDTO searchDTO, PageRequestDTO pageRequestDTO, String memberId) {
        return myPageMapper.listMyOrdersByPage(searchDTO, pageRequestDTO, memberId);
    }

    public List<OrderDTO> getOrdersWithLectures(List<Integer> orderIdxList, SearchDTO searchDTO) {
        if (orderIdxList == null || orderIdxList.isEmpty()) return Collections.emptyList();
        return myPageMapper.listLecturesByOrderIdxList(orderIdxList, searchDTO);
    }

    public boolean confirmOrder(int orderIdx, String orderStatus, String memberId) {
        return myPageMapper.updateOrderStatus(orderIdx, "f", memberId);
    }

    public boolean requestRefund(int orderIdx, String orderStatus, String memberId) {
        return myPageMapper.updateOrderStatus(orderIdx, "r", memberId);
    }

    public boolean orderCancel(int orderIdx, String orderStatus, String memberId) {
        return myPageMapper.updateOrderStatus(orderIdx, "c", memberId);
    }

    public boolean changePwd(String memberPwd, String memberId) {
        return myPageMapper.changePwd(memberPwd, memberId);
    }

    public boolean deleteReport(String reportIdx) {
        return myPageMapper.deleteReport(reportIdx);
    }

    public boolean cancelLike(int postIdx) {
        return myPageMapper.cancelLike(postIdx);
    }

    public List<BookmarkDTO> listMyBookmark(SearchDTO searchDTO, PageRequestDTO pageRequestDTO, String postLikeMemberId) {
        return myPageMapper.listMyBookmark(searchDTO, pageRequestDTO, postLikeMemberId);
    }

    public int bookmarkTotalCount(SearchDTO searchDTO, String postLikeMemberId) {
        return myPageMapper.bookmarkTotalCount(searchDTO, postLikeMemberId);
    }

    public boolean cancelBookmark(int bookmarkIdx) {
        return myPageMapper.cancelBookmark(bookmarkIdx);
    }

    public List<PostDTO> listMyPost(SearchDTO searchDTO, PageRequestDTO pageRequestDTO, String postMemberId) {
        return myPageMapper.listMyPost(searchDTO, pageRequestDTO, postMemberId);
    }

    public int postTotalCount(SearchDTO searchDTO, String postMemberId) {
        return myPageMapper.postTotalCount(searchDTO, postMemberId);
    }
}
