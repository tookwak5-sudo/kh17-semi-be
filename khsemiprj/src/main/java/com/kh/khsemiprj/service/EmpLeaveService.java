package com.kh.khsemiprj.service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.khsemiprj.dao.EmpLeaveDao;
import com.kh.khsemiprj.vo.LeaveCalVO;

@Service
public class EmpLeaveService {
	@Autowired
	private EmpLeaveDao empLeaveDao;  
	
	private int count = 15; // 초기 휴가 개수
	
	// 목표 회원가입이 되면 emp_leave테이블에 회원의 아이디가 저장이 되도록 처리
	public void leaveInsert(String empId) {
		
		//회원가입이 일어나면, 여기로 들어와서 입력된 Id를 확인하고 그 아이디를 휴가 DB에 등록
		empLeaveDao.insert(empId);
	}
	
	// 목표: 관리자가 로그인 하면 전 직원의 휴가 기록을 계산
	// 전 직원 조회
	public void updateAllEmp() {
		// 1. 전 직원 조회
		List<LeaveCalVO> empList = empLeaveDao.selectAll();
		
		// 2. 한 명씩 계산
		for(LeaveCalVO calVO : empList) {
//			double totalLeave = calculateLeave(calVO);
		}
	}
	
//	// 입사일 기준 계산
//	public void updateEmployeeLeave(LeaveCalVO calVO) {
//		
//		//입사일 1년 체크
//		LocalDate now = LocalDate.now();
//		LocalDate hireLocalDate = LocalDate.parse(calVO.getEmpHireDate());
//		
//		//입사일을 구하고
//		LocalDate hireDate = LocalDate.parse(calVO.getEmpHireDate());
//		//올해의 입사일을 구해서
//		//ex 입사일 2022.08.05 오늘 2026.06.10 올해의 입사일 2026.08.05
//		LocalDate anniversary = hireDate.withYear(now.getYear());
//		
//		// 올해의 입사일 오늘보다 후 라면 즉, 1년 후라면
//		boolean needUpdate = now.isBefore(anniversary) == false;
//
//	    // 갱신 필요
//		if (needUpdate) {
//		    double leaveCount = calculateLeave(calVO);
//		    empLeaveDao.updateLeave(calVO.getLeaveEmpId(), leaveCount);
//		}
//	}
//	
//	public double calculateLeave(LeaveCalVO calVO) { //직원들의 입사일이 입력이되면
//		LocalDate now = LocalDate.now();
//		LocalDate hireLocalDate = LocalDate.parse(calVO.getEmpHireDate());
//		
//		//입사 1개월 전
//		if(now.isBefore(hireLocalDate.plusMonths(1))) {
//			return 0;
//		}
//		
//		// 고용일로부터 지금까지의 연계산
//		long year = ChronoUnit.YEARS.between(hireLocalDate, now);
//		
//		// 1,2년차
//		if(year < 2) {
//			return count;
//		}
//		
//		// 3년차부터 2년마다 + 1씩
//		int plusLeave = (int) ((year - 1) / 2);
//		
//		// 최대 25일 휴가 부여 가능
//		return Math.min(15+ plusLeave, 25);
//		
//	}
}
