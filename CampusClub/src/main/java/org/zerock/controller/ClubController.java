package org.zerock.controller;

import javax.servlet.http.HttpSession;

import java.io.File;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.multipart.MultipartFile;
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
	
		
	@GetMapping("/register") 
	public String register(HttpSession session, RedirectAttributes rttr) {

	    String loginEmail = (String) session.getAttribute("user_email");
	    String userType   = (String) session.getAttribute("user_type_code");

	    
	    if (loginEmail == null) {
	        rttr.addFlashAttribute("msg", "로그인 후 이용 가능합니다.");
	        return "redirect:/user/login";
	    }

	    
	    if (userType == null || !userType.equals("MGR")) {
	        rttr.addFlashAttribute("msg", "동아리 등록 권한이 없습니다.");
	        return "redirect:/";
	    }

	    
	    if (service.hasClub(loginEmail)) {
	        rttr.addFlashAttribute("msg", "이미 하나의 동아리를 등록하였습니다.");
	        return "redirect:/";
	    }
	    
	    return "club/register";
	}
	
	
	@GetMapping("/list") 
	public void list(Model model, HttpSession session) {
	    log.info("club list");
	    model.addAttribute("list", service.getClubList()); 

	    String email = (String) session.getAttribute("user_email");
	    if (email != null) {
	        boolean hasClub = service.hasClub(email);
	        model.addAttribute("hasClub", hasClub);
	    }
	}
	
	
	@PostMapping("/register") 
	public String register(ClubDTO club, 
			@RequestParam("logo_file") MultipartFile logoFile, 
			RedirectAttributes rttr, HttpSession session) {
		
		
		club.setLeader_email((String) session.getAttribute("user_email"));
				
		
		if (!logoFile.isEmpty()) {
			String uploadDir = session.getServletContext().getRealPath("/resources/uploads/logos");
			
			
			File dir = new File(uploadDir);
			if (!dir.exists()) {
				dir.mkdirs();
			}
			
			String originalName = logoFile.getOriginalFilename();
			String uuid = UUID.randomUUID().toString();
			String saveName = uuid + "_" + originalName;
			
			try {
				File saveFile = new File(uploadDir, saveName);
				logoFile.transferTo(saveFile);
				
				
				club.setLogo_url("/resources/uploads/logos/" + saveName);
				
			} catch (Exception e) {
				log.error("File upload failed", e);
			}
		} else {
			
			club.setLogo_url(null); 
		}
		
		if (service.registerClub(club)) {
			rttr.addFlashAttribute("result", "success"); 
		} 
		return "redirect:/"; 
	} 
	
	
	@GetMapping({"/get", "/modify"}) 
	public void get(@RequestParam("club_id") Long club_id, Model model) {
		log.info("/get or modify: " + club_id); 
		model.addAttribute("club", service.getClub(club_id)); 
	} 
	
	
	@PostMapping("/modify") 
	public String modify(HttpSession session, 
			@RequestParam("logo_file") MultipartFile logoFile, 
			ClubDTO club, RedirectAttributes rttr) {
		
		club.setLeader_email((String) session.getAttribute("user_email"));
		Long club_id = club.getClub_id();
		
		
		if (!logoFile.isEmpty()) {
			
			String uploadDir = session.getServletContext().getRealPath("/resources/uploads/logos");
			File dir = new File(uploadDir);
			if (!dir.exists()) {
				dir.mkdirs();
			}
			
			String originalName = logoFile.getOriginalFilename();
			String uuid = UUID.randomUUID().toString();
			String saveName = uuid + "_" + originalName;
			
			try {
				File saveFile = new File(uploadDir, saveName);
				logoFile.transferTo(saveFile);
				
						
				
				club.setLogo_url("/resources/uploads/logos/" + saveName);
				
			} catch (Exception e) {
				log.error("File upload failed", e);
			}
		} else {
			
			
			ClubDTO oldClub = service.getClub(club.getClub_id());
			club.setLogo_url(oldClub.getLogo_url());
		}
		
		if (service.updateClub(club)) {
			rttr.addFlashAttribute("result", "success");
		} 
		
		return "redirect:/post/list?club_id="+club_id;
	} 
	
	
	@PostMapping("/remove") 
	public String remove(@RequestParam("club_id") Long club_id, RedirectAttributes rttr) {
		log.info("remove: " + club_id); 
		if (service.deleteClub(club_id)) {
			rttr.addFlashAttribute("result", "success"); 
		} 
		return "redirect:/"; 
	}

}