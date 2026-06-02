package com.kh.khsemiprj.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.khsemiprj.dao.BoardDao;
import com.kh.khsemiprj.dao.BoardDislikeDao;
import com.kh.khsemiprj.dao.BoardLikeDao;
import com.kh.khsemiprj.vo.DislikeVO;
import com.kh.khsemiprj.vo.LikeVO;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/rest/board")
public class BoardRestController {
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private BoardLikeDao boardLikeDao;
	@Autowired
	private BoardDislikeDao boardDislikeDao;
	
	@PostMapping("/like-check")
	public LikeVO likeCheck(@RequestParam long boardNo, HttpSession session) {
		String loginId=(String)session.getAttribute("loginId");
		
		boolean action=boardLikeDao.check(loginId, boardNo);
		long count=boardLikeDao.count(boardNo);
		
		return LikeVO.builder().action(action).count(count).build();
	}
	
	@PostMapping("/dislike-check")
	public DislikeVO dislikeCheck(@RequestParam long boardNo, HttpSession session) {
		String loginId=(String)session.getAttribute("loginId");
		
		boolean action=boardDislikeDao.check(loginId, boardNo);
		long count=boardDislikeDao.count(boardNo);
		
		return DislikeVO.builder().action(action).count(count).build();
	}
	
	@PostMapping("/like-action")
	public LikeVO likeAction(@RequestParam long boardNo, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
		
		boolean current = boardLikeDao.check(loginId, boardNo);
		if(current) {//좋아요 설정한 적이 있으면
			boardLikeDao.delete(loginId, boardNo);//좋아요 해제
		}
		else {
			boardLikeDao.insert(loginId, boardNo);//좋아요 설정
		}
		
		long count = boardLikeDao.count(boardNo);
		
		boardDao.updateBoardLikecount(boardNo);
		
		return LikeVO.builder().action(!current).count(count).build();
	}
	
	@PostMapping("/dislike-action")
	public DislikeVO dislikeAction(@RequestParam long boardNo, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
		
		boolean current = boardDislikeDao.check(loginId, boardNo);
		if(current) {//싫어요 설정한 적이 있으면
			boardDislikeDao.delete(loginId, boardNo);//싫어요 해제
		}
		else {
			boardDislikeDao.insert(loginId, boardNo);//싫어요 설정
		}
		
		long count = boardDislikeDao.count(boardNo);
		
		boardDao.updateBoardDislikecount(boardNo);
		
		return DislikeVO.builder().action(!current).count(count).build();
	}
}
