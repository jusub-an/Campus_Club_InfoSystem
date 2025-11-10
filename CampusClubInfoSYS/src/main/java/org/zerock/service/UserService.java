package org.zerock.service;

import org.zerock.domain.UserDTO;

public interface UserService {

	// 회원가입
    public void register(UserDTO user);
    
    // 로그인
    public UserDTO login(UserDTO user);
    
    // (AJAX) 이메일 중복 확인
    public int emailCheck(String user_email);
    
    // [추가] 아이디 찾기
    public String findId(UserDTO user);
    
    // [추가] 비밀번호 재설정 사용자 확인
    public UserDTO findUserForPwReset(UserDTO user);
    
    // [추가] 비밀번호 재설정
    public boolean resetPassword(UserDTO user);
}