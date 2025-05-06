package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.PostLikeRequestDTO;
import net.spb.spb.dto.PostReportDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.mapper.MyPageMapper;
import org.springframework.stereotype.Service;

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
}
