package com.kh.khsemiprj.dto;

import lombok.Builder;
import lombok.Data;

@Data @Builder
public class EmpPositionDto {
	private int empPositionNo;
	private String empPositionName;
	private int empPositionLevel;
}
