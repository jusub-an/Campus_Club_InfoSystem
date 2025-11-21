package org.zerock.domain;

import java.util.Date;
import lombok.Data;

@Data
public class ReplyVO {
    private Long comment_id;      // 댓글 고유 번호
    private Long post_id;         // 게시글 ID (FK)
    private String author_email;    // 작성자 이메일 (FK)
    private String content;         // 내용
    private Date created_date;    // 작성 날짜
    private Long parent_comment_id; // 부모 댓글 ID (대댓글용)
    private String writer_role;
}