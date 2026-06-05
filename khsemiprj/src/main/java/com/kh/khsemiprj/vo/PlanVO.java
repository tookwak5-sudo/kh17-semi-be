package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import com.kh.khsemiprj.dto.PlanDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class PlanVO {
	private String title;
	private String start;
	private String end;
}
