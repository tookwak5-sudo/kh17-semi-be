package com.kh.khsemiprj.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class LogAccessDto {
	private long accessNo;
	private String accessEmpId;
	private Timestamp accessDate;
	private String accessUrl;
	private String accessIp;
	private String empName;
	private String deptName;
}
