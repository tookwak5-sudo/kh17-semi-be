package com.kh.khsemiprj.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.khsemiprj.dao.MemoDao;
import com.kh.khsemiprj.dto.MemoDto;
import com.kh.khsemiprj.exception.TargetNotfoundException;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/memo")
public class MemoController {
	@Autowired
	private MemoDao memoDao;
	
	//등록 매핑
	@GetMapping("/write")
	public String write() {
		return "memo/write";
	}
	@PostMapping("/write")
	public String write(@ModelAttribute MemoDto memoDto, HttpSession session) {
		int memoNo = memoDao.sequence();
		System.out.println(memoNo);
		//로그인 여부 확인
		String loginId = (String)session.getAttribute("loginId");
		if (loginId == null) {
			return "redirect:/login"; // 세션이 만료된 경우 방어 코드
		}
		//보낸 사람 세션을 통해 넣어주기
		memoDto.setMemoNo(memoNo);
		memoDto.setMemoSenderId(loginId);
		
		memoDao.insert(memoDto);
		return "redirect:./writeComplete";
	}
	
	@GetMapping("/writeComplete")
	public String insertComplete() {
		return "memo/writeComplete";
	}
	
	//상세조회
	@RequestMapping("/detail")
	public String detail(@RequestParam int memoNo, Model model) {
		MemoDto memoDto = memoDao.selectOne(memoNo);
		if(memoDto == null) {
			throw new TargetNotfoundException("존재하지 않는 쪽지입니다");
		}
		model.addAttribute("memoDto",memoDto);
		
		return "memo/detail";
	}
	
	
}
