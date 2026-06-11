package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class AprvLineListVO {
	private int aprvLineNo;
	private int aprvDocumentNo;
	private int aprvLineCurrentSeq;
	private String aprvLineStatus;
	private String aprvLineComment;
	private Timestamp aprvLineDate;
	private String empId;
	private String empName;
	private String empPositionName;
	private String deptName;
}
