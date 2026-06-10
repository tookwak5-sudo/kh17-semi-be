package com.kh.khsemiprj.service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.khsemiprj.dao.EmpLeaveDao;
import com.kh.khsemiprj.dto.EmpDto;

@Service
public class EmpLeaveService {
	@Autowired
	private EmpLeaveDao empleaveDao;  
	
	private int count = 15; // 초기 휴가 개수
	
	// 목표 회원가입이 되면 emp_leave테이블에 회원의 아이디가 저장이 되도록 처리
	public void leaveInsert(String empId) {
		
		//회원가입이 일어나면, 여기로 들어와서 입력된 Id를 확인하고 그 아이디를 휴가 DB에 등록
		empleaveDao.insert(empId);
	}
	
	// 목표: 관리자가 로그인 하면 전 직원의 휴가 기록을 계산
	// 전 직원의 hireDate불러오기
	
	// 입사일 기준 계산
	public double calculateLeave(EmpDto empDto) { //직원들의 입사일이 입력이되면
		
		LocalDate now = LocalDate.now();
		LocalDate hireLocalDate = LocalDate.parse(empDto.getEmpHireDate());
		
		//입사 1개월 전
		if(now.isBefore(hireLocalDate.plusMonths(1))) {
			return 0;
		}
		
		// 고용일로부터 지금까지의 연계산
		long year = ChronoUnit.YEARS.between(hireLocalDate, now);
		
		// 1,2년차
		if(year < 2) {
			return count;
		}
		
		// 3년차부터 2년마다 + 1씩
		int plusLeave = (int) ((year - 1) / 2);
		
		// 최대 25일 휴가 부여 가능
		return Math.min(15+ plusLeave, 25);
		
	}
}
