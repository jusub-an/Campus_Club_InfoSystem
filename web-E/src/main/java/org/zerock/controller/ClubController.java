package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.ClubDTO;
import org.zerock.service.ClubService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/club/*")
@AllArgsConstructor
public class ClubController {
	private ClubService service; 
	
	// 등록 페이지 이동 	
	@GetMapping("/register") 
	public void register() {
		log.info("club register form"); 
	} 
	
	// 동아리 목록 페이지 
	@GetMapping("/list") 
	public void list(Model model) {
		log.info("club list");
		model.addAttribute("list", service.getClubList()); 
	} 
	
	// 동아리 등록 처리 
	@PostMapping("/register") 
	public String register(ClubDTO club, RedirectAttributes rttr) {
		log.info("register: " + club); 
		if (service.registerClub(club)) {
			rttr.addFlashAttribute("result", "success"); 
		} 
		return "redirect:/club/list"; 
	} 
	
	// 동아리 상세 조회 
	@GetMapping({"/get", "/modify"}) 
	public void get(@RequestParam("club_id") Long club_id, Model model) {
		log.info("/get or modify: " + club_id); 
		model.addAttribute("club", service.getClub(club_id)); 
	} 
	
	// 동아리 수정 
	@PostMapping("/modify") 
	public String modify(ClubDTO club, RedirectAttributes rttr) {
		log.info("modify: " + club); 
		if (service.updateClub(club)) {
			rttr.addFlashAttribute("result", "success"); 
		} 
		
		return "redirect:/club/list";
	} 
	
	// 동아리 삭제 
	@PostMapping("/remove") 
	public String remove(@RequestParam("club_id") Long club_id, RedirectAttributes rttr) {
		log.info("remove: " + club_id); 
		if (service.deleteClub(club_id)) {
			rttr.addFlashAttribute("result", "success"); 
		} 
		return "redirect:/club/list"; 
	}

}
