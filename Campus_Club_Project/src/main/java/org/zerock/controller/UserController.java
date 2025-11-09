package org.zerock.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.UserVO;
import org.zerock.service.UserService;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/user/*")
public class UserController {

    private final UserService service;

    @Autowired
    public UserController(UserService service) {
        this.service = service;
    }

    // --- 회원가입 ---

    /**
     * 회원가입 페이지(GET)
     */
    @GetMapping("/register")
    public void registerGET() {
        log.info("register GET....");
    }

    /**
     * 회원가입 처리(POST)
     */
    @PostMapping("/register")
    public String registerPOST(UserVO user, RedirectAttributes rttr) {
        log.info("register POST...." + user);

        try {
            // 기본 사용자 유형을 'STU' (학생)으로 설정 (테이블 정의에 따름)
            user.setUser_type_code("STU"); 
            service.register(user);
            
            // 회원가입 성공 시
            rttr.addFlashAttribute("result", "register_success");
            return "redirect:/user/login"; // 로그인 페이지로 리다이렉트

        } catch (Exception e) {
            // (주의) 이메일 PK 중복 등 예외 처리
            log.error("Register failed: " + e.getMessage());
            rttr.addFlashAttribute("result", "register_fail");
            rttr.addFlashAttribute("error_message", "회원가입 중 오류가 발생했습니다. (이메일 중복 등)");
            return "redirect:/user/register"; // 다시 회원가입 페이지로
        }
    }
    
    /**
     * (AJAX) 이메일 중복 확인
     */
    @PostMapping("/emailCheck")
    @ResponseBody // 뷰(JSP)를 반환하는 것이 아니라, 데이터(String)를 직접 반환
    public String emailCheck(@RequestParam("user_email") String user_email) {
        log.info("emailCheck (AJAX)....: " + user_email);
        int result = service.emailCheck(user_email);
        return String.valueOf(result); // 중복이면 "1", 아니면 "0" 반환
    }


    // --- 로그인 ---

    /**
     * 로그인 페이지(GET)
     */
    @GetMapping("/login")
    public void loginGET() {
        log.info("login GET....");
    }

    /**
     * 로그인 처리(POST)
     */
    @PostMapping("/login")
    public String loginPOST(UserVO user, HttpServletRequest request, RedirectAttributes rttr) {
        log.info("login POST...." + user.getUser_email());

        UserVO loginUser = service.login(user);

        if (loginUser == null) {
            // 로그인 실패
            log.info("Login failed for: " + user.getUser_email());
            rttr.addFlashAttribute("result", "login_fail");
            return "redirect:/user/login"; // 다시 로그인 페이지로
        }

        // 로그인 성공
        log.info("Login successful: " + loginUser.getName());
        
        // 세션(Session)에 로그인 사용자 정보 저장
        HttpSession session = request.getSession();
        session.setAttribute("loginUser", loginUser); // "loginUser"라는 이름으로 세션에 저장

        return "redirect:/post/list"; // 게시판 목록 페이지로 리다이렉트
    }


    // --- 로그아웃 ---

    /**
     * 로그아웃(GET)
     */
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        log.info("logout....");

        HttpSession session = request.getSession(false); // 현재 세션 가져오기
        if (session != null) {
            session.invalidate(); // 세션 무효화
        }

        return "redirect:/user/login"; // 로그아웃 후 로그인 페이지로
    }
    
// --- [추가] 아이디/비밀번호 찾기 ---
    
    /**
     * 아이디 찾기 페이지(GET)
     */
    @GetMapping("/findId")
    public void findIdGET() {
        log.info("findId GET....");
        // findId.jsp로 이동
    }
    
    /**
     * 아이디 찾기 처리(POST)
     */
    @PostMapping("/findId")
    public String findIdPOST(UserVO user, Model model) {
        log.info("findId POST....: " + user.getName());
        String foundEmail = service.findId(user);
        
        if (foundEmail != null) {
            model.addAttribute("result", "find_id_success");
            model.addAttribute("found_email", foundEmail);
        } else {
            model.addAttribute("result", "find_id_fail");
        }
        
        return "/user/findId"; // 결과를 같은 findId.jsp 페이지에 표시
    }
    
    /**
     * 비밀번호 찾기 (1단계) 페이지(GET)
     */
    @GetMapping("/findPw")
    public void findPwGET() {
        log.info("findPw GET....");
        // findPw.jsp로 이동
    }
    
    /**
     * 비밀번호 찾기 (1단계) 처리(POST)
     */
    @PostMapping("/findPw")
    public String findPwPOST(UserVO user, Model model, RedirectAttributes rttr) {
        log.info("findPw POST....: " + user.getUser_email());
        UserVO foundUser = service.findUserForPwReset(user);
        
        if (foundUser != null) {
            // 사용자 인증 성공
            log.info("User found. Redirecting to resetPw");
            // Model을 사용해야 resetPw.jsp로 값이 전달됨
            model.addAttribute("user_email", foundUser.getUser_email());
            return "/user/resetPw"; // resetPw.jsp 페이지로 이동
        } else {
            // 사용자 인증 실패
            log.info("User not found.");
            rttr.addFlashAttribute("result", "find_pw_fail");
            return "redirect:/user/findPw"; // 다시 findPw.jsp로 리다이렉트
        }
    }
    
    /**
     * 비밀번호 찾기 (2단계) 처리(POST)
     */
    @PostMapping("/resetPw")
    public String resetPwPOST(UserVO user, RedirectAttributes rttr) {
        log.info("resetPw POST....: " + user.getUser_email());
        
        if (service.resetPassword(user)) {
            // 비밀번호 변경 성공
            rttr.addFlashAttribute("result", "pw_reset_success");
            return "redirect:/user/login"; // 로그인 페이지로
        } else {
            // (이론상 발생하기 어렵지만) 변경 실패
            rttr.addFlashAttribute("result", "find_pw_fail"); // 실패 메시지 재활용
            return "redirect:/user/findPw"; // 1단계로 돌려보냄
        }
    }
}