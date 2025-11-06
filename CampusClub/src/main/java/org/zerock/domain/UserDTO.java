package org.zerock.domain;

import lombok.Data;

@Data
public class UserDTO {
	public String user_email;
	public String password;
	public String name;
	public Long student_id;
	public String user_type_code;
}
