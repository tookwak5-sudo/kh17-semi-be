package com.kh.khsemiprj.restcontroller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.khsemiprj.dao.BoardDao;
import com.kh.khsemiprj.dao.ReplyDao;
import com.kh.khsemiprj.dto.BoardDto;
import com.kh.khsemiprj.dto.ReplyDto;
import com.kh.khsemiprj.vo.ReplyVO;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/rest/reply")
public class ReplyRestController {
	@Autowired
	private ReplyDao replyDao;
	@Autowired
	private BoardDao boardDao;
	
	@PostMapping("/write")
	public void write(@ModelAttribute ReplyDto replyDto, HttpSession session) {
		long replyNo=replyDao.sequence();
		String loginId=(String)session.getAttribute("loginId");
		
		replyDto.setReplyNo(replyNo);
		replyDto.setReplyWriter(loginId);
		
		replyDao.insert(replyDto);
		//댓글갯수 업데이트
		boardDao.updateBoardReplycount(replyDto.getReplyOrigin());
	}
	
	@PostMapping("/list")
	public List<ReplyVO> list(@RequestParam long replyOrigin, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");//null일 수 있음
		BoardDto boardDto = boardDao.selectOne(replyOrigin);//게시글 정보 조회
		
		List<ReplyDto> list = replyDao.selectList(replyOrigin);//댓글 목록 조회
		List<ReplyVO> newList = new ArrayList<>();//옮겨담을 list 생성
		for(ReplyDto replyDto : list) {
			boolean writer = boardDto.getBoardWriter() != null
					&& boardDto.getBoardWriter().equals(replyDto.getReplyWriter());
			boolean owner = loginId != null && loginId.equals(replyDto.getReplyWriter());
			
			newList.add(ReplyVO.builder()
						.replyNo(replyDto.getReplyNo())//번호를 옮겨담는다
						.replyWriter(replyDto.getReplyWriter())//작성자를 옮겨담는다
						.replyContent(replyDto.getReplyContent())//내용을 옮겨담는다
						.replyOrigin(replyDto.getReplyOrigin())//소속글번호를 옮겨담는다
						.replyWtime(replyDto.getReplyWtime())//작성일을 옮겨담는다
						.replyEtime(replyDto.getReplyEtime())//수정일을 옮겨담는다
						.writer(writer)//작성자 여부를 계산해서 넣는다
						.owner(owner)//소유자 여부를 계산해서 넣는다
					.build());
		}
		
		return newList;
	}
	
	//댓글 삭제
	@PostMapping("/delete")
	public void delete(@RequestParam long replyNo) {
		//댓글 삭제 전 어디 글에 있던 댓글인지 확인
		ReplyDto replyDto=replyDao.selectOne(replyNo);
		long boardNo = replyDto.getReplyOrigin();

		replyDao.delete(replyNo);
		//댓글갯수 업데이트
		boardDao.updateBoardReplycount(boardNo);
	}
	
	//댓글 수정
	@PostMapping("/edit")
	public void edit(@ModelAttribute ReplyDto replyDto) {
		replyDao.update(replyDto);
	}
}
