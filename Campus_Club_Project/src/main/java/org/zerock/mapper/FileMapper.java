package org.zerock.mapper;
import java.util.List; 
import org.zerock.domain.FileVO;

public interface FileMapper {
    // 파일 등록
    public void insert(FileVO file);
    // 게시물 ID로 파일 목록 조회
    public List<FileVO> findByPostId(Long post_id);
    // 파일 ID로 파일 1개 조회 (이 줄을 추가)
    public FileVO getFile(Long file_id);
    
    public int delete(Long file_id);
}