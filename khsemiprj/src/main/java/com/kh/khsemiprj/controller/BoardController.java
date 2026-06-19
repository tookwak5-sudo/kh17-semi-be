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

import com.kh.khsemiprj.dao.BoardDao;
import com.kh.khsemiprj.dto.BoardDto;
import com.kh.khsemiprj.exception.GetOutException;
import com.kh.khsemiprj.exception.TargetNotfoundException;
import com.kh.khsemiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board")
public class BoardController {
	@Autowired
	private BoardDao boardDao;
	
	//목록 및 검색 매핑
	@RequestMapping("/list")
	public String list(Model model, @ModelAttribute PageVO pageVO) {
		//페이징을 위해 추가로 전달할 값이 있다면 전달해야 한다
		int count = boardDao.count(pageVO);
		pageVO.setCount(count);//데이터 개수 설정
		
		//공지사항 게시글
		//List<BoardDto> noticeList = boardDao.selectList("board_head", "공지");
		List<BoardDto> noticeList = boardDao.selectNoticeList();
		model.addAttribute("noticeList", noticeList);
		//일반 게시글 (공지사항도 포함되어 있음)
		List<BoardDto> boardList = boardDao.selectList(pageVO);
		model.addAttribute("boardList", boardList);
		
		//게시글 범주안에 공지가 포함 되어 있어서 공지 글을 올릴시 공지가 같은 번호로 두개가 올라가는 현상이 생겨서 수정했습니다.
		model.addAttribute("noticeCount", noticeList.size());//공지사항 개수 전달
		
		model.addAttribute("pageVO", pageVO);
		return "board/list";
	}
	
	
	//상세 매핑
	@RequestMapping("/detail")
	public String detail(@RequestParam long boardNo, Model model, @ModelAttribute PageVO pageVO) {
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if(boardDto == null) throw new TargetNotfoundException("존재하지 않는 게시글");
		model.addAttribute("boardDto", boardDto);
		
		//이전글과 다음글을 조회하여 첨부
//		model.addAttribute("prevBoardDto", boardDao.selectPreviousOne(boardNo));
//		model.addAttribute("nextBoardDto", boardDao.selectNextOne(boardNo));
		if(pageVO.isList()) {
			model.addAttribute("prevBoardDto", boardDao.selectPreviousOne(boardNo));
			model.addAttribute("nextBoardDto", boardDao.selectNextOne(boardNo));
		} else {
			model.addAttribute("prevBoardDto", boardDao.selectPreviousOne(boardNo,pageVO));
			model.addAttribute("nextBoardDto", boardDao.selectNextOne(boardNo,pageVO));
		}
		
		return "board/detail";
	}
	
	//등록 매핑
	@GetMapping("/write")
	public String write() {
		return "board/write";
	}
	@PostMapping("/write")
	public String write(@ModelAttribute BoardDto boardDto, HttpSession session) {
//		//작성자 아이디 추출
		String loginId = (String)session.getAttribute("loginId");
//		
		//작성한 글이 "공지"라면 관리자인지를 반드시 확인
		if(boardDto.getBoardHead() != null && boardDto.getBoardHead().equals("공지")) {
			Integer empGrade = (Integer)session.getAttribute("empGrade");
			if(empGrade==0) {//empGrade이 0이라면 (관리자가 아니라면)
				throw new GetOutException();
			}
		}
		
		// 글 번호 생성
		long boardNo = boardDao.sequence();
		boardDto.setBoardNo(boardNo);
		boardDto.setBoardWriter(loginId);
		
		boardDao.insert(boardDto);
		// 상세페이지로 리다이렉트
		return "redirect:/board/detail?boardNo="+boardNo;
	}
	
	//삭제 매핑
	@RequestMapping("/delete")
	public String delete(@RequestParam long boardNo, HttpSession session) {
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if(boardDto == null) throw new TargetNotfoundException("존재하지 않는 게시글");
		String loginId = (String)session.getAttribute("loginId");
		Integer empGrade = (Integer)session.getAttribute("empGrade");
		if(!boardDto.getBoardWriter().equals(loginId) 
			&& empGrade==0) {
			throw new GetOutException("삭제 권한이 없습니다");
		}
		boardDao.delete(boardNo);
		return "redirect:./list";
	}
	
	//수정 매핑
	@GetMapping("/edit")
	public String edit(@RequestParam long boardNo, Model model, HttpSession session) {
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if(boardDto == null) throw new TargetNotfoundException("존재하지 않는 게시글");
		String loginId = (String)session.getAttribute("loginId");
		if(!boardDto.getBoardWriter().equals(loginId)) {
			throw new GetOutException("작성자만 수정할 수 있습니다");
		}
		
		model.addAttribute("boardDto", boardDto);
		return "board/edit";
	}
	@PostMapping("/edit")
	public String edit(@ModelAttribute BoardDto boardDto, HttpSession session) {
		//작성한 글이 "공지"라면 관리자인지를 반드시 확인
		if(boardDto.getBoardHead() != null && boardDto.getBoardHead().equals("공지")) {
//			String loginLevel = (String)session.getAttribute("loginLevel");
			//로그인 할 때 직급은 positionLevel로 session에 저장, 관리자 단계는 loginLevel로 session에 저장
			/*
			 * if(loginLevel.equals("0")) {//loginLevel이 0이라면 (관리자가 아니라면)
			 * throw new GetOutException();
			 * }
			 */
		}
		
		BoardDto findBoardDto = boardDao.selectOne(boardDto.getBoardNo());
		if(findBoardDto == null) throw new TargetNotfoundException("존재하지 않는 게시글");
		
		boardDao.update(boardDto);
		return "redirect:./detail?boardNo="+boardDto.getBoardNo();
	}
}

