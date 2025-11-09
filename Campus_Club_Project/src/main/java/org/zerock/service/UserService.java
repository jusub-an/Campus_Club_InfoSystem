package org.zerock.service;

import org.zerock.domain.UserVO;

public interface UserService {

	// 회원가입
    public void register(UserVO user);
    
    // 로그인
    public UserVO login(UserVO user);
    
    // (AJAX) 이메일 중복 확인
    public int emailCheck(String user_email);
    
    // [추가] 아이디 찾기
    public String findId(UserVO user);
    
    // [추가] 비밀번호 재설정 사용자 확인
    public UserVO findUserForPwReset(UserVO user);
    
    // [추가] 비밀번호 재설정
    public boolean resetPassword(UserVO user);
}