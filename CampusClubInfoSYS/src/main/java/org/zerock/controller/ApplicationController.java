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
    public String application_list(@RequestParam("club_id") Long club_id, Model model, UserDTO user, ApplicationDTO applicant) {
    	// 가입 신청 목록
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
        
        // 회원 목록
        List<MemberDTO> m_list = service.getMemberListByClub(club_id);
        model.addAttribute("m_list", m_list);
        return "application/app-list";
    }
    
 // 신청 승인 처리 (O 버튼)
    @PostMapping("/approve")
    public String approve(Long app_id, @RequestParam("club_id") Long club_id, String applicant_email, RedirectAttributes rttr) {
        
        // 1. MemberDTO 객체 생성 및 값 설정
        MemberDTO memberDTO = new MemberDTO();
        memberDTO.setClub_id(club_id);
        memberDTO.setUser_email(applicant_email);
        
        // 2. 서비스 호출: Member 추가 및 Application 삭제 처리
        service.approve(memberDTO, app_id);
        
        rttr.addFlashAttribute("result", app_id + "번 신청이 승인되었습니다.");
        return "redirect:/application/list?club_id=" + club_id;
    }
    
    // 신청 거절 처리 (X 버튼)
    @PostMapping("/reject")
    public String reject(@RequestParam("club_id") Long club_id, Long app_id, RedirectAttributes rttr) {
        
        // 서비스 호출: Application에서 삭제 처리
        service.reject(app_id);
        
        rttr.addFlashAttribute("result", app_id + "번 신청이 거절되었습니다.");
        return "redirect:/application/list?club_id=" + club_id;
    }
    
    @GetMapping("/apply")
    public void apply(@RequestParam("club_id") Long club_id, Model model, HttpSession session) {
    	
    	String loginUser = (String) session.getAttribute("user_email");
    	System.out.println("loginUser:"+loginUser);
        
        // 1. 현재 동아리의 회원인지 확인
        String MemberEmail = service.getMemberEmailByClubId(loginUser, club_id);
        
        // 2. 현재 동아리에 이미 신청서를 제출했는지 확인 (※ service 메서드 수정 필수)
        String ApplyEmail = service.getApplyEmailByClubId(loginUser, club_id);
        
        
        log.info("club_id: " + club_id);
        model.addAttribute("club_id", club_id); 

        if (MemberEmail != null) {
            // 이미 회원인 경우 (가장 먼저 체크)
            model.addAttribute("result", "✅ 이미 현재 동아리의 회원입니다. (가입 신청 불가)");
        } else if (ApplyEmail != null) {
            // 회원도 아니지만, 이미 신청서를 제출하여 대기 중인 경우
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
        // Service의 반환 값(boolean)으로 중복 여부 확인
        boolean success = service.apply(dto);
        
        
        if (success) {
            rttr.addFlashAttribute("result", "가입 신청이 완료되었습니다.");
            return "redirect:/post/list?club_id=" + club_id; // 신청 성공 시 list 페이지로 이동
        } else {
            // 중복 신청 실패 시, apply 페이지로 다시 이동
            rttr.addFlashAttribute("error", "이미 가입 신청하셨거나 처리 대기 중인 신청 건이 있습니다.");
            return "redirect:/post/list?club_id=" + club_id;
        }
    }
    // 회원 추방 처리
    @PostMapping("/expel")
    public String expel(@RequestParam("club_id") Long club_id, MemberDTO memberDTO, RedirectAttributes rttr) {
        
        // 서비스 호출: Member 테이블에서 해당 회원 삭제
        service.expel(memberDTO);
        
        rttr.addFlashAttribute("result", memberDTO.getUser_email() + " 회원이 추방되었습니다.");
        return "redirect:/application/list?club_id=" + club_id;
    }
}
