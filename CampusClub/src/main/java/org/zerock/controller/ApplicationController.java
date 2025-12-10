package org.zerock.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.ApplicationDTO;
import org.zerock.domain.MemberDTO;
import org.zerock.domain.UserDTO;
import org.zerock.service.ApplicationService;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/application/*")
@AllArgsConstructor
public class ApplicationController {
    
    private ApplicationService service;
    
    @GetMapping("/list")
    public String application_list(@RequestParam("club_id") Long club_id, HttpSession session, Model model, UserDTO user, ApplicationDTO applicant) {
    	
    	List<ApplicationDTO> a_list = service.getApplyListByClub(club_id);
    	List<String> users_name = new ArrayList<>();
    	if (a_list != null) {
    		for (ApplicationDTO dto : a_list) {
    			String email = dto.getApplicant_email();
    			users_name.add(service.getName(email));
    		}
    	}
    	model.addAttribute("club_id", club_id);
        model.addAttribute("a_list", a_list);
        model.addAttribute("name_list", users_name);
        
        
        List<MemberDTO> m_list = service.getMemberListByClub(club_id);
        model.addAttribute("m_list", m_list);
        return "application/app-list";
    }
    
 
    @PostMapping("/approve")
    public String approve(Long app_id, @RequestParam("club_id") Long club_id, String applicant_email, RedirectAttributes rttr) {
        
        
        MemberDTO memberDTO = new MemberDTO();
        memberDTO.setClub_id(club_id);
        memberDTO.setUser_email(applicant_email);
        
        
        service.approve(memberDTO, app_id);
        
        rttr.addFlashAttribute("result", app_id + "번 신청이 승인되었습니다.");
        return "redirect:/application/list?club_id=" + club_id;
    }
    
    
    @PostMapping("/reject")
    public String reject(@RequestParam("club_id") Long club_id, Long app_id, RedirectAttributes rttr) {
        
        
        service.reject(app_id);
        
        rttr.addFlashAttribute("result", app_id + "번 신청이 거절되었습니다.");
        return "redirect:/application/list?club_id=" + club_id;
    }
    
    @GetMapping("/apply")
    public void apply(@RequestParam("club_id") Long club_id, Model model, HttpSession session) {
    	
    	String loginUser = (String) session.getAttribute("user_email");
    	System.out.println("loginUser:"+loginUser);
        
        
        String MemberEmail = service.getMemberEmailByClubId(loginUser, club_id);
        
        
        String ApplyEmail = service.getApplyEmailByClubId(loginUser, club_id);
        
        
        log.info("club_id: " + club_id);
        model.addAttribute("club_id", club_id); 

        if (MemberEmail != null) {
            
            model.addAttribute("result", "✅ 이미 현재 동아리의 회원입니다. (가입 신청 불가)");
        } else if (ApplyEmail != null) {
            
            model.addAttribute("result", "⏳ 이미 이 동아리에 신청서를 보내셨거나 대기 중인 요청이 있습니다.");
        }
    	
    }	
    
    @PostMapping("/apply")
    public String apply(HttpSession session, ApplicationDTO dto,
    		@RequestParam("applicant_text") String applicant_text,
    		RedirectAttributes rttr) {
        Date now = new Date();
        dto.setApplied_at(now);
        dto.setApplicant_text(applicant_text);
        log.info(applicant_text);
        dto.setApplicant_email((String) session.getAttribute("user_email"));
        Long club_id = dto.getClub_id();
        
        boolean success = service.apply(dto);
        
        
        if (success) {
            rttr.addFlashAttribute("result", "가입 신청이 완료되었습니다.");
            return "redirect:/post/list?club_id=" + club_id; 
        } else {
            
            rttr.addFlashAttribute("error", "이미 가입 신청하셨거나 처리 대기 중인 신청 건이 있습니다.");
            return "redirect:/post/list?club_id=" + club_id;
        }
    }
    
    @PostMapping("/expel")
    public String expel(@RequestParam("club_id") Long club_id, MemberDTO memberDTO, RedirectAttributes rttr) {
        service.expel(memberDTO);
        
        rttr.addFlashAttribute("result", memberDTO.getUser_email() + " 회원이 추방되었습니다.");
        return "redirect:/application/list?club_id=" + club_id;
    }
}