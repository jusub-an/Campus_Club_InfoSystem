package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.ApplicationDTO;
import org.zerock.domain.MemberDTO;
import org.zerock.mapper.ApplicationMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;

@Service
@AllArgsConstructor
public class ApplicationServiceImpl implements ApplicationService {
    
    @Setter(onMethod_ = @Autowired)
    private ApplicationMapper mapper;

    @Override
    public List<ApplicationDTO> getApplyListByClub(Long club_id){
        return mapper.getApplyList(club_id);
    }
    
    @Override
    public String getApplyEmailByClubId(String email, Long club_id) {
    	return mapper.getApplyEmailByClubId(email, club_id);
    }
    
    @Override
    public String getMemberEmailByClubId(String email, Long club_id) {
    	return mapper.getMemberEmailByClubId(email, club_id);
    }
    
    @Override
    // 중복 확인 로직 추가
    public boolean apply(ApplicationDTO dto) {
    	int count = mapper.countByApplicantEmailAndClubId(dto.getApplicant_email(), dto.getClub_id()); 

        if (count > 0) {
            return false;
        }
        
        mapper.insert(dto);
        return true; // 신청 성공
    }
    
    // 회원을 추방
    @Override
    public void expel(MemberDTO memberDTO) {
        mapper.deleteMember(memberDTO);
    }
    
    @Override
    public String getName(String email) {
    	return mapper.getName(email);
    }
    
    @Override
    public List<MemberDTO> getMemberListByClub(Long club_id) {
    	return mapper.getMemberList(club_id);
    }
    
    @Override
    public void approve(MemberDTO memberDTO, Long app_id) {
        mapper.insertMember(memberDTO);
        mapper.delete(app_id);
    }
    
    // 신청 거절
    @Override
    public void reject(Long app_id) {
        mapper.delete(app_id);
    }
}
