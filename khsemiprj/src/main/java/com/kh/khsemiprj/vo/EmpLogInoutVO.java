package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class EmpLogInoutVO {
	private long logInoutNo;
	private String logInoutEmpId;
	private Timestamp logInoutTime;
	private String logInoutType;
	
	private String empName;
}
