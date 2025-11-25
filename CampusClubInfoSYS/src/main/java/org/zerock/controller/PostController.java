package org.zerock.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List; // ⭐️ [추가]

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired; // 추가
import org.springframework.core.io.FileSystemResource; // 추가
import org.springframework.core.io.Resource; // 추가
import org.springframework.http.HttpHeaders; // 추가
import org.springframework.http.HttpStatus; // 추가
import org.springframework.http.ResponseEntity; // 추가

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.PostVO;
import org.zerock.service.ClubService;
import org.zerock.service.PostService;
import org.zerock.domain.ClubDTO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.domain.FileVO; // 추가
import org.zerock.service.FileService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/post/*")
//@AllArgsConstructor
public class PostController {
	private PostService service;
	private FileService fileService;
	private ClubService clubService;
	
	private String uploadFolder = "C:\\upload";
	
	@Autowired
	public PostController(PostService service, FileService fileService, ClubService clubService) {
		this.service = service;
		this.fileService = fileService;
		this.clubService = clubService;
	}
	
	@GetMapping("/download")
	public ResponseEntity<Resource> downloadFile(@RequestParam("file_id") Long file_id) {
		
		log.info("download file_id: " + file_id);
		
		// 1. file_id로 DB에서 파일 정보(FileVO) 가져오기
		FileVO file = fileService.getFile(file_id);
		if (file == null) {
			log.error("File not found in DB: " + file_id);
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		//    Spring의 Resource 객체 생성
		String uploadFolder = "C:\\upload";

		File fileOnDisk = new File(uploadFolder, file.getStorage_path());
		Resource resource = new FileSystemResource(fileOnDisk);

		if (!resource.exists()) {
			log.error("File not found on Disk: " + fileOnDisk.getPath());
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		// 3. 다운로드 시 브라우저에 표시될 원본 파일명 처리
		String originalFileName = file.getFile_name();
		String encodedFileName;
		
		try {
			// 한글 등 비ASCII 문자 인코딩
			encodedFileName = URLEncoder.encode(originalFileName, "UTF-8").replaceAll("\\+", "%20");
		} catch (UnsupportedEncodingException e) {
			log.error("Filename encoding error", e);
			encodedFileName = "download"; // 인코딩 실패 시 기본 파일명
		}
		
		// 4. HTTP 응답 헤더 설정
		HttpHeaders headers = new HttpHeaders();
		// 'Content-Disposition': 'attachment'는 파일을 다운로드하라는 의미
		headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"");

		// 5. 파일의 MIME 타입(Content-Type) 설정
		try {
			Path filePath = fileOnDisk.toPath();
			String contentType = Files.probeContentType(filePath);
			if (contentType == null) {
				contentType = "application/octet-stream"; // 타입을 모를 경우 범용 이진 파일
			}
			headers.add(HttpHeaders.CONTENT_TYPE, contentType);
			
		} catch (IOException e) {
			log.warn("Could not determine file type.");
			headers.add(HttpHeaders.CONTENT_TYPE, "application/octet-stream");
		}
		
		// 6. 파일 리소스, 헤더, HTTP 상태(OK)를 담아 ResponseEntity 반환
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	// ⭐️ [수정] 반환형 void -> String, 세션 체크 로직 추가
		@GetMapping("/register")
		public String register(
				@RequestParam("club_id") Long club_id, 
	            HttpSession session, 
	            RedirectAttributes rttr, // 리다이렉트 메시지용
				Model model) {

			// 1. 로그인 여부 확인 (보안)
			String user_email = (String) session.getAttribute("user_email");
			if (user_email == null) {
				log.warn("비로그인 사용자의 게시글 등록 페이지 접근 시도 blocked.");
				rttr.addFlashAttribute("result", "login_required"); // 로그인 페이지에서 메시지 표시용
				return "redirect:/user/login"; // ⭐️ 로그인 페이지로 강제 이동
			}

			// 2. 동아리 정보 조회 및 모델 담기 (기존 로직)
			ClubDTO clubInfo = clubService.getClub(club_id);
			model.addAttribute("clubInfo", clubInfo);
			model.addAttribute("club_id", club_id); 
			
			// 3. 회원 여부 확인 (기존 로직)
			boolean isMember = clubService.checkMember(club_id, user_email);
			model.addAttribute("isMember", isMember);
			
			// 반환형이 String일 때, JSP 경로를 명시적으로 리턴하지 않으면
			// 요청 URL(/post/register)에 따라 자동으로 /WEB-INF/views/post/register.jsp로 이동합니다.
			// 하지만 명시적으로 적어주는 것이 안전합니다.
			return "/post/register";
		}

	 @GetMapping("/list")
	 public void list(
			 @RequestParam(value = "club_id", required = false) Long club_id,
			 HttpSession session, Criteria cri, Model model
			 ) {
		 ClubDTO clubInfo = clubService.getClub(club_id);
         if (clubInfo != null) {
             model.addAttribute("clubName", clubInfo.getClub_name());
             model.addAttribute("clubInfo", clubInfo);
         } else {
             model.addAttribute("clubName", "알 수 없는 동아리");
         }
		 if (club_id != null) {
			 cri.setClub_id(club_id); // Criteria를 통해 SQL 필터링
			 session.setAttribute("club_id", club_id); // 등록/수정 시 사용하도록 세션에 저장
			 model.addAttribute("currentClubId", club_id); // JSP에서 필터링 유지에 사용
		 } else {
			 // club_id가 URL에 없는 경우, 세션에 저장된 club_id를 사용하지 않도록 합니다.
			 // 즉, 모든 동아리 게시글을 보거나(club_id=null), 세션 값을 명시적으로 제거해야 합니다.
			 // 현재 로직에서는 club_id가 null이면 모든 club의 게시글을 조회합니다 (Mapper가 처리).
		 }
		 log.info("list: " + cri);
		 model.addAttribute("list", service.getList(cri));
		 
		 //카테로리로 필터링 된 게시글 총 개수 구하는 매서드
		 int total = service.getTotal(cri);
		 log.info("total: " + total);
		 PageDTO pageMaker = new PageDTO(cri, total);
		 model.addAttribute("pageMaker", pageMaker);
	 }

	@PostMapping("/register")
	public String register(HttpSession session, PostVO post, RedirectAttributes rttr) {

		log.info("register: " + post);
		// 1. 세션에서 로그인된 이메일 가져오기
		String user_email = (String) session.getAttribute("user_email");
		
		// 2. [추가] 비로그인 사용자가 등록을 시도할 경우 로그인 페이지로
		if (user_email == null) {
			log.warn("로그인하지 않은 사용자의 글쓰기 시도.");
			rttr.addFlashAttribute("result", "auth_fail"); // 로그인 페이지에 알림 전달
			return "redirect:/user/login"; // 로그인 페이지로 리다이렉트
		}

		// 3. 세션에서 club_id 가져오기
		Long club_id = (Long) session.getAttribute("club_id");
		
		// 4. PostVO에 값 설정
		post.setClub_id(club_id);
		post.setAuthor_email(user_email); // 👈 "test_1@test.com" 대신 세션 값으로 변경
		
		// 5. 서비스 호출
		service.register(post);

		rttr.addFlashAttribute("result", post.getPost_id());
		rttr.addFlashAttribute("club_id", club_id);

		return "redirect:/post/list?club_id="+club_id;
	}

	@GetMapping("/get")
	public String get(@RequestParam("post_id") Long post_id, Criteria cri, Model model, HttpSession session, RedirectAttributes rttr) {
		String user_email = (String) session.getAttribute("user_email");
		
        // (주의) 로그인하지 않은 사용자가 게시글을 볼 수 없게 막혀있습니다.
        // 만약 로그인 안 해도 글을 보게 하려면 이 if문을 주석 처리하거나 제거해야 합니다.
		if (user_email == null) {
			log.warn("로그인하지 않은 사용자의 접근 시도: /post/get");
			rttr.addFlashAttribute("result", "auth_fail"); 
			return "redirect:/user/login"; 
		}
		
		log.info("/get");
		PostVO post = service.get(post_id);
	    model.addAttribute("post", post);
	    model.addAttribute("cri", cri);
	    
	    // ⭐️ [추가] 권한 체크 로직 (동아리장/회원 여부)
	    if (post != null) {
            // 1. 동아리 정보 가져오기
	    	ClubDTO clubInfo = clubService.getClub(post.getClub_id());
			model.addAttribute("clubInfo", clubInfo);
            
            // 2. 동아리장 여부 확인
            boolean isLeader = clubInfo.getLeader_email().equals(user_email);
            model.addAttribute("isLeader", isLeader);

            // 3. 일반 회원 여부 확인
            boolean isMember = clubService.checkMember(post.getClub_id(), user_email);
            model.addAttribute("isMember", isMember);
		}
	    
	    return "/post/get";
	}
	 
	@GetMapping("/modify")
	public void modify(@RequestParam("post_id") Long post_id, Criteria cri, Model model, HttpSession session) { // HttpSession 추가
	    log.info("/modify");
	    
	    PostVO post = service.get(post_id);
	    model.addAttribute("post", post);
	    model.addAttribute("cri", cri);
	    
	    if(post != null) {
			ClubDTO clubInfo = clubService.getClub(post.getClub_id());
			model.addAttribute("clubInfo", clubInfo);
			
			// ⭐️ [추가] 권한 체크 로직 (modify.jsp에서 탭 제어를 위해 필요)
			String user_email = (String) session.getAttribute("user_email");
			if (user_email != null) {
				// 1. 동아리장 여부
				boolean isLeader = clubInfo.getLeader_email().equals(user_email);
				model.addAttribute("isLeader", isLeader);
				
				// 2. 일반 회원 여부
				boolean isMember = clubService.checkMember(post.getClub_id(), user_email);
				model.addAttribute("isMember", isMember);
			} else {
				model.addAttribute("isLeader", false);
				model.addAttribute("isMember", false);
			}
		}
	}
	 
//	 @PostMapping("/modify")
//	 public String modify(PostVO post, RedirectAttributes rttr) {
//		 log.info("modify:" + post);
//		
//		 if (service.modify(post)) {
//			 rttr.addFlashAttribute("result", "success");
//		 }
//		 return "redirect:/post/list";
//	 }
	 
	 // ⭐️ [변경] 
	 @PostMapping("/modify")
	 public ResponseEntity<String> modify(PostVO post,
			 // ⭐️ [추가] 'deleteFileIds' 파라미터를 List<Long>으로 받습니다.
			 @RequestParam(value = "deleteFileIds", required = false) List<Long> deleteFileIds) {
		 
		 log.info("modify:" + post);
		 if (deleteFileIds != null) {
			 log.info("deleteFileIds: " + deleteFileIds);
		 }
		
		 try {
			 // 1. 게시글 수정 및 새 파일 저장을 먼저 시도 (Transactional)
			 boolean modifyResult = service.modify(post);
			 
			 // 2. 게시글 수정이 성공했다면, 삭제 요청이 들어온 파일들을 처리
			 if (deleteFileIds != null && !deleteFileIds.isEmpty()) {
				 for(Long file_id : deleteFileIds) {
					 log.info("deleting file_id: " + file_id);
					 
					 // (deleteFile 메소드의 로직을 가져옴)
					 // 2-1. DB에서 파일 정보 가져오기 (물리적 파일 삭제를 위해)
					 FileVO file = fileService.getFile(file_id);
					 if (file != null) {
						 // 2-2. 물리적 파일 삭제
						 File fileOnDisk = new File(uploadFolder, file.getStorage_path());
						 if (fileOnDisk.exists()) {
							 fileOnDisk.delete();
						 }
						 // 2-3. DB에서 파일 레코드 삭제
						 fileService.deleteFile(file_id);
					 }
				 }
			 }
			 
			 if (modifyResult) {
				 // 성공 시 'success' 텍스트와 200(OK) 상태 반환
				 return new ResponseEntity<>("success", HttpStatus.OK);
			 } else {
				 // service.modify가 false를 반환한 경우 (업데이트된 행이 없음)
				 return new ResponseEntity<>("error", HttpStatus.INTERNAL_SERVER_ERROR);
			 }
			 
		 } catch (Exception e) {
			 // service.modify() 내부에서 파일 저장 실패 등 예외 발생 시
			 log.error("Modify failed: ", e);
			 return new ResponseEntity<>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
		 }
	 }

	 @PostMapping("/remove")
	 public String remove(@RequestParam("post_id") Long post_id, Criteria cri, @RequestParam("club_id") Long club_id,RedirectAttributes rttr)
	 {
		 log.info("remove..." + post_id);
		 if (service.remove(post_id)) {
			 rttr.addFlashAttribute("result", "success");
		 }
         rttr.addAttribute("club_id", club_id); 
         rttr.addAttribute("pageNum", cri.getPageNum());
         rttr.addAttribute("amount", cri.getAmount());
         rttr.addAttribute("type", cri.getType());
         rttr.addAttribute("keyword", cri.getKeyword());
         rttr.addAttribute("post_type", cri.getPost_type());
         return "redirect:/post/list";
	 }
	
	 @PostMapping("/deleteFile")
		public ResponseEntity<String> deleteFile(@RequestParam("file_id") Long file_id) {
			
			log.info("delete file_id: " + file_id);
			
			try {
				// 1. DB에서 파일 정보 가져오기 (물리적 파일 삭제를 위해)
				FileVO file = fileService.getFile(file_id);
				if (file == null) {
					log.warn("DB에 파일 정보가 없습니다: " + file_id);
					// DB에 없어도 삭제 성공으로 간주
					return new ResponseEntity<>("deleted", HttpStatus.OK); 
				}
				
				// 2. 물리적 파일 삭제
				File fileOnDisk = new File(uploadFolder, file.getStorage_path());
				
				if (fileOnDisk.exists()) {
					if (!fileOnDisk.delete()) {
						log.error("물리적 파일 삭제 실패: " + fileOnDisk.getPath());
						// 실패해도 DB 레코드는 삭제 시도
					}
				} else {
					log.warn("물리적 파일이 존재하지 않습니다: " + fileOnDisk.getPath());
				}
				
				// 3. DB에서 파일 레코드 삭제
				fileService.deleteFile(file_id);
				
				return new ResponseEntity<>("deleted", HttpStatus.OK);
				
			} catch (Exception e) {
				log.error("파일 삭제 중 오류 발생: " + e.getMessage());
				return new ResponseEntity<>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}
}