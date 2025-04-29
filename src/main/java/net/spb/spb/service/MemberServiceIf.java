package net.spb.spb.service;

import net.spb.spb.dto.MemberDTO;

public interface MemberServiceIf {
    int login(MemberDTO memberDTO);
    boolean existUser(String userId);
    boolean join(MemberDTO memberDTO);
}
