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
	
			int fileChecker = attachDto.getAttachNo();
	
			AttachDto findAttachDto = attachDao.selectOne(fileChecker);
	
			if (findAprvFormDto == null || findAttachDto == null) {
				throw new TargetNotfoundException("파일이나 양식이 존재하지 않습니다.");
			}
	
			
	
			if ( attach != null && !attach.isEmpty()) {
				
				
				aprvFormDao.disconnect(formChecker, fileChecker);
	
				attachService.delete(fileChecker);
	
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