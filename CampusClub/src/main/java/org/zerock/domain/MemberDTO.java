package org.zerock.domain;

import lombok.Data;

@Data
public class MemberDTO {
	public Long member_id;
	public Long club_id;
	public String user_email;
}
