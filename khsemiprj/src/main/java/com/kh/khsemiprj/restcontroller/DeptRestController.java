package com.kh.khsemiprj.restcontroller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.khsemiprj.dao.DeptDao;
import com.kh.khsemiprj.dao.EmpPositionDeptDao;
import com.kh.khsemiprj.dto.EmpPositionDeptDto;
import com.kh.khsemiprj.vo.EmpPositionDeptVO;

@RestController
@RequestMapping("/rest/dept")
public class DeptRestController {
	@Autowired
	private DeptDao deptDao;
	@Autowired
	private EmpPositionDeptDao empPositionDeptDao;
	
	@PostMapping("/empPositionDeptList")
	public List<EmpPositionDeptVO> empPositionDeptList(@RequestParam long deptNo) {
		List<EmpPositionDeptDto> list = empPositionDeptDao.selectDepthEmp(deptNo);
		List<EmpPositionDeptVO> newList = new ArrayList<>();
		
		for(EmpPositionDeptDto empPositionDeptDto : list) {
			newList.add(EmpPositionDeptVO.builder()
						.empId(empPositionDeptDto.getEmpId())
						.deptNo(empPositionDeptDto.getDeptNo())
						.deptName(empPositionDeptDto.getDeptName())
						.empId(empPositionDeptDto.getEmpId())
						.empName(empPositionDeptDto.getEmpName())
						.empPositionName(empPositionDeptDto.getEmpPositionName())
						.deptEmpId(empPositionDeptDto.getDeptEmpId())
					.build());
		}
		
		return newList;
	};
	
	//@PostMapping("/deptEmpIdUpdate")
	
	@PostMapping("/empPositionDeptUpdate")
	public boolean empPositionDeptUpdate(@RequestParam List<String> empIdList
										, @RequestParam long deptNo) {
		
		try {
			for(int i = 0; i < empIdList.size(); i++) {
				String empId = empIdList.get(i);
//				//부서장 리셋
//				empPositionDeptDao.deptEmpIdReset(deptNo);
//				//부서장 지정
//				empPositionDeptDao.deptEmpIdUpdate(deptNo, empId);
//				//부서장 회원의 권한 변경
//				empPositionDeptDao.empGradeUpdate(empId);
			}
		
			return true;
		} catch(Exception e) {
			return false;
		}
	}
}
