package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.ClubDTO;
import org.zerock.mapper.ClubMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class ClubServiceImpl implements ClubService {

	@Setter(onMethod_ = @Autowired)
	private ClubMapper mapper;

	@Override
	public List<ClubDTO> getClubList() {
		log.info("getClubList......");
		return mapper.getList();
	}

	@Override
	public ClubDTO getClub(Long club_id) {
		log.info("getClub......" + club_id);
		return mapper.read(club_id);
	}

	@Override
	public boolean registerClub(ClubDTO dto) {
		log.info("registerClub......" + dto);
		return mapper.insert(dto) == 1;
	}

	@Override
	public boolean updateClub(ClubDTO dto) {
		log.info("updateClub......" + dto);
		return mapper.update(dto) == 1;
	}

	@Override
	public boolean deleteClub(Long club_id) {
		log.info("deleteClub......" + club_id);
		return mapper.delete(club_id) == 1;
	}

	@Override
	public List<ClubDTO> getClubsByLeader(String leader_email) {
		log.info("getClubsByLeader......" + leader_email);
		return mapper.getListByLeader(leader_email);
	}
	
	@Override
    public boolean hasClub(String leaderEmail) {
        return mapper.countByLeaderEmail(leaderEmail) > 0;
    }
	
	@Override
	public List<ClubDTO> searchClubsByName(String keyword) {
		log.info("searchClubsByName......" + keyword);

        if (keyword == null || keyword.trim().isEmpty()) {
            // 검색어 없으면 전체 목록
            return mapper.getList();
        }

        // 검색어 있으면 이름으로 검색
        return mapper.searchByName(keyword.trim());
	}

}
