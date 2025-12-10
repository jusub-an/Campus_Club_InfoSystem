package org.zerock.domain;

import lombok.Data;

@Data
public class UserDTO {
	private String user_email;
	private String password;
	private String name;
	private Long student_id;
	private String user_type_code;
}
