	package com.kh.khsemiprj.service;
	
	import java.io.IOException;
	
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	import org.springframework.web.multipart.MultipartFile;
	
	import com.kh.khsemiprj.dao.AprvFormDao;
	import com.kh.khsemiprj.dao.AttachDao;
	import com.kh.khsemiprj.dto.AprvFormDto;
	import com.kh.khsemiprj.dto.AttachDto;
	import com.kh.khsemiprj.exception.TargetNotfoundException;
	
	import com.kh.khsemiprj.vo.AprvFormVO;
	
	@Service
	public class AprvFormService {
	
		@Autowired
		private AprvFormDao aprvFormDao;
		@Autowired
		private AttachDao attachDao;
		@Autowired
		private AttachService attachService;
	
		public void registerFormFile(AprvFormDto aprvFormDto, MultipartFile attach)
				throws IllegalStateException, IOException {
			
			// DAO의 원래 insertForm 호출
			AprvFormVO aprvFormVo = aprvFormDao.insertForm(aprvFormDto);

			int formNo = aprvFormVo.getFormNo();
			if (attach != null && !attach.isEmpty()) {
				int attachNo = attachService.save(attach);
				aprvFormDao.connect(formNo, attachNo);
			}
		}
		public void modifyFile(AprvFormDto aprvFormDto, AttachDto attachDto, MultipartFile attach)
				throws IllegalStateException, IOException {
			
			int formChecker = aprvFormDto.getFormNo();
			AprvFormDto findAprvFormDto = aprvFormDao.selectOne(formChecker);

			
			if (findAprvFormDto == null) {
				throw new TargetNotfoundException("해당 양식이 존재하지 않습니다.");
			}

			//1. 새로운 파일이 진짜로 들어왔을 때만 아래 로직
			if (attach != null && !attach.isEmpty()) {
				
				int fileChecker = attachDto.getAttachNo();
				
				// 2. 기존 첨부파일 번호가 유효하게 넘어왔을 때만 삭제 로직 진행 (없으면 0이 들어옴)
				if (fileChecker > 0) {
					AttachDto findAttachDto = attachDao.selectOne(fileChecker);
					// DB에 진짜로 기존 파일 정보가 존재하면 연결 끊고 파일 삭제
					if (findAttachDto != null) {
						aprvFormDao.disconnect(formChecker, fileChecker);
						attachService.delete(fileChecker);
					}
				}

				// 3. 기존 파일이 있었든 없었든 간에, 새 파일은 무조건 저장하고 양식에 연결함
				int newAttachNo = attachService.save(attach);
				aprvFormDao.connect(formChecker, newAttachNo);
			}
		}
	
		public void deleteFile(AprvFormDto aprvFormDto, Integer attachNo)
				throws IllegalStateException, IOException {
			int formNo = aprvFormDto.getFormNo();
			AttachDto attachDto = new AttachDto();
			attachNo = aprvFormDao.findAttachNo(formNo);
			
			attachDto.setAttachNo(attachNo);
			
			aprvFormDao.disconnect(formNo, attachNo);
	
			attachService.delete(attachNo);
		}
	
	}