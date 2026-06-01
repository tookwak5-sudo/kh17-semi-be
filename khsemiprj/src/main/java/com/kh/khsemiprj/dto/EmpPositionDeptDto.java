package com.kh.khsemiprj.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class EmpPositionDeptDto {
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
	
	// 부서 직책을 가져오기 위한 추가 필드
	
	// JOIN 결과를 담을 필드 추가
    private String empPositionName; // 직책 이름
    private String deptName;        // 부서 이름

    // Getter & Setter 추가
    public String getEmpPositionName() { return empPositionName; }
    public void setEmpPositionName(String empPositionName) { this.empPositionName = empPositionName; }
    
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
}
