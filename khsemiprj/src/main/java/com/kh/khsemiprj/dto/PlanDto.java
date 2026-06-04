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
	private int planAprvNo;
	private long planDeptNo;
	private String planName;
	private String planType;
	private String planExplain;
	private Timestamp planSdate;
	private Timestamp planEdate;
	private Timestamp planWtime;

}
