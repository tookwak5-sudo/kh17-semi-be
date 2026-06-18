package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class EmpExitVO {
	 private String empId;
	 private Timestamp empExitTime;//사직 신청 시각
	 private String empName;
	 private Timestamp aprvEtime;//사직 처리 시각
}
