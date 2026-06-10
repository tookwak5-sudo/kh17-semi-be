package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class LeaveCalVO {
	private String leaveEmpId;
	private double leaveTotal;
	private double leaveUsed; //total, used, remain, update의 경우 1년이 지날때 마다 갱신해줘야 함
	private double leaveRemain;
	private Timestamp leaveUpdate;
	
	private String empHireDate;
	
}
