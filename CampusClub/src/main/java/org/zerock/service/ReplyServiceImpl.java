package org.zerock.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.ReplyVO;
import org.zerock.mapper.ReplyMapper;
import lombok.Setter;

@Service
public class ReplyServiceImpl implements ReplyService {

    @Setter(onMethod_ = @Autowired)
    private ReplyMapper mapper;

    @Override
    public int register(ReplyVO vo) {
        return mapper.insert(vo);
    }

    @Override
    public ReplyVO get(Long comment_id) {
        return mapper.read(comment_id);
    }

    @Override
    public int modify(ReplyVO vo) {
        return mapper.update(vo);
    }

    @Override
    public int remove(Long comment_id) {
        return mapper.delete(comment_id);
    }

    @Override
    public List<ReplyVO> getList(Long post_id) {
        return mapper.getListByPostId(post_id);
    }
}