package com.kh.khsemiprj.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.khsemiprj.dao.EmpDao;
import com.kh.khsemiprj.dao.EmpLeaveDao;

@Service
public class EmpLeaveService {
	@Autowired
	private EmpDao empDao;
	@Autowired
	private EmpLeaveDao empleaveDao;  
	
	// 목표 회원가입이 되면 emp_leave테이블에 회원의 아이디가 저장이 되도록 처리
	public void insert(String empId) {
		
		//회원가입이 일어나면, 여기로 들어와서 입력된 Id를 확인하고 그 아이디를 휴가 DB에 등록
		
	}
}
