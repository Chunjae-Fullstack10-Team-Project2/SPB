package net.spb.spb.service;

import net.spb.spb.domain.MemberVO;
import net.spb.spb.dto.MemberDTO;
import net.spb.spb.mapper.MemberMapper;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberServiceImpl implements MemberServiceIf {

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

    public boolean existUser(String userId) {
        MemberVO memberVO = memberMapper.existUser(userId);
        return memberVO != null;
    }

    @Override
    public boolean join(MemberDTO memberDTO) {
        MemberVO memberVO = modelMapper.map(memberDTO, MemberVO.class);
        boolean result = memberMapper.join(memberVO);
        System.out.println("회원가입 결과: " + result);
        return result;
    }

}
