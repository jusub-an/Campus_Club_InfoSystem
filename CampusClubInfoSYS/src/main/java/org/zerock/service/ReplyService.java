package org.zerock.service;

import java.util.List;
import org.zerock.domain.ReplyVO;

public interface ReplyService {
    
    public int register(ReplyVO vo);
    
    public ReplyVO get(Long comment_id);
    
    public int modify(ReplyVO vo);
    
    public int remove(Long comment_id);
    
    public List<ReplyVO> getList(Long post_id);
}