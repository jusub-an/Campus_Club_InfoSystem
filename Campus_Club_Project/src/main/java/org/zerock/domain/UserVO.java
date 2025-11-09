package org.zerock.domain;

import lombok.Data;

@Data
public class UserVO {
    private String user_email;    // 사용자 이메일 (PK, 로그인 ID)
    private String password;        // 비밀번호
    private String name;            // 이름
    private String student_id;    // 학번
    private String user_type_code; // 사용자 유형 코드 (e.g., "STU", "MGR")
}