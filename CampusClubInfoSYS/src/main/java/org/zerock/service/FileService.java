package org.zerock.service;

import org.zerock.domain.FileVO;

public interface FileService {
    // 파일 ID로 파일 정보 조회
    public FileVO getFile(Long file_id);
    
    // 파일 삭제 (DB에서만)
    public int deleteFile(Long file_id);
    
}