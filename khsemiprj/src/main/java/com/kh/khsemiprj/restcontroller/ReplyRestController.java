package com.kh.khsemiprj.restcontroller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.kh.khsemiprj.dao.BoardDao;
import com.kh.khsemiprj.dao.MemoDao;
import com.kh.khsemiprj.dao.ReplyDao;
import com.kh.khsemiprj.dao.ReplyDislikeDao;
import com.kh.khsemiprj.dao.ReplyLikeDao;
import com.kh.khsemiprj.dto.BoardDto;
import com.kh.khsemiprj.dto.MemoDto;
import com.kh.khsemiprj.dto.ReplyDto;
import com.kh.khsemiprj.service.ReplyService;
import com.kh.khsemiprj.vo.DislikeVO;
import com.kh.khsemiprj.vo.LikeVO;
import com.kh.khsemiprj.vo.ReplyVO;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/rest/reply")
public class ReplyRestController {
	@Autowired
	private ReplyDao replyDao;
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private ReplyLikeDao replyLikeDao;
	@Autowired
	private ReplyDislikeDao replyDislikeDao;
	@Autowired
    private ReplyService replyService;
	@Autowired
	private MemoDao memoDao;
	
	//좋아요 싫어요 토글 영역
	@PostMapping("/like-check")
	public LikeVO likeCheck(@RequestParam long replyNo, HttpSession session) {
		String loginId=(String)session.getAttribute("loginId");
		
		boolean action=replyLikeDao.check(loginId, replyNo);
		long count=replyLikeDao.count(replyNo);
		
		return LikeVO.builder().action(action).count(count).build();
	}
	
	@PostMapping("/dislike-check")
	public DislikeVO dislikeCheck(@RequestParam long replyNo, HttpSession session) {
		String loginId=(String)session.getAttribute("loginId");
		
		boolean action=replyDislikeDao.check(loginId, replyNo);
		long count=replyDislikeDao.count(replyNo);
		
		return DislikeVO.builder().action(action).count(count).build();
	}
	
	@PostMapping("/like-action")
	public LikeVO likeAction(@RequestParam long replyNo, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
		
		boolean current = replyLikeDao.check(loginId, replyNo);
		if(current) {//좋아요 설정한 적이 있으면
			replyLikeDao.delete(loginId, replyNo);//좋아요 해제
		}
		else {
			replyLikeDao.insert(loginId, replyNo);//좋아요 설정
		}
		
		long count = replyLikeDao.count(replyNo);
		
		replyDao.updateReplyLikecount(replyNo);
		
		return LikeVO.builder().action(!current).count(count).build();
	}
	
	@PostMapping("/dislike-action")
	public DislikeVO dislikeAction(@RequestParam long replyNo, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
		
		boolean current = replyDislikeDao.check(loginId, replyNo);
		if(current) {//싫어요 설정한 적이 있으면
			replyDislikeDao.delete(loginId, replyNo);//싫어요 해제
		}
		else {
			replyDislikeDao.insert(loginId, replyNo);//싫어요 설정
		}
		
		long count = replyDislikeDao.count(replyNo);
		
		replyDao.updateReplyDislikecount(replyNo);
		
		return DislikeVO.builder().action(!current).count(count).build();
	}
	
	//댓글작성 영역
	@PostMapping("/write")
    public void write(@ModelAttribute ReplyDto replyDto, 
                      @RequestParam(required = false) MultipartFile replyImage, 
                      HttpSession session) throws Exception {
        
		String loginId = (String) session.getAttribute("loginId");
        replyDto.setReplyWriter(loginId);
		
        replyService.writeReply(replyDto, replyImage);
		boardDao.updateBoardReplycount(replyDto.getReplyOrigin());
		
		BoardDto targetBoard=boardDao.selectOne(replyDto.getReplyOrigin());
		// 댓글이 달리면 게시글 작성자에게 쪽지 발송(내 게시글이면 제외)
		if (targetBoard.getBoardWriter() != null 
			&& replyDto.getReplyParent() == null 
			&& !targetBoard.getBoardWriter().equals(loginId)) {
			String safeTitle = replyService.truncate(targetBoard.getBoardTitle(), 15);
			MemoDto memoDto = 
				MemoDto.builder()
					.memoNo(memoDao.sequence())
					.memoReceiverId(targetBoard.getBoardWriter())
					.memoSenderId("system")
					.memoTitle("신규 댓글 알림 - [" + targetBoard.getBoardHead() + "] " + safeTitle)
					.memoContent("<a href='/board/detail?boardNo=" + targetBoard.getBoardNo()+"' class='btn btn-positive' target='_blank'>댓글 확인</a>")
					.memoReadStatus("N")
					.memoType("일반")
				.build();
			memoDao.insert(memoDto);
		}
		// 대댓글이 달리면 댓글 작성자에게 쪽지 발송(내 댓글이면 제외)
		if (replyDto.getReplyWriter() != null && replyDto.getReplyParent() != null 
				&& !replyDao.selectOne(replyDto.getReplyParent()).getReplyWriter().equals(loginId)) {
			ReplyDto parentReply = replyDao.selectOne(replyDto.getReplyParent());
			String receiverId = parentReply.getReplyWriter();
			String safeTitle = replyService.truncate(replyDto.getReplyContent(), 15);
			MemoDto memoDto = 
				MemoDto.builder()
					.memoNo(memoDao.sequence())
					.memoReceiverId(receiverId)
					.memoSenderId("system")
					.memoTitle("신규 대댓글 알림 - [" + safeTitle + "]")
					.memoContent("<a href='/board/detail?boardNo=" + targetBoard.getBoardNo()+ "' class='btn btn-positive' target='_blank'>대댓글 확인</a>")
					.memoReadStatus("N")
					.memoType("일반")
				.build();
			memoDao.insert(memoDto);
		}
    }
	
	@PostMapping("/list")
	public List<ReplyVO> list(@RequestParam long replyOrigin, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");//null일 수 있음
		BoardDto boardDto = boardDao.selectOne(replyOrigin);//게시글 정보 조회
		
		List<ReplyVO> list = replyDao.selectList(replyOrigin, loginId);//댓글 목록 조회
//		List<ReplyVO> newList = new ArrayList<>();//옮겨담을 list 생성
		for(ReplyVO replyVO : list) {
			boolean writer = boardDto.getBoardWriter() != null
					&& boardDto.getBoardWriter().equals(replyVO.getReplyWriter());
			boolean owner = loginId != null && loginId.equals(replyVO.getReplyWriter());
			
			replyVO.setWriter(writer);
			replyVO.setOwner(owner);
			
//			newList.add(ReplyVO.builder()
//						.replyNo(replyVO.getReplyNo())//번호를 옮겨담는다
//						.replyWriter(replyVO.getReplyWriter())//작성자를 옮겨담는다
//						.replyContent(replyVO.getReplyContent())//내용을 옮겨담는다
//						.replyOrigin(replyVO.getReplyOrigin())//소속글번호를 옮겨담는다
//						.replyWtime(replyVO.getReplyWtime())//작성일을 옮겨담는다
//						.replyEtime(replyVO.getReplyEtime())//수정일을 옮겨담는다
//						.replyParent(replyVO.getReplyParent())//소속댓글번호를 옮겨담는다
//						.replyStatus(replyVO.getReplyStatus())//논리적 삭제여부를 옮겨담는다
//						.replyLikecount(replyVO.getReplyLikecount())//좋아요 갯수를 옮겨담는다
//						.replyDislikecount(replyVO.getReplyDislikecount())//싫어요 갯수를 옮겨담는다
//						.writer(writer)//작성자 여부를 계산해서 넣는다
//						.owner(owner)//소유자 여부를 계산해서 넣는다
//						.empLiked(replyVO.getEmpLiked())
//						.empDisliked(replyVO.getEmpDisliked())
//					.build());
		}
		return list;
	}
	
	//댓글 삭제
	@PostMapping("/delete")
	public void delete(@RequestParam long replyNo) {
		replyService.deleteReply(replyNo);
	}
	
	//댓글 수정
	@PostMapping("/edit")
	public void edit(@ModelAttribute ReplyDto replyDto) {
		replyDao.update(replyDto);
	}
}
