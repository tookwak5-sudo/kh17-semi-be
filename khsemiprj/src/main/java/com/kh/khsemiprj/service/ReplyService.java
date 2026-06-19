package com.kh.khsemiprj.service;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.kh.khsemiprj.dao.AttachDao;
import com.kh.khsemiprj.dao.BoardDao;
import com.kh.khsemiprj.dao.ReplyDao;
import com.kh.khsemiprj.dto.AttachDto;
import com.kh.khsemiprj.dto.ReplyDto;
import com.kh.khsemiprj.exception.TargetNotfoundException;

@Service
@Transactional
public class ReplyService {

	@Autowired
	private ReplyDao replyDao;
	@Autowired
	private AttachDao attachDao;
	@Autowired
	private AttachService attachService;
	@Autowired
	private BoardDao boardDao;

	public void writeReply(ReplyDto replyDto, MultipartFile attach)
			throws IllegalStateException, IOException {

		// 1. 게시글 번호 생성 및 게시글 DB 등록
		long replyNo = replyDao.sequence();
		replyDto.setReplyNo(replyNo);
		replyDao.insert(replyDto);

		// 2. 첨부파일이 있다면 저장하고 매핑
		if (attach != null && !attach.isEmpty()) {
			int attachNo = attachService.save(attach);
			replyDao.connect(replyNo, attachNo);
		}
		// 3. 댓글 갯수 업데이트
//		    boardDao.updateBoardReplycount(replyDto.getReplyOrigin());

	}

	public void modifyFile(ReplyDto replyDto, AttachDto attachDto, MultipartFile attach)
			throws IllegalStateException, IOException {

		long formChecker = replyDto.getReplyNo();
		ReplyDto findReplyDto = replyDao.selectOne(formChecker);

		if (findReplyDto == null) {
			throw new TargetNotfoundException("해당 댓글이 존재하지 않습니다.");
		}

		// 1. 새로운 파일이 진짜로 들어왔을 때만 아래 로직
		if (attach != null && !attach.isEmpty()) {

			int fileChecker = attachDto.getAttachNo();

			// 2. 기존 첨부파일 번호가 유효하게 넘어왔을 때만 삭제 로직 진행 (없으면 0이 들어옴)
			if (fileChecker > 0) {
				AttachDto findAttachDto = attachDao.selectOne(fileChecker);
				// DB에 진짜로 기존 파일 정보가 존재하면 연결 끊고 파일 삭제
				if (findAttachDto != null) {
					replyDao.disconnect(formChecker, fileChecker);
					attachService.delete(fileChecker);
				}
			}

			// 3. 기존 파일이 있었든 없었든 간에, 새 파일은 무조건 저장하고 양식에 연결함
			int newAttachNo = attachService.save(attach);
			replyDao.connect(formChecker, newAttachNo);
		}
	}

	@Transactional
	public void deleteReply(long replyNo) {
		// 댓글 삭제 전 어디 글에 있던 댓글인지 확인
		ReplyDto replyDto = replyDao.selectOne(replyNo);
		long boardNo = replyDto.getReplyOrigin();

		// 상태를 'Y'로 바꾸기 전에 이 댓글에 첨부파일이 있는지 확인
		Integer attachNo = replyDao.findAttachNo(replyNo);

		if (attachNo != null && attachNo > 0) {
			// 매핑 테이블(reply_file)에서 연결을 끊고
			replyDao.disconnect(replyNo, attachNo);
			// 실제 D드라이브 파일과 attach 테이블의 데이터를 날림
			attachService.delete(attachNo);
		}

		// 첨부파일 정리가 끝났으니 댓글의 상태를 업데이트(삭제)합니다.
		replyDao.delete(replyNo);

		// 게시글의 댓글 개수를 갱신
		boardDao.updateBoardReplycount(boardNo);
	}
	// 글자가 너무 길면 잘라주고 '...'을 붙여주는 메서드
	public String truncate(String text, int limit) {
	    if (text == null) return "";
	    if (text.length() > limit) {
	        return text.substring(0, limit) + "...";
	    }
	    return text;
	}
}