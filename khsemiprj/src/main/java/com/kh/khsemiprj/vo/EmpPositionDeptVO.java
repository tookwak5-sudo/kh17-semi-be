package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class EmpPositionDeptVO {
	private String empId;
	private String empName;
	// JOIN 결과를 담을 필드 추가
    private String empPositionName; // 직책 이름
    private String deptName;        // 부서 이름
    private int empPositionLevel;
    private long deptNo; // 부서번호
    private String deptEmpId; //부서장 아이디
}
