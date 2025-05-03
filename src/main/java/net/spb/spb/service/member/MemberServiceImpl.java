package net.spb.spb.service.member;

import net.spb.spb.domain.MemberVO;
import net.spb.spb.dto.member.MemberDTO;
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

    @Override
    public int login(MemberDTO memberDTO) {
        MemberVO memberVO = modelMapper.map(memberDTO, MemberVO.class);
        return memberMapper.login(memberVO);
    }

    @Override
    public boolean existUser(String userId) {
        MemberVO memberVO = memberMapper.existUser(userId);
        return memberVO != null;
    }

    @Override
    public boolean join(MemberDTO memberDTO) {
        MemberVO memberVO = modelMapper.map(memberDTO, MemberVO.class);
        boolean result = memberMapper.join(memberVO);
        return result;
    }

    @Override
    public MemberDTO getMemberById(String memberId) {
        MemberVO memberVO = memberMapper.getMemberById(memberId);
        return modelMapper.map(memberVO, MemberDTO.class);
    }

    @Override
    public boolean updateMember(MemberDTO memberDTO) {
        MemberVO memberVO = modelMapper.map(memberDTO, MemberVO.class);
        return memberMapper.updateMember(memberVO);
    }

    @Override
    public String getPwdById(String memberId) {
        return memberMapper.getPwdById(memberId);
    }

}
