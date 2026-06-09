package com.kh.khsemiprj.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @AllArgsConstructor @NoArgsConstructor
public class AprvLineDto {
	private int aprvLineNo;
	private int aprvDocumentNo;
	private int aprvLineCurrentSeq;
	private String aprvLineStatus;
	private String aprvLineComment;
	private Timestamp aprvLineDate;
	private String empId;
}
