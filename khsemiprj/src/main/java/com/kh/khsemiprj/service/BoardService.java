	package com.kh.khsemiprj.service;
	
	import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.kh.khsemiprj.dao.AttachDao;
import com.kh.khsemiprj.dao.BoardDao;
import com.kh.khsemiprj.dto.AttachDto;
import com.kh.khsemiprj.dto.BoardDto;
import com.kh.khsemiprj.exception.TargetNotfoundException;
	
	@Service
	@Transactional
	public class BoardService {
	
		@Autowired
		private BoardDao boardDao;
		@Autowired
		private AttachDao attachDao;
		@Autowired
		private AttachService attachService;
	
		public void registerFormFile(BoardDto boardDto, MultipartFile attach)
				throws IllegalStateException, IOException {
			
			// 1. 게시글 번호 생성 및 게시글 DB 등록
		    long boardNo = boardDao.sequence(); 
		    boardDto.setBoardNo(boardNo);
		    boardDao.insert(boardDto); 

		    // 2. 첨부파일이 있다면 저장하고 매핑
		    if (attach != null && !attach.isEmpty()) {
		        int attachNo = attachService.save(attach);
		        boardDao.connect(boardNo, attachNo);
		    }
		}
		public void modifyFile(BoardDto boardDto, AttachDto attachDto, MultipartFile attach)
				throws IllegalStateException, IOException {
			
			long formChecker = boardDto.getBoardNo();
			BoardDto findBoardDto = boardDao.selectOne(formChecker);

			
			if (findBoardDto == null) {
				throw new TargetNotfoundException("해당 게시글이 존재하지 않습니다.");
			}

			//1. 새로운 파일이 진짜로 들어왔을 때만 아래 로직
			if (attach != null && !attach.isEmpty()) {
				
				int fileChecker = attachDto.getAttachNo();
				
				// 2. 기존 첨부파일 번호가 유효하게 넘어왔을 때만 삭제 로직 진행 (없으면 0이 들어옴)
				if (fileChecker > 0) {
					AttachDto findAttachDto = attachDao.selectOne(fileChecker);
					// DB에 진짜로 기존 파일 정보가 존재하면 연결 끊고 파일 삭제
					if (findAttachDto != null) {
						boardDao.disconnect(formChecker, fileChecker);
						attachService.delete(fileChecker);
					}
				}

				// 3. 기존 파일이 있었든 없었든 간에, 새 파일은 무조건 저장하고 양식에 연결함
				int newAttachNo = attachService.save(attach);
				boardDao.connect(formChecker, newAttachNo);
			}
		}
	
		public void deleteFile(BoardDto boardDto, Integer attachNo)
				throws IllegalStateException, IOException {
			long boardNo = boardDto.getBoardNo();
			AttachDto attachDto = new AttachDto();
			attachNo = boardDao.findAttachNo(boardNo);
			
			attachDto.setAttachNo(attachNo);
			
			boardDao.disconnect(boardNo, attachNo);
	
			attachService.delete(attachNo);
		}
	
	}