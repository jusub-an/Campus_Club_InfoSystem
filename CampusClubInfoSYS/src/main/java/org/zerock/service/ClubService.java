package org.zerock.service;

import java.util.List;

import org.zerock.domain.ClubDTO;

public interface ClubService {

	// 모든 동아리 목록 조회 
	public List<ClubDTO> getClubList(); 
	// 특정 동아리 상세 조회 
	public ClubDTO getClub(Long club_id); 
	// 새 동아리 등록 (게시판에 올리기) 
	public boolean registerClub(ClubDTO dto); 
	// 동아리 정보 수정 
	public boolean updateClub(ClubDTO dto); 
	// 동아리 삭제 
	public boolean deleteClub(Long club_id); 
	// 회장 이메일로 동아리 조회
	public List<ClubDTO> getClubsByLeader(String leader_email);
	// 이 이메일로 이미 동아리 등록한 적 있는지
	public boolean hasClub(String leaderEmail);
	
	// 동아리 이름 검색
	public List<ClubDTO> searchClubsByName(String keyword);
	// 이름 + 카테고리로 검색
    List<ClubDTO> searchClubs(String keyword, String category);
}
