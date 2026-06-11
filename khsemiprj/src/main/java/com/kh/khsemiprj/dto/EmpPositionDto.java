package com.kh.khsemiprj.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class EmpPositionDto {
	private int empPositionNo;
	private String empPositionName;
	private int empPositionLevel;
}
