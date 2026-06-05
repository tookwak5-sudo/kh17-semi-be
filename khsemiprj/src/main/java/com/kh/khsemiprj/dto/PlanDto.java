package com.kh.khsemiprj.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class PlanDto {
	private int planNo;
	private String planEmpId;
	private Integer planAprvNo;
	private Long planDeptNo;
	private String planName;
	private String planHeader;
	private String planExplain;
	private String planSdate;
	private String planEdate;
	private Timestamp planWtime;
	private String planType;

}
