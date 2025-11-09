package org.zerock.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.zerock.domain.UserVO;
import org.zerock.mapper.UserMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class UserServiceImpl implements UserService {

    @Setter(onMethod_ = @Autowired)
    private UserMapper mapper;

    // 비밀번호 암호화를 위해 BCryptPasswordEncoder 주입
    // (root-context.xml 또는 SecurityConfig 등에 Bean으로 등록되어 있어야 함)
    @Setter(onMethod_ = @Autowired)
    private BCryptPasswordEncoder passwordEncoder;

    @Override
    public void register(UserVO user) {
        log.info("register......" + user);
        
        // 1. 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(user.getPassword());
        user.setPassword(encodedPassword);

        // 2. DB에 등록
        mapper.register(user);
    }

    @Override
    public UserVO login(UserVO user) {
        log.info("login......" + user.getUser_email());

        // 1. 이메일로 DB에서 사용자 정보 조회
        UserVO dbUser = mapper.read(user.getUser_email());

        // 2. 사용자가 존재하지 않는 경우
        if (dbUser == null) {
            log.warn("User not found: " + user.getUser_email());
            return null;
        }

        // 3. 비밀번호 일치 여부 확인
        //    (user.getPassword() = 사용자가 입력한 원본 비밀번호)
        //    (dbUser.getPassword() = DB에 저장된 암호화된 비밀번호)
        if (passwordEncoder.matches(user.getPassword(), dbUser.getPassword())) {
            // 비밀번호 일치 (로그인 성공)
            return dbUser;
        } else {
            // 비밀번호 불일치 (로그인 실패)
            log.warn("Password does not match for: " + user.getUser_email());
            return null;
        }
    }

    @Override
    public int emailCheck(String user_email) {
        log.info("emailCheck......" + user_email);
        return mapper.checkEmail(user_email);
    }
    
 // [추가] 아이디 찾기 로직
    @Override
    public String findId(UserVO user) {
        log.info("findId service....: " + user.getName());
        return mapper.findIdByNameAndStudentId(user);
    }

    // [추가] 비밀번호 재설정 사용자 확인 로직
    @Override
    public UserVO findUserForPwReset(UserVO user) {
        log.info("findUserForPwReset service....: " + user.getUser_email());
        return mapper.findUserForPwReset(user);
    }

    // [추가] 비밀번호 재설정 로직
    @Override
    public boolean resetPassword(UserVO user) {
        log.info("resetPassword service....: " + user.getUser_email());
        
        // (중요) 새 비밀번호 암호화
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        
        int result = mapper.updatePassword(user);
        
        return result == 1; // 1이면 true(성공) 반환
    }
}