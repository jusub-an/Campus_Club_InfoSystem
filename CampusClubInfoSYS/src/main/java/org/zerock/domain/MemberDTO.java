package org.zerock.domain;

import lombok.Data;

@Data
public class MemberDTO {
	public Long member_id;
	public Long club_id;
	public String user_email;
	
    // ✅ 회원 이름(또는 닉네임) 컬럼
    public String name;
}
