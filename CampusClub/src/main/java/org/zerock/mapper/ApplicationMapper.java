package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.ApplicationDTO;
import org.zerock.domain.MemberDTO;

public interface ApplicationMapper {
    public List<ApplicationDTO> getApplyList(Long club_id);
    public List<MemberDTO> getMemberList(Long club_id);
    public void insert(ApplicationDTO dto);
    public String getName(String email);
    public String getMemberEmailByClubId(@Param("user_email")String email, @Param("club_id")Long club_id);
    public String getApplyEmailByClubId(@Param("applicant_email")String email, @Param("club_id")Long club_id);
    public String getApplyEmail(String email);
    // 특정 신청을 Application 테이블에서 삭제
    public void delete(Long app_id);
    // Member 테이블에 회원 추가 
    public void insertMember(MemberDTO dto);
    // 특정 회원을 Member 테이블에서 삭제
    public void deleteMember(MemberDTO dto);
	// 특정 이메일로 등록된 대기중인 신청 건수를 확인
    public int countByApplicantEmailAndClubId(@Param("applicant_email") String applicant_email, @Param("club_id") Long club_id);
}
