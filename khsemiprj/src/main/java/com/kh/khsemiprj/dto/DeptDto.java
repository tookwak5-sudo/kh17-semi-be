package com.kh.khsemiprj.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class DeptDto {
	private long deptNo;
	private long deptParentNo;
	private String deptName;
	private int deptDepth;
	private String deptUseYn;
	//private String deptEmpId;
}
