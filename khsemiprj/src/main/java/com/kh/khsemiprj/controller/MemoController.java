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
import com.kh.khsemiprj.exception.GetOutException;
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
		//로그인 여부 확인
		String loginId = (String)session.getAttribute("loginId");
		if (loginId == null) {
			return "redirect:/login"; // 세션이 만료된 경우 방어 코드
		}
		//보낸 사람 세션을 통해 넣어주기
		memoDto.setMemoNo(memoNo);
		memoDto.setMemoSenderId(loginId);
		
		if(memoDto.getMemoType().equals("공지")) {
			memoDao.insertAll(memoDto);
		} else {
			memoDao.insert(memoDto);	
		}
		return "redirect:./list?send";
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
		
		if(!loginId.equals(memoDto.getMemoReceiverId())) {
			throw new GetOutException("나에게 온 쪽지만 확인 할 수 있습니다."); 
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
	
	@PostMapping("/countMemo")
	public String list(HttpSession session, Model model) {
		String receiverId = (String) session.getAttribute("loginId");
		
		int countMemo = memoDao.memoCount(receiverId);
		
		model.addAttribute("countMemo", countMemo);
		
		return "template/header";
	}
	
	@RequestMapping("/delete")
	public String delete(HttpSession session, @RequestParam int memoNo) {
		String loginId = (String) session.getAttribute("loginId");
		MemoDto memoDto = memoDao.selectOne(memoNo);
		
		if(memoDto == null) throw new TargetNotfoundException("존재하지 않는 메모");
		
		if(!loginId.equals(memoDto.getMemoReceiverId())) {
			throw new GetOutException("나에게 온 쪽지만 삭제 할 수 있습니다."); 
		}
		
		memoDao.delete(memoNo);
		return "redirect:./list?delete";
	}
	
	@RequestMapping("/writeDelete")
	public String writeDelete(HttpSession session) {
		String receiverId = (String) session.getAttribute("loginId");	
			
		memoDao.writeDelete(receiverId);
		return "redirect:./list?delete";	
	}
	
}
