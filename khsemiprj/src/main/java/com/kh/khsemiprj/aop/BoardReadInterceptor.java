package com.kh.khsemiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.khsemiprj.dao.BoardDao;
import com.kh.khsemiprj.dao.BoardReadDao;
import com.kh.khsemiprj.dto.BoardDto;
import com.kh.khsemiprj.exception.TargetNotfoundException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
//목표 :
//- 데이터베이스(DBMS)를 이용해서 조회 이력을 저장하고 조회수 중복 증가를 차단
//- 아이디를 기반으로 하기 때문에 세션이 달라도 차단이 가능
@Service
public class BoardReadInterceptor implements HandlerInterceptor{
	@Autowired
	private BoardDao boardDao;
	
	@Autowired
	private BoardReadDao boardReadDao;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		//파라미터에 있는 boardNo를 찾아서 해당글의 조회수를 증가
		
		//[1] boardNo가 없는 경우 제거
		String boardNoStr = request.getParameter("boardNo");
		if(boardNoStr == null) {
			throw new TargetNotfoundException("존재하지 않는 게시글");
		}
		
		//[2] boardNo가 유효하지 않은 번호인 경우 제거
		long boardNo = Long.parseLong(boardNoStr);
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if(boardDto == null) {
			throw new TargetNotfoundException("존재하지 않는 게시글");
		}
		
//		//[3] 비회원인 경우 제거
		HttpSession session = request.getSession();
		String loginId = (String)session.getAttribute("loginId");
		if(loginId == null) {
			return true;
		}
		
		//[4] DB에 조회이력이 있으면 제거
		long count = boardReadDao.count(loginId, boardNo);
		if(count > 0 ) {//기록이 1개 이상이라면
			return true;//지나가세요!
		}

		//[5] DB에 조회이력을 생성
		boardReadDao.insert(loginId, boardNo);
		
		
		//[6] 조회수 증가 처리
		boardDao.updateBoardReadcount(boardNo);		
		//조회수가 올라가든 안올라가든 무조건 통과
		return true;
	}
}