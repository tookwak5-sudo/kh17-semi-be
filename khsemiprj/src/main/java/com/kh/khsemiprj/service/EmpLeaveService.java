package com.kh.khsemiprj.service;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.kh.khsemiprj.dao.EmpLeaveDao;
import com.kh.khsemiprj.vo.LeaveManageVO;

@Service
public class EmpLeaveService {
	@Autowired
	private EmpLeaveDao empLeaveDao;  
	
	/*
	 * [스케줄러 메소드]
	 * 매일 자정 0시 0분 0초에 자동 실행
	 * */

//@Scheduled(cron = "0 0 0 * * *")
//	@Scheduled(fixedRate = 5000)
	public void autoUpdateLeave() {
		// 내부적으로 기존 로직 호출
		// 시스템 작업이므로 empId를 "SYSTEM"등으로 지정
		calculateLeaveDays("SYSTEM", null);
 		System.out.println("자동 휴가 갱신 로직 실행: " + LocalDate.now());
	}
	
	//휴가
	public void calculateLeaveDays(String empId, String hireDateStr) {
		//1. 오늘이 입사 기념일인 사원들 조회(1년차 이상)
		List<LeaveManageVO> targets = empLeaveDao.selectTarget();
		
		//디버깅 용 로그
		System.out.println("조회된 대상자 수: " + targets);
		System.out.println("들어온 아이디" + empId);
		for(LeaveManageVO target : targets) {
			// 3. 휴가 개수 계산
			double newTotal = calculateLeave(target.getEmpHireDate());
			
			// 4. 휴가 테이블 갱신 
			target.setLeaveTotal(newTotal); //전체 휴가는 계산된 휴가로
			target.setLeaveYear(String.valueOf(LocalDate.now().getYear())); //현재 연도를 입력
			target.setLeaveUsed(0.0); // 사용휴가는 0
			target.setLeaveRemain(newTotal); // 남은휴가수도 전체휴가와 동일하게
			target.setLeaveUpdate(new Timestamp(System.currentTimeMillis())); // 현재시간으로 업데이트
			empLeaveDao.updateLeave(target); // 업데이트
			
			// 5. 로그 테이블 기록
			target.setLeaveType("갱신");
			target.setLeaveLogId(target.getEmpId());
			target.setLeaveAmount(newTotal);
			target.setLeaveTotalAfter(newTotal);
			target.setLeaveUsedAfter(0.0);
			empLeaveDao.logInsert(target);
		}
	}
	
	//휴가 개수 계산식
	private double calculateLeave(String hireDateStr) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate hireDate = LocalDate.parse(hireDateStr, formatter);
		LocalDate today = LocalDate.now();
		// 0. 입사 후 1개월이 지난 시점 계산
		LocalDate oneMonthAfterHire = hireDate.plusMonths(1);
		
		// 1. 로직 적용
		double newTotal;
		if (today.isBefore(oneMonthAfterHire) ) {
			newTotal = 0;
		}
		else {
			//1개월 이상이면 근속년수 계산
			long yearsOfService = ChronoUnit.YEARS.between(hireDate, today);
			
			
			if(yearsOfService < 1) { // 1년차인 경우
				newTotal = 15;
			}
			else { // 2년차 이상인 경우
				//3년차부터 연차 증가 로직
				int extra = (int)((yearsOfService - 1) / 2);
				newTotal = Math.min(15 + extra, 25);
			}
		}
		
		return newTotal;
	}
	
	
}
