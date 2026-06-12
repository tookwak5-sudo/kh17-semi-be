package com.kh.khsemiprj.vo;

import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class DeptVO {
	private long deptNo;
	private Long deptParentNo;
	private String deptName;
	private int deptDepth; //default 0 not null,
	private String deptUseYn;
	private String deptEmpId;
	
	// 이 부서에 속한 사원 목록
    private List<EmpPositionDeptVO> empList = new ArrayList<>();
    
    // 이 부서의 하위 부서 목록 (셀프 참조 구조)
    private List<DeptVO> children = new ArrayList<>();
}
