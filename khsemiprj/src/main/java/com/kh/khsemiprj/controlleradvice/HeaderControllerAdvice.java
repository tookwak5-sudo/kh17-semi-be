package com.kh.khsemiprj.controlleradvice;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.kh.khsemiprj.dao.EmpDao;
import com.kh.khsemiprj.dao.LogInoutDao;
import com.kh.khsemiprj.dto.LogInoutDto;

import jakarta.servlet.http.HttpSession;

@ControllerAdvice
public class HeaderControllerAdvice {
	@Autowired
	private LogInoutDao logInoutDao;
	
	@Autowired
	private EmpDao empDao;
	
	//모든 jsp에서 ${logInoutType} 변수를 바로 사용가능하게 함
	@ModelAttribute("logInoutType")
	public String getLogInoutType(HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) return null;

        LogInoutDto lastDto = logInoutDao.getLastType(loginId);
        return (lastDto != null) ? lastDto.getLogInoutType() : "퇴근"; // 기본값 '퇴근'
	}
	
}
