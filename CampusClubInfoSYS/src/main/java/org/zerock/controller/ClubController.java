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
	
	// 등록 페이지 이동 	
	@GetMapping("/register") 
	public String register(HttpSession session, RedirectAttributes rttr) {

	    String loginEmail = (String) session.getAttribute("user_email");
	    String userType   = (String) session.getAttribute("user_type_code");

	    // 1. 로그인 안 되어 있으면 로그인 페이지로
	    if (loginEmail == null) {
	        rttr.addFlashAttribute("msg", "로그인 후 이용 가능합니다.");
	        return "redirect:/user/login";
	    }

	    // 2. MGR이 아니면 접근 불가
	    if (userType == null || !userType.equals("MGR")) {
	        rttr.addFlashAttribute("msg", "동아리 등록 권한이 없습니다.");
	        return "redirect:/club/list";
	    }

	    // 3. MGR이면 등록 페이지로
	    return "club/register";
	}
	
	// 동아리 목록 페이지 
	@GetMapping("/list") 
	public void list(Model model) {
		log.info("club list");
		model.addAttribute("list", service.getClubList()); 
	} 
	
	// 동아리 등록 처리 
	@PostMapping("/register") 
	public String register(ClubDTO club, 
			@RequestParam("logo_file") MultipartFile logoFile, 
			RedirectAttributes rttr, HttpSession session) {
		
		String userType = (String) session.getAttribute("user_type_code");
	    if (userType == null || !userType.equals("MGR")) {
	        rttr.addFlashAttribute("msg", "동아리 등록 권한이 없습니다.");
	        return "redirect:/club/list";
	    }
	    
		// 동아리장 이메일 추가
		club.setLeader_email((String) session.getAttribute("user_email"));
				
		// 파일 업로드 처리
		if (!logoFile.isEmpty()) {
			String uploadDir = session.getServletContext().getRealPath("/resources/uploads/logos");
			
			// 디렉토리 생성
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
				
				// DB에 저장할 웹 경로 설정
				club.setLogo_url("/resources/uploads/logos/" + saveName);
				
			} catch (Exception e) {
				log.error("File upload failed", e);
			}
		} else {
			// 업로드된 파일이 없을 경우 기본 이미지 또는 null 설정
			club.setLogo_url(null); // 또는 "/resources/images/default_logo.png"
		}
		
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
	public String modify(HttpSession session, 
			@RequestParam("logo_file") MultipartFile logoFile, 
			ClubDTO club, RedirectAttributes rttr) {
		// 동아리장 이메일 저장
		club.setLeader_email((String) session.getAttribute("user_email"));
		Long club_id = club.getClub_id();
		
		// 1. 새 파일이 업로드 되었는지 확인
		if (!logoFile.isEmpty()) {
			// (register와 동일한 파일 저장 로직)
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
				// (선택적: 기존 파일 삭제 로직 추가 가능)
						
				// 새 파일의 웹 경로로 설정
				club.setLogo_url("/resources/uploads/logos/" + saveName);
				
			} catch (Exception e) {
				log.error("File upload failed", e);
			}
		} else {
			// 2. 새 파일이 없으면 기존 로고 URL을 유지해야 함
			//    (주의: 폼에 logo_url이 없으므로, club 객체에는 이 값이 null입니다)
			ClubDTO oldClub = service.getClub(club.getClub_id());
			club.setLogo_url(oldClub.getLogo_url());
		}
		
		if (service.updateClub(club)) {
			rttr.addFlashAttribute("result", "success");
		} 
		
		return "redirect:/post/list?club_id="+club_id;
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
