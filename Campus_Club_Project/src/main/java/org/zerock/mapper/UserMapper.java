package org.zerock.mapper;

import org.zerock.domain.UserVO;

public interface UserMapper {

	// 회원가입
    public void register(UserVO user);

    // 로그인 (및 회원정보 읽기)
    public UserVO read(String user_email);
    
    // (AJAX) 이메일 중복 확인
    public int checkEmail(String user_email);
    
    // [추가] 아이디 찾기 (이름, 학번 기준)
    public String findIdByNameAndStudentId(UserVO user);
    
    // [추가] 비밀번호 재설정을 위한 사용자 확인 (이메일, 이름, 학번 기준)
    public UserVO findUserForPwReset(UserVO user);
    
    // [추가] 비밀번호 업데이트
    public int updatePassword(UserVO user);
}