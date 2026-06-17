package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class PlanEmpDeptVO {
	private int planNo;
	private String planEmpId;
	private Long planDeptNo;
	private Integer planHeadNo;
	private String planName;
	private String planSdate;
	private String planEdate;
	private String planType;
	
	private String empName;
	private String deptName;
}
