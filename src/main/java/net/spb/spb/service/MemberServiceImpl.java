package net.spb.spb.service;

import net.spb.spb.domain.MemberVO;
import net.spb.spb.dto.MemberDTO;
import net.spb.spb.mapper.MemberMapper;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberServiceImpl {

    private final ModelMapper modelMapper;

    private final MemberMapper memberMapper;

    @Autowired
    public MemberServiceImpl(ModelMapper modelMapper, MemberMapper memberMapper) {
        this.modelMapper = modelMapper;
        this.memberMapper = memberMapper;
    }

    public int login(MemberDTO memberDTO) {
        MemberVO memberVO = modelMapper.map(memberDTO, MemberVO.class);
        return memberMapper.login(memberVO);
    }

    public boolean autoLogin(String userId) {
        MemberVO memberVO = memberMapper.existUser(userId);
        return memberVO != null;
    }

}
