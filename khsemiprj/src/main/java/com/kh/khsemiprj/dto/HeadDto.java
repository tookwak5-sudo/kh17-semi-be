package com.kh.khsemiprj.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class HeadDto {
	private int headNo;
	private String headName;
	private String headType;
}
