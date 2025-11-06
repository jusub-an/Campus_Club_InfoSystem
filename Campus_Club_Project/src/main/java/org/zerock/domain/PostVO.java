package org.zerock.domain;

import java.util.Date;
import java.util.List; // 추가
import org.springframework.web.multipart.MultipartFile; // 추가

import lombok.Data;
@Data
public class PostVO {
	private Long post_id; //(NUMBER는 자바에서 없으니 LONG 데이터타입으로 선언)
	private Long club_id;
	private String author_email;
	private String title;
	private String content;
	private Date created_date;
	private String post_type;
    private List<MultipartFile> uploadFiles;
    private List<FileVO> attachList;
}