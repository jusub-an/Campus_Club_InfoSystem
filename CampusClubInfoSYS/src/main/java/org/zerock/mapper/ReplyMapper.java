package org.zerock.mapper;

import java.util.List;
import org.zerock.domain.ReplyVO;

public interface ReplyMapper {

    // 1. 댓글 등록
    public int insert(ReplyVO vo);
    
    // 2. 특정 댓글 조회 (수정/삭제 시 사용)
    public ReplyVO read(Long comment_id);
    
    // 3. 댓글 삭제
    public int delete(Long comment_id);
    
    // 4. 댓글 수정
    public int update(ReplyVO vo);
    
    // 5. 특정 게시글의 모든 댓글 목록 조회
    public List<ReplyVO> getListByPostId(Long post_id);
    
    // 6. 특정 게시글의 댓글 수
//     public int getCountByPostId(Long post_id);
    
    // 7. 특정 게시글의 모든 댓글 삭제
    public int deleteByPostId(Long post_id);
}