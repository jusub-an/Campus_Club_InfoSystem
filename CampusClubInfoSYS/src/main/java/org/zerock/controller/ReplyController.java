package org.zerock.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

@RestController
@RequestMapping("/replies")
public class ReplyController {

    @Autowired
    private ReplyService service;

    /**
     * 1. 댓글 등록 (POST)
     * consumes: 들어오는 데이터 타입 (JSON)
     * produces: 반환하는 데이터 타입 (TEXT)
     * @RequestBody: JSON으로 받은 데이터를 ReplyVO 객체로 변환
     */
    @PostMapping(value = "/new", 
                 consumes = MediaType.APPLICATION_JSON_VALUE, 
                 produces = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<String> create(@RequestBody ReplyVO vo, HttpSession session) {
    	String author_email = (String) session.getAttribute("user_email");
    	
    	if (author_email == null) {
            return new ResponseEntity<>("login_required", HttpStatus.UNAUTHORIZED); // 401
        }
    	
    	vo.setAuthor_email(author_email);
    	
        int insertCount = service.register(vo);
        
        return insertCount == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    /**
     * 2. 특정 게시글의 댓글 목록 조회 (GET)
     * @PathVariable: URL 경로의 일부({post_id})를 파라미터로 받음
     */
    @GetMapping(value = "/post/{post_id}", 
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<ReplyVO>> getList(@PathVariable("post_id") Long post_id) {
        
        List<ReplyVO> list = service.getList(post_id);
        
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    /**
     * 3. 댓글 수정 (PUT 또는 PATCH)
     * @PathVariable: comment_id
     * @RequestBody: 수정될 내용 (JSON)
     */
    @PutMapping(value = "/{comment_id}", 
                consumes = MediaType.APPLICATION_JSON_VALUE, 
                produces = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<String> modify(@PathVariable("comment_id") Long comment_id, 
                                       @RequestBody ReplyVO vo,
                                       HttpSession session) {
        
    	String loggedInUserEmail = (String) session.getAttribute("user_email");
        if (loggedInUserEmail == null) {
            return new ResponseEntity<>("login_required", HttpStatus.UNAUTHORIZED); // 401
        }
        
        
        ReplyVO originalReply = service.get(comment_id);
        if (originalReply == null) {
            return new ResponseEntity<>("reply_not_found", HttpStatus.NOT_FOUND); // 404
        }
        
        if (!originalReply.getAuthor_email().equals(loggedInUserEmail)) {
            return new ResponseEntity<>("forbidden", HttpStatus.FORBIDDEN); // 403
        }
        vo.setComment_id(comment_id);
        
        return service.modify(vo) == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    /**
     * 4. 댓글 삭제 (DELETE)
     * @PathVariable: comment_id
     */
    @DeleteMapping(value = "/{comment_id}", 
                   produces = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<String> remove(@PathVariable("comment_id") Long comment_id, HttpSession session) {
        
    	String loggedInUserEmail = (String) session.getAttribute("user_email");
        if (loggedInUserEmail == null) {
            return new ResponseEntity<>("login_required", HttpStatus.UNAUTHORIZED); // 401
        }
        
        ReplyVO originalReply = service.get(comment_id);
        if (originalReply == null) {
            return new ResponseEntity<>("reply_not_found", HttpStatus.NOT_FOUND); // 404
        }
        
        if (!originalReply.getAuthor_email().equals(loggedInUserEmail)) {
            return new ResponseEntity<>("forbidden", HttpStatus.FORBIDDEN); // 403
        }
        
        return service.remove(comment_id) == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    /**
     * (참고) 5. 특정 댓글 1개 조회 (GET) - (수정 폼 띄울 때 사용 가능)
     */
    @GetMapping(value = "/{comment_id}", 
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ReplyVO> get(@PathVariable("comment_id") Long comment_id) {
        
        return new ResponseEntity<>(service.get(comment_id), HttpStatus.OK);
    }
}