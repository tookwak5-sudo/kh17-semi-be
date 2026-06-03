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
	public List<EmpPositionDeptVO> empPositionDeptList(@RequestParam String deptNo) {
		Long longDeptNo = deptNo == "" ? null : Long.parseLong(deptNo);
		List<EmpPositionDeptDto> list = longDeptNo == null ? empPositionDeptDao.selectDepthEmpByNull() : empPositionDeptDao.selectDepthEmp(longDeptNo);
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
	
	//부서 변경
	@PostMapping("/empPositionDeptUpdate")
	public boolean empPositionDeptUpdate(@RequestParam List<String> empIdList
										, @RequestParam long fromDeptNo
										, @RequestParam long toDeptNo) {
		
		try {
			for(int i = 0; i < empIdList.size(); i++) {
				String empId = empIdList.get(i);
				//부서장 사원 아이디 확인
				String deptEmpId = empPositionDeptDao.checkDeptEmpId(fromDeptNo);
				//부서장이라면
				if(deptEmpId == empId) {
					//부서장 리셋
					empPositionDeptDao.deptEmpIdReset(fromDeptNo);
					//부서장 권한 강등
					empPositionDeptDao.empGradeDemotion(deptEmpId);
				}
			}
		
			return true;
		} catch(Exception e) {
			return false;
		}
	}
	
	//부서장 지정
	@PostMapping("/deptEmpIdUpdate")
	public boolean deptEmpIdUpdate(@RequestParam String empId
										, @RequestParam long deptNo)
	{
		try {
			//기존 부서장 사원 아이디 확인
			String deptEmpId = empPositionDeptDao.checkDeptEmpId(deptNo);
			//기존 부서장 리셋
			empPositionDeptDao.deptEmpIdReset(deptNo);
			//기존 부서장 권한 강등
			empPositionDeptDao.empGradeDemotion(deptEmpId);
			//신규 부서장 지정
			empPositionDeptDao.deptEmpIdUpdate(deptNo, empId);
			//신규 부서장 권한 상승
			empPositionDeptDao.empGradePromotion(empId);
			
			return true;
		} catch(Exception e) {
			return false;
		}
	}
}
