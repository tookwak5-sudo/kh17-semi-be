package com.kh.khsemiprj.controller;

import java.util.List;

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
import com.kh.khsemiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/memo")
public class MemoController {
	@Autowired
	private MemoDao memoDao;
	
	//등록 매핑
	@GetMapping("/write")
	public String write(@RequestParam(required = false) String memoSenderId, // 주소창 파라미터 수집
			HttpSession session, 
			Model model) {
		// 로그인 여부 확인
		String loginId = (String)session.getAttribute("loginId");
		if (loginId == null) {
			return "redirect:/login"; 
		}
		
		// 답변하기로 넘어와서 상대방 ID가 존재한다면 화면(JSP)으로 전달
		if (memoSenderId != null) {
			model.addAttribute("replyReceiverId", memoSenderId);
		}
		
		
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
	public String detail(@RequestParam int memoNo, HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		MemoDto memoDto = memoDao.selectOne(memoNo);
		
		if(memoDto == null) {
			throw new TargetNotfoundException("존재하지 않는 쪽지입니다");
		}
		
		// 로그인한 사람과 쪽지 수신자가 같은 경우에만 읽음 처리
		if(loginId != null && loginId.equals(memoDto.getMemoReceiverId())) {
			memoDao.update(memoNo);
		}
		
		memoDao.update(memoNo);
		
		model.addAttribute("memoDto",memoDto);
		
		return "memo/detail";
	}
	
	//목록
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
