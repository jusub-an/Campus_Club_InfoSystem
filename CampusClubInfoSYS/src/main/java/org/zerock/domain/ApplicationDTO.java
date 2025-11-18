package org.zerock.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ApplicationDTO {
    private Long app_id;
    private Long club_id;
    private String applicant_email;
    private String applicant_text;
    private Date applied_at;
}
