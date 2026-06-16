package com.kh.khsemiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.khsemiprj.dao.LogAccessDao;
import com.kh.khsemiprj.dto.LogAccessDto;
import com.kh.khsemiprj.vo.PageVO;

@Controller
@RequestMapping("/admin/logAccess")
public class LogAccessController {
	@Autowired
	private LogAccessDao logAccessDao;
	
	@RequestMapping("/list")
	public String list(Model model, @ModelAttribute PageVO pageVO) {
		int count = logAccessDao.count(pageVO);
		pageVO.setCount(count);//데이터 개수 설정
		model.addAttribute("pageVO", pageVO);
		
		List<LogAccessDto> logAccessList = logAccessDao.selectList(pageVO);
		model.addAttribute("logAccessList", logAccessList);
		
		return "admin/logAccess/list";
		
	};
}
