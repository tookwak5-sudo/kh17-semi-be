package com.kh.khsemiprj.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class AprvHeadDto {
	private int HeadNo;
	private String HeadName;
	private String HeadType;
}
