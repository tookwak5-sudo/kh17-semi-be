package com.kh.khsemiprj.dto;


import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

//출퇴근 로그 dto
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class LogInoutDto {
	private long logInoutNo;
	private String logInoutEmpId;
	private Timestamp logInoutTime;
	private String logInoutType;
}
