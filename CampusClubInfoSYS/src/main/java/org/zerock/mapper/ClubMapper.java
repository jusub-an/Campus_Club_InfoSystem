package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.ClubDTO;

public interface ClubMapper {
    List<ClubDTO> getList();
    ClubDTO read(Long club_id);
    int insert(ClubDTO dto);
    int update(ClubDTO dto);
    int delete(Long club_id);
    int countByLeaderEmail(String leader_email);
    List<ClubDTO> getListByLeader(String leader_email);
}
