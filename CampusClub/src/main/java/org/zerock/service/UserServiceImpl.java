package org.zerock.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.zerock.domain.UserDTO;
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
    public void register(UserDTO user) {
        log.info("register......" + user);
        
        String encodedPassword = passwordEncoder.encode(user.getPassword());
        user.setPassword(encodedPassword);

        mapper.register(user);
    }

    @Override
    public UserDTO login(UserDTO user) {
        log.info("login......" + user.getUser_email());

        UserDTO dbUser = mapper.read(user.getUser_email());

        if (dbUser == null) {
            log.warn("User not found: " + user.getUser_email());
            return null;
        }

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
    
    // 아이디 찾기 로직
    @Override
    public String findId(UserDTO user) {
        log.info("findId service....: " + user.getName());
        return mapper.findIdByNameAndStudentId(user);
    }

    // 비밀번호 재설정 사용자 확인 로직
    @Override
    public UserDTO findUserForPwReset(UserDTO user) {
        log.info("findUserForPwReset service....: " + user.getUser_email());
        return mapper.findUserForPwReset(user);
    }

    // 비밀번호 재설정 로직
    @Override
    public boolean resetPassword(UserDTO user) {
        log.info("resetPassword service....: " + user.getUser_email());
        
        // (중요) 새 비밀번호 암호화
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        
        int result = mapper.updatePassword(user);
        
        return result == 1; // 1이면 true(성공) 반환
    }
    
    // 사용자 이름 확인
    @Override
    public String findName(String user_email) {
    	return mapper.findName(user_email);
    }
}