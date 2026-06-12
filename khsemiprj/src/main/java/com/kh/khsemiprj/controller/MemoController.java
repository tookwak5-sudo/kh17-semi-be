package com.kh.khsemiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.khsemiprj.dao.MemoDao;
import com.kh.khsemiprj.dto.MemoDto;
import com.kh.khsemiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/memo")
public class MemoController {
	@Autowired
	private MemoDao memoDao;
	
	@GetMapping("/list")
	public String list(HttpSession session, Model model, @ModelAttribute PageVO pageVO) {
		String receiverId = (String) session.getAttribute("loginId");
		
		int count = memoDao.count(receiverId, pageVO);
		pageVO.setCount(count);
		
		List<MemoDto> list = memoDao.selectList(receiverId, pageVO);
		
		model.addAttribute("list", list);
		
		return "memo/list";
	}
}
