package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PostVO;

public interface PostService {

	public void register(PostVO post);

	public PostVO get(Long post_id);

	public boolean modify(PostVO post);

	public boolean remove(Long post_id);

	public List<PostVO> getList();
	
	public List<PostVO> getList(Criteria cri);
	
	public int getTotal(Criteria cri);
}