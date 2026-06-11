package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class LeaveManageVO {
	
	//휴가테이블
	private String leaveEmpId;
	private String leaveYear;
	private double leaveTotal;
	private double leaveUsed; //total, used, remain, update의 경우 1년이 지날때 마다 갱신해줘야 함
	private double leaveRemain;
	private Timestamp leaveUpdate;
	
	//사원테이블
	private String empId;
	private String empHireDate;
	
	//휴가로그테이블
	private long leaveNo;
	private String leaveLogId; 
	private String leaveType;
	private double leaveAmount; //사용일수
	private double leaveTotalAfter; //변동후 총일수
	private double leaveUsedAfter; //변동후 사용일수
	private Timestamp leaveRecord; //로그 기록 시점
}
