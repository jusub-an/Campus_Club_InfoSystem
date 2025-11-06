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
    public String application_list(Model model, UserDTO user, ApplicationDTO applicant) {
    	// 가입 신청 목록
    	List<ApplicationDTO> a_list = service.getApplyList();
    	List<String> users_name = new ArrayList<>();
    	if (a_list != null) {
    		for (ApplicationDTO dto : a_list) {
    			String email = dto.getApplicant_email();
    			users_name.add(service.getName(email));
    		}
    	}
        model.addAttribute("a_list", a_list);
        model.addAttribute("name_list", users_name);
        
        // 회원 목록
        List<MemberDTO> m_list = service.getMemberList();
        model.addAttribute("m_list", m_list);
        return "application/app-list";
    }
    
 // 신청 승인 처리 (O 버튼)
    @PostMapping("/approve")
    public String approve(Long app_id, Long club_id, String applicant_email, RedirectAttributes rttr) {
        
        // 1. MemberDTO 객체 생성 및 값 설정
        MemberDTO memberDTO = new MemberDTO();
        memberDTO.setClub_id(club_id);
        memberDTO.setUser_email(applicant_email);
        
        // 2. 서비스 호출: Member 추가 및 Application 삭제 처리
        service.approve(memberDTO, app_id);
        
        rttr.addFlashAttribute("result", app_id + "번 신청이 승인되었습니다.");
        return "redirect:/application/list";
    }
    
    // 신청 거절 처리 (X 버튼)
    @PostMapping("/reject")
    public String reject(Long app_id, RedirectAttributes rttr) {
        
        // 서비스 호출: Application에서 삭제 처리
        service.reject(app_id);
        
        rttr.addFlashAttribute("result", app_id + "번 신청이 거절되었습니다.");
        return "redirect:/application/list";
    }
    
    @GetMapping("/apply")
    public void apply() {
    	
    }
    
    @PostMapping("/apply")
    public String apply(HttpSession session, ApplicationDTO dto, RedirectAttributes rttr) {
        Date now = new Date();
        dto.setApplied_at(now);
        dto.setStatus("대기");
        
        // Service의 반환 값(boolean)으로 중복 여부 확인
        boolean success = service.apply(dto);
        
        if (success) {
            rttr.addFlashAttribute("result", "가입 신청이 완료되었습니다.");
            return "redirect:/application/list"; // 신청 성공 시 list 페이지로 이동
        } else {
            // 중복 신청 실패 시, apply 페이지로 다시 이동
            rttr.addFlashAttribute("error", "이미 가입 신청하셨거나 처리 대기 중인 신청 건이 있습니다.");
            return "redirect:/application/apply";
        }
    }
    // 회원 추방 처리
    @PostMapping("/expel")
    public String expel(MemberDTO memberDTO, RedirectAttributes rttr) {
        
        // 서비스 호출: Member 테이블에서 해당 회원 삭제
        service.expel(memberDTO);
        
        rttr.addFlashAttribute("result", memberDTO.getUser_email() + " 회원이 추방되었습니다.");
        return "redirect:/application/list";
    }
}
