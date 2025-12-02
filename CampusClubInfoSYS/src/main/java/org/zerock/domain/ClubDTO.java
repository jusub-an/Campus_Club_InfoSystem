package org.zerock.domain;

import lombok.Data;

@Data
public class ClubDTO {
	private Long club_id; // 동아리 고유 ID
	private String club_name; // 동아리 이름
	private String logo_url; // 로고 저장 경로
	private String description; // 한줄 설명
	private String category; // 카테고리
	private String introduction; // 소개글
	private String leader_email; // 동아리 회장 이메일 (User 테이블 참조)
}
