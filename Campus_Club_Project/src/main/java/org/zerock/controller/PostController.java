package org.zerock.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List; // ⭐️ [추가]

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
import org.zerock.service.PostService;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.domain.FileVO; // 추가
import org.zerock.mapper.FileMapper; // 추가

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/post/*")
//@AllArgsConstructor
public class PostController {
	private PostService service;
	private FileMapper fileMapper;
	
	private String uploadFolder = "C:\\upload";
	
	@Autowired
	public PostController(PostService service, FileMapper fileMapper) {
		this.service = service;
		this.fileMapper = fileMapper;
	}
	
	@GetMapping("/download")
	public ResponseEntity<Resource> downloadFile(@RequestParam("file_id") Long file_id) {
		
		log.info("download file_id: " + file_id);
		
		// 1. file_id로 DB에서 파일 정보(FileVO) 가져오기
		FileVO file = fileMapper.getFile(file_id);
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
	
	@GetMapping("/register")
	public void register() {//void로 설정한것은 url로 입력한 register이름의 jsp파일을 찾아간다.

	}

	 @GetMapping("/list")
	 public void list(Criteria cri, Model model) {
	
	 log.info("list: " + cri);
	 model.addAttribute("list", service.getList(cri));
	 //카테로리로 필터링 된 게시글 총 개수 구하는 매서드
	 int total = service.getTotal(cri);
     log.info("total: " + total);
     PageDTO pageMaker = new PageDTO(cri, total);
     model.addAttribute("pageMaker", pageMaker);
	 }

	@PostMapping("/register")
	public String register(PostVO post, RedirectAttributes rttr) {

		log.info("register: " + post);
		
		post.setClub_id(999L);
	    post.setAuthor_email("hong@mnu.com");
	    
		service.register(post);

		rttr.addFlashAttribute("result", post.getPost_id());

		return "redirect:/post/list";
	}

	@GetMapping("/get")
	public void get(@RequestParam("post_id") Long post_id, Criteria cri, Model model) {
	    log.info("/get");
	    model.addAttribute("post", service.get(post_id));
	    model.addAttribute("cri", cri); // cri 객체를 모델에 추가
	}
	 
	@GetMapping("/modify")
	public void modify(@RequestParam("post_id") Long post_id, Criteria cri, Model model) {
	    log.info("/modify");
	    model.addAttribute("post", service.get(post_id));
	    model.addAttribute("cri", cri); // cri 객체를 모델에 추가
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
					 FileVO file = fileMapper.getFile(file_id);
					 if (file != null) {
						 // 2-2. 물리적 파일 삭제
						 File fileOnDisk = new File(uploadFolder, file.getStorage_path());
						 if (fileOnDisk.exists()) {
							 fileOnDisk.delete();
						 }
						 // 2-3. DB에서 파일 레코드 삭제
						 fileMapper.delete(file_id);
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
	 public String remove(@RequestParam("post_id") Long post_id, RedirectAttributes rttr)
	 {
		 log.info("remove..." + post_id);
		 if (service.remove(post_id)) {
			 rttr.addFlashAttribute("result", "success");
		 }
		 return "redirect:/post/list";
	 }
	
	 @PostMapping("/deleteFile")
		public ResponseEntity<String> deleteFile(@RequestParam("file_id") Long file_id) {
			
			log.info("delete file_id: " + file_id);
			
			try {
				// 1. DB에서 파일 정보 가져오기 (물리적 파일 삭제를 위해)
				FileVO file = fileMapper.getFile(file_id);
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
				fileMapper.delete(file_id);
				
				return new ResponseEntity<>("deleted", HttpStatus.OK);
				
			} catch (Exception e) {
				log.error("파일 삭제 중 오류 발생: " + e.getMessage());
				return new ResponseEntity<>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}
}