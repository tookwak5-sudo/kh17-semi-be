package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @AllArgsConstructor @NoArgsConstructor
public class AprvDetailVO {
	private int aprvNo;
	private String aprvWriter;
	private int aprvFormNo;
	private String aprvTitle;
	private String aprvContent;
	private String aprvStatus;
	private int aprvCurrentSeq;
	private Timestamp aprvTempWtime;
	private Timestamp aprvTempUtime;
	private String aprvSdate;
	private String aprvEdate;
	private Timestamp aprvWtime;
	private Timestamp aprvEtime;
	private Double aprvLeave;
	private int headNo;
	private String headName;
	private long deptNo;
	private String empName;
	private String empPositionName;
	private String deptName;
}
