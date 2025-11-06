package org.zerock.service;

import java.util.List;

import org.zerock.domain.ApplicationDTO;
import org.zerock.domain.MemberDTO;

public interface ApplicationService {
    // 동아리 가입 신청
	public List<ApplicationDTO> getApplyList();
	// 신청 결과를 boolean으로 반환하도록 수정 (성공/실패)
    public boolean apply(ApplicationDTO dto);
    public String getName(String email);
    // 동아리 회원 관리
    public List<MemberDTO> getMemberList();
    public void approve(MemberDTO memberDTO, Long app_id); 
    public void reject(Long app_id);
    // 회원을 추방(삭제)하는 메서드
    public void expel(MemberDTO memberDTO);
}
