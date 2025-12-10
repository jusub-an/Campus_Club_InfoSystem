package org.zerock.domain;

import lombok.Data;

@Data
public class FileVO {
    private Long file_id;
    private Long post_id;      // FK
    private String file_name;    // 원본 파일 이름
    private String storage_path; // 실제 저장 경로 (또는 UUID를 포함한 파일명)
}