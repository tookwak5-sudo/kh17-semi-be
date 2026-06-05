package com.kh.khsemiprj.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @AllArgsConstructor @NoArgsConstructor
public class AprvDto {
	private int aprvNo;
	private String aprvWriter;
	private int aprvFormNo;
	private String aprvTitle;
	private String aprvContent;
	private String aprvStatus;
	private int aprvCurrentSeq;
	private Timestamp aprvTempWtime;
	private Timestamp aprvTempUtime;
	private Timestamp aprvSdate;
	private Timestamp aprvEdate;
	private Timestamp aprvWtime;
	private Timestamp aprvEtime;
}
