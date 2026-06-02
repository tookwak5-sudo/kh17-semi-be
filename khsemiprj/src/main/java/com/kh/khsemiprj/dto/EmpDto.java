package com.kh.khsemiprj.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class EmpDto {
	private String empId;
	private int empPositionNo;
	private String empEmail;
	private String empPassword;
	private String empName;
	private String empBirth;
	private String empContact;
	private String empPost;
	private String empAddress1;
	private String empAddress2;
	private String empHireDate;
	private Timestamp empLogin;
	private String empValid;
	private Timestamp empValidDate;
	private Timestamp empChange;
	private Timestamp empLongLeave;
	private int empGrade;
}
