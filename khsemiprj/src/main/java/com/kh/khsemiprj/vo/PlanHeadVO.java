package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import com.kh.khsemiprj.dto.PlanDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class PlanHeadVO {
	private int planNo;
	private String planEmpId;
	private Integer planAprvNo;
	private Long planDeptNo;
	private Integer planHeadNo;
	private String planName;
	private String planExplain;
	private String planSdate;
	private String planEdate;
	private Timestamp planWtime;
	private String planType;
	
	private int headNo;
	private String headName;
	private String headType;
}
