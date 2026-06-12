package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import com.kh.khsemiprj.dto.AprvDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @AllArgsConstructor @NoArgsConstructor
public class EmpAprvLineVO {
	private int aprvNo;
	private String aprvTitle;
	private String empName;
	private String aprvWriter;
	private String aprvStatus;
	private String empId;
	
}
