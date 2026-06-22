package com.kh.khsemiprj.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.khsemiprj.dao.EmpDao;
import com.kh.khsemiprj.dto.EmpDto;

@Service
public class PasswordService {
	@Autowired
	private RandomService randomService;
	@Autowired
	private EmpDao empDao;
	
	//임시 비밀번호로 초기화
	public void sendTempPassword(EmpDto empDto) {
		// 임시 비밀번호 생성
		String tempPassword = randomService.generatePassword(5);
		
		empDto.setEmpPassword(tempPassword);
		
		// 기존 비밀번호를 임시 비밀번호로 업데이트
		boolean isUpdateSuccess = empDao.updateTempPassword(empDto);
		
		// 성공 여부에 따른 추가 로직 처리
		if (isUpdateSuccess) {
			System.out.println("비밀번호 변경 성공! 변경된 비밀번호: " + tempPassword);
			// 여기서 보통 사용자 이메일이나 SMS로 tempPassword를 발송하는 로직이 들어갑니다.
		} else {
			System.out.println("비밀번호 변경 실패 (존재하지 않는 사용자 ID 등)");
		}
	}
}
