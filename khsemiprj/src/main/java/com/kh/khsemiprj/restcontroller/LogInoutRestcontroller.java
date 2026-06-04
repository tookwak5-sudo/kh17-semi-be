package com.kh.khsemiprj.restcontroller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kh.khsemiprj.dao.LogInoutDao;
import com.kh.khsemiprj.dto.LogInoutDto;
import com.kh.khsemiprj.exception.TargetNotfoundException;
import com.kh.khsemiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/log-inout")
public class LogInoutRestcontroller {
	
	@Autowired
	private LogInoutDao logInoutDao;
	
	// 출퇴근 등록
	@PostMapping("/action")
	public String insert(HttpSession session, Model model) {
		
		// 아이디를 세션에 받아오기
		String loginId = (String) session.getAttribute("loginId");
		// 아이디가 없으면 반려
		if(loginId == null) throw new TargetNotfoundException();
		
		// loginout no & type을 받아와서
		LogInoutDto logInoutDto = logInoutDao.selectOne(loginId);
		// 마지막 상태를 확인
		//String lastType = logInoutDao.
		// 클릭한 버튼과 현재 상태(출근, 퇴근)와 비교하고
		if(logInoutDto.getLogInoutType() == "출근") {
			logInoutDao.insert(logInoutDto);
		}
		model.addAttribute("logInoutDto", logInoutDto);
		
		return "안녕하세요";	
	}
	
}