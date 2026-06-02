package com.kh.khsemiprj.restcontroller;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.khsemiprj.dao.CertDao;
import com.kh.khsemiprj.dto.CertDto;
import com.kh.khsemiprj.service.EmailService;

import jakarta.mail.MessagingException;

@CrossOrigin
@RestController
@RequestMapping("/rest/cert")
public class CertRestcontroller {
	@Autowired
	private EmailService emailService;
	@Autowired
	private CertDao certDao;
	
	@PostMapping("/send")
	public void send(@RequestParam String certEmail) throws MessagingException, IOException {
		emailService.sendCertEmp(certEmail);
	}
	
	//인증번호 검사
		@PostMapping("/check")
		public boolean check(@ModelAttribute CertDto certDto) {
			//1. 정보가 있는지 확인
			CertDto findDto = certDao.selectOne(certDto.getCertEmail());
			if(findDto == null) return false;
			
			//2. 번호가 맞는지 확인
			boolean valid = certDto.getCertNumber().equals(findDto.getCertNumber());
			if(valid == false) return false;
			
			//3. 시간이 유효한지 확인
			LocalDateTime current = LocalDateTime.now();//현재시각
			LocalDateTime sent = findDto.getCertTime().toLocalDateTime();//발송시각
			Duration duration = Duration.between(sent, current);
			if(duration.toMinutes() > 10) {//10분이 지났어?
				return false;
			}
			
			//4. 인증 가능한 상태인지 확인 (cert_yn = 'N')
			if(findDto.getCertYn().equals("Y")) {
				return false;
			}
			
			certDao.delete(certDto.getCertEmail()); // 사용한 인증번호 지우기!
			return true;//잘했어! 통과!
		}

}
