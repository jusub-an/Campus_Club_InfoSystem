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

    
    @PostMapping(value = "/new", 
                 consumes = MediaType.APPLICATION_JSON_VALUE, 
                 produces = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<String> create(@RequestBody ReplyVO vo, HttpSession session) {
    	String author_email = (String) session.getAttribute("user_email");
    	
    	if (author_email == null) {
            return new ResponseEntity<>("login_required", HttpStatus.UNAUTHORIZED); 
        }
    	
    	vo.setAuthor_email(author_email);
    	
        int insertCount = service.register(vo);
        
        return insertCount == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    
    @GetMapping(value = "/post/{post_id}", 
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<ReplyVO>> getList(@PathVariable("post_id") Long post_id) {
        
        List<ReplyVO> list = service.getList(post_id);
        
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    
    @PutMapping(value = "/{comment_id}", 
                consumes = MediaType.APPLICATION_JSON_VALUE, 
                produces = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<String> modify(@PathVariable("comment_id") Long comment_id, 
                                       @RequestBody ReplyVO vo,
                                       HttpSession session) {
        
    	String loggedInUserEmail = (String) session.getAttribute("user_email");
        if (loggedInUserEmail == null) {
            return new ResponseEntity<>("login_required", HttpStatus.UNAUTHORIZED); 
        }
        
        
        ReplyVO originalReply = service.get(comment_id);
        if (originalReply == null) {
            return new ResponseEntity<>("reply_not_found", HttpStatus.NOT_FOUND); 
        }
        
        if (!originalReply.getAuthor_email().equals(loggedInUserEmail)) {
            return new ResponseEntity<>("forbidden", HttpStatus.FORBIDDEN); 
        }
        vo.setComment_id(comment_id);
        
        return service.modify(vo) == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    
    @DeleteMapping(value = "/{comment_id}", 
                   produces = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<String> remove(@PathVariable("comment_id") Long comment_id, HttpSession session) {
        
    	String loggedInUserEmail = (String) session.getAttribute("user_email");
        if (loggedInUserEmail == null) {
            return new ResponseEntity<>("login_required", HttpStatus.UNAUTHORIZED); 
        }
        
        ReplyVO originalReply = service.get(comment_id);
        if (originalReply == null) {
            return new ResponseEntity<>("reply_not_found", HttpStatus.NOT_FOUND); 
        }
        
        if (!originalReply.getAuthor_email().equals(loggedInUserEmail)) {
            return new ResponseEntity<>("forbidden", HttpStatus.FORBIDDEN); 
        }
        
        return service.remove(comment_id) == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    
    @GetMapping(value = "/{comment_id}", 
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ReplyVO> get(@PathVariable("comment_id") Long comment_id) {
        
        return new ResponseEntity<>(service.get(comment_id), HttpStatus.OK);
    }
}