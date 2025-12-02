package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.ClubDTO;

public interface ClubMapper {
    List<ClubDTO> getList();
    ClubDTO read(Long club_id);
    int insert(ClubDTO dto);
    int update(ClubDTO dto);
    int delete(Long club_id);
    int countByLeaderEmail(String leader_email);
    List<ClubDTO> getListByLeader(String leader_email);
    
    // 동아리 이름으로 LIKE 검색
    List<ClubDTO> searchByName(@Param("keyword") String keyword);
    
    // 전체 목록 (검색어 없을 때)
    List<ClubDTO> findAll();
    
    // 이름 + 카테고리 조건 검색
    List<ClubDTO> searchByCondition(@Param("keyword") String keyword,
                                    @Param("category") String category);
    
    public int checkMember(@Param("club_id") Long club_id, @Param("user_email") String user_email);
}
