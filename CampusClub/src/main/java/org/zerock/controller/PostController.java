package org.zerock.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List; 

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired; 
import org.springframework.core.io.FileSystemResource; 
import org.springframework.core.io.Resource; 
import org.springframework.http.HttpHeaders; 
import org.springframework.http.HttpStatus; 
import org.springframework.http.ResponseEntity; 

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.PostVO;
import org.zerock.service.ApplicationService;
import org.zerock.service.ClubService;
import org.zerock.service.PostService;
import org.zerock.domain.ClubDTO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.domain.FileVO; 
import org.zerock.service.FileService;
import net.coobird.thumbnailator.Thumbnailator; 
import java.io.FileOutputStream; 
import java.nio.file.Files; 

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
		
		
		FileVO file = fileService.getFile(file_id);
		if (file == null) {
			log.error("File not found in DB: " + file_id);
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		
		String uploadFolder = "C:\\upload";

		File fileOnDisk = new File(uploadFolder, file.getStorage_path());
		Resource resource = new FileSystemResource(fileOnDisk);

		if (!resource.exists()) {
			log.error("File not found on Disk: " + fileOnDisk.getPath());
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		
		String originalFileName = file.getFile_name();
		String encodedFileName;
		
		try {
			
			encodedFileName = URLEncoder.encode(originalFileName, "UTF-8").replaceAll("\\+", "%20");
		} catch (UnsupportedEncodingException e) {
			log.error("Filename encoding error", e);
			encodedFileName = "download"; 
		}
		
		
		HttpHeaders headers = new HttpHeaders();
		
		headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"");

		
		try {
			Path filePath = fileOnDisk.toPath();
			String contentType = Files.probeContentType(filePath);
			if (contentType == null) {
				contentType = "application/octet-stream"; 
			}
			headers.add(HttpHeaders.CONTENT_TYPE, contentType);
			
		} catch (IOException e) {
			log.warn("Could not determine file type.");
			headers.add(HttpHeaders.CONTENT_TYPE, "application/octet-stream");
		}
		
		
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	
		@GetMapping("/register")
		public String register(
				@RequestParam("club_id") Long club_id, 
	            HttpSession session, 
	            RedirectAttributes rttr, 
				Model model) {

			
			String user_email = (String) session.getAttribute("user_email");
			if (user_email == null) {
				log.warn("비로그인 사용자의 게시글 등록 페이지 접근 시도 blocked.");
				rttr.addFlashAttribute("result", "login_required"); 
				return "redirect:/user/login"; 
			}

			
			ClubDTO clubInfo = clubService.getClub(club_id);
			model.addAttribute("clubInfo", clubInfo);
			model.addAttribute("club_id", club_id); 
			
			
			boolean isMember = clubService.checkMember(club_id, user_email);
			model.addAttribute("isMember", isMember);
			
			
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
			 cri.setClub_id(club_id); 
			 session.setAttribute("club_id", club_id); 
			 model.addAttribute("currentClubId", club_id); 
		 } else {
		 }
		 
		 log.info("list: " + cri);
		 model.addAttribute("list", service.getList(cri));
		 
		 
		 int total = service.getTotal(cri);
		 log.info("total: " + total);
		 PageDTO pageMaker = new PageDTO(cri, total);
		 model.addAttribute("pageMaker", pageMaker);
	 }

	@PostMapping("/register")
	public String register(HttpSession session, PostVO post, RedirectAttributes rttr) {

		log.info("register: " + post);
		
		String user_email = (String) session.getAttribute("user_email");
		
		
		if (user_email == null) {
			log.warn("로그인하지 않은 사용자의 글쓰기 시도.");
			rttr.addFlashAttribute("result", "auth_fail"); 
			return "redirect:/user/login"; 
		}

		
		Long club_id = (Long) session.getAttribute("club_id");
		
		
		post.setClub_id(club_id);
		post.setAuthor_email(user_email); 
		
		
		service.register(post);

		rttr.addFlashAttribute("result", post.getPost_id());
		rttr.addFlashAttribute("club_id", club_id);

		return "redirect:/post/list?club_id="+club_id;
	}

	@GetMapping("/get")
	public String get(@RequestParam("post_id") Long post_id, Criteria cri, Model model, HttpSession session, RedirectAttributes rttr) {
		String user_email = (String) session.getAttribute("user_email");
		
		if (user_email == null) {
			log.warn("로그인하지 않은 사용자의 접근 시도: /post/get");
			rttr.addFlashAttribute("result", "auth_fail"); 
			return "redirect:/user/login"; 
		}
		
		log.info("/get");
		PostVO post = service.get(post_id);
	    model.addAttribute("post", post);
	    model.addAttribute("cri", cri);
	    
	    
	    if (post != null) {
            
	    	ClubDTO clubInfo = clubService.getClub(post.getClub_id());
			model.addAttribute("clubInfo", clubInfo);
            
            
            boolean isLeader = clubInfo.getLeader_email().equals(user_email);
            model.addAttribute("isLeader", isLeader);

            
            boolean isMember = clubService.checkMember(post.getClub_id(), user_email);
            model.addAttribute("isMember", isMember);
		}
	    
	    return "/post/get";
	}
	 
	@GetMapping("/modify")
	public void modify(@RequestParam("post_id") Long post_id, Criteria cri, Model model, HttpSession session) { 
	    log.info("/modify");
	    
	    PostVO post = service.get(post_id);
	    model.addAttribute("post", post);
	    model.addAttribute("cri", cri);
	    
	    if(post != null) {
			ClubDTO clubInfo = clubService.getClub(post.getClub_id());
			model.addAttribute("clubInfo", clubInfo);
			
			
			String user_email = (String) session.getAttribute("user_email");
			if (user_email != null) {
				
				boolean isLeader = clubInfo.getLeader_email().equals(user_email);
				model.addAttribute("isLeader", isLeader);
				
				
				boolean isMember = clubService.checkMember(post.getClub_id(), user_email);
				model.addAttribute("isMember", isMember);
			} else {
				model.addAttribute("isLeader", false);
				model.addAttribute("isMember", false);
			}
		}
	}
	 
	 
	 
	 @PostMapping("/modify")
	 public ResponseEntity<String> modify(PostVO post,
			 
			 @RequestParam(value = "deleteFileIds", required = false) List<Long> deleteFileIds) {
		 
		 log.info("modify:" + post);
		 if (deleteFileIds != null) {
			 log.info("deleteFileIds: " + deleteFileIds);
		 }
		
		 try {
			 
			 boolean modifyResult = service.modify(post);
			 
			 
			 if (deleteFileIds != null && !deleteFileIds.isEmpty()) {
				 for(Long file_id : deleteFileIds) {
					 log.info("deleting file_id: " + file_id);
					 
					 
					 FileVO file = fileService.getFile(file_id);
					 if (file != null) {
						 
						 File fileOnDisk = new File(uploadFolder, file.getStorage_path());
						 if (fileOnDisk.exists()) {
							 fileOnDisk.delete();
						 }
						 
						 fileService.deleteFile(file_id);
					 }
				 }
			 }
			 
			 if (modifyResult) {
				 
				 return new ResponseEntity<>("success", HttpStatus.OK);
			 } else {
				 
				 return new ResponseEntity<>("error", HttpStatus.INTERNAL_SERVER_ERROR);
			 }
			 
		 } catch (Exception e) {
			 
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
				
				FileVO file = fileService.getFile(file_id);
				if (file == null) {
					log.warn("DB에 파일 정보가 없습니다: " + file_id);
					
					return new ResponseEntity<>("deleted", HttpStatus.OK); 
				}
				
				
				File fileOnDisk = new File(uploadFolder, file.getStorage_path());
				
				if (fileOnDisk.exists()) {
					if (!fileOnDisk.delete()) {
						log.error("물리적 파일 삭제 실패: " + fileOnDisk.getPath());
						
					}
				} else {
					log.warn("물리적 파일이 존재하지 않습니다: " + fileOnDisk.getPath());
				}
				
				
				fileService.deleteFile(file_id);
				
				return new ResponseEntity<>("deleted", HttpStatus.OK);
				
			} catch (Exception e) {
				log.error("파일 삭제 중 오류 발생: " + e.getMessage());
				return new ResponseEntity<>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}
	 
	 @GetMapping("/display")
	    @ResponseBody
	    public ResponseEntity<byte[]> getFile(@RequestParam("file_id") Long file_id, 
	                                          @RequestParam(value="type", required=false) String type) {
	        
	        FileVO fileVO = fileService.getFile(file_id);
	        if (fileVO == null) return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	        
	        File file = new File(uploadFolder, fileVO.getStorage_path());
	        if (!file.exists()) return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	        
	        ResponseEntity<byte[]> result = null;
	        
	        try {
	            HttpHeaders header = new HttpHeaders();
	            
	            header.add("Content-Type", Files.probeContentType(file.toPath()));
	            
	            
	            if ("thumb".equals(type)) {
	                
	                String thumbName = file.getParent() + File.separator + "s_" + file.getName();
	                File thumbFile = new File(thumbName);
	                
	                
	                if (!thumbFile.exists()) {
	                    
	                    Thumbnailator.createThumbnail(file, thumbFile, 200, 200);
	                }
	                
	                result = new ResponseEntity<>(Files.readAllBytes(thumbFile.toPath()), header, HttpStatus.OK);
	            } else {
	                
	                result = new ResponseEntity<>(Files.readAllBytes(file.toPath()), header, HttpStatus.OK);
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	        }
	        return result;
	    }
}