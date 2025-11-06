package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.PostVO;

public interface PostMapper {
	public List<PostVO> getList();
	public void insert(PostVO post);
	public void insertSelectKey(PostVO post);
	public PostVO read(Long post_id);
	public int delete(Long post_id);
	public int update(PostVO post);
	public List<PostVO> getListWithPaging(Criteria cri);
	public int getTotalCount(Criteria cri);
}