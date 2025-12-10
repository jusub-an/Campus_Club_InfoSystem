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
import org.zerock.domain.UserDTO;
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

    

    
    @GetMapping("/register")
    public void registerGET() {
        log.info("register GET....");
    }

    
    @PostMapping("/register")
    public String registerPOST(UserDTO user, RedirectAttributes rttr) {
        log.info("register POST...." + user);

        try {
            
            user.setUser_type_code("STU"); 
            service.register(user);
            
            
            rttr.addFlashAttribute("result", "register_success");
            return "redirect:/user/login"; 

        } catch (Exception e) {
            
            log.error("Register failed: " + e.getMessage());
            rttr.addFlashAttribute("result", "register_fail");
            rttr.addFlashAttribute("error_message", "회원가입 중 오류가 발생했습니다. (이메일 중복 등)");
            return "redirect:/user/register"; 
        }
    }
    
    
    @PostMapping("/emailCheck")
    @ResponseBody 
    public String emailCheck(@RequestParam("user_email") String user_email) {
        log.info("emailCheck (AJAX)....: " + user_email);
        int result = service.emailCheck(user_email);
        return String.valueOf(result); 
    }


    

    
    @GetMapping("/login")
    public void loginGET() {
        log.info("login GET....");
    }

    
    @PostMapping("/login")
    public String loginPOST(UserDTO user, HttpSession session, Model model, RedirectAttributes rttr) {
        log.info("login POST...." + user.getUser_email());

        UserDTO loginUser = service.login(user);

        if (loginUser == null) {
            
            log.info("Login failed for: " + user.getUser_email());
            rttr.addFlashAttribute("result", "login_fail");
            return "redirect:/user/login"; 
        }

        
        log.info("Login successful: " + loginUser.getName());
        
        
        session.setAttribute("user_email", loginUser.getUser_email());
        session.setAttribute("user_type_code", loginUser.getUser_type_code());
        session.setAttribute("userName", loginUser.getName());
        
        return "redirect:/"; 
    }


    

    
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        log.info("logout....");

        HttpSession session = request.getSession(false); 
        if (session != null) {
            session.invalidate(); 
        }

        return "redirect:/"; 
    }
    
    
    
    
    @GetMapping("/findId")
    public void findIdGET() {
        log.info("findId GET....");
        
    }
    
    
    @PostMapping("/findId")
    public String findIdPOST(UserDTO user, Model model) {
        log.info("findId POST....: " + user.getName());
        String foundEmail = service.findId(user);
        
        if (foundEmail != null) {
            model.addAttribute("result", "find_id_success");
            model.addAttribute("found_email", foundEmail);
        } else {
            model.addAttribute("result", "find_id_fail");
        }
        
        return "/user/findId"; 
    }
    
    
    @GetMapping("/findPw")
    public void findPwGET() {
        log.info("findPw GET....");
        
    }
    
    
    @PostMapping("/findPw")
    public String findPwPOST(UserDTO user, Model model, RedirectAttributes rttr) {
        log.info("findPw POST....: " + user.getUser_email());
        UserDTO foundUser = service.findUserForPwReset(user);
        
        if (foundUser != null) {
            
            log.info("User found. Redirecting to resetPw");
            
            model.addAttribute("user_email", foundUser.getUser_email());
            return "/user/resetPw"; 
        } else {
            
            log.info("User not found.");
            rttr.addFlashAttribute("result", "find_pw_fail");
            return "redirect:/user/findPw"; 
        }
    }
    
    
    @PostMapping("/resetPw")
    public String resetPwPOST(UserDTO user, RedirectAttributes rttr) {
        log.info("resetPw POST....: " + user.getUser_email());
        
        if (service.resetPassword(user)) {
            
            rttr.addFlashAttribute("result", "pw_reset_success");
            return "redirect:/user/login"; 
        } else {
            
            rttr.addFlashAttribute("result", "find_pw_fail"); 
            return "redirect:/user/findPw"; 
        }
    }
}