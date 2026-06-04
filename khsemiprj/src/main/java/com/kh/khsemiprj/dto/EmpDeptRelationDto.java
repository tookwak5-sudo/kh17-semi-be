package com.kh.khsemiprj.dto;

import lombok.Builder;
import lombok.Data;

@Data @Builder
public class EmpDeptRelationDto {
	private String empId;
	private long deptNo;
}
