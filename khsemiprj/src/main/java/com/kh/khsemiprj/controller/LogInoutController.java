package com.kh.khsemiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.khsemiprj.dao.LogInoutDao;
import com.kh.khsemiprj.dto.LogInoutDto;
import com.kh.khsemiprj.vo.PageVO;

@Controller
@RequestMapping("/admin/log-inout")
public class LogInoutController {
	@Autowired
	private LogInoutDao logInoutDao;
	
	// 출퇴근 목록
	@RequestMapping("/list")
	public String list(Model model, @ModelAttribute PageVO pageVO) {
		
		// 출퇴근 목록 리스트
		List<LogInoutDto> list = logInoutDao.selectList(pageVO);
		
		model.addAttribute("list", list); // 전달
		
		//페이징을 위해 추가로 전달할 값이 있다면 전달해야 한다
		int count = logInoutDao.count(pageVO);
		pageVO.setCount(count);//데이터 개수 설정
		model.addAttribute("pageVO", pageVO);
		return "admin/log-inout/list";
	}
}
