package com.kh.khsemiprj.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class DeptDto {
	private int deptNo;
	private Integer deptParentNo;
	private String deptName;
	private int deptDepth; //default 0 not null,
	private String deptUseYn;
	private String deptEmpId;
}
