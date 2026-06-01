package com.kh.khsemiprj.service;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.kh.khsemiprj.dao.AttachDao;
import com.kh.khsemiprj.dto.AttachDto;
import com.kh.khsemiprj.exception.TargetNotfoundException;

@Service
public class AttachService {
	@Autowired
	private AttachDao attachDao;
	
	//서비스는 메소드의 정해진 형태가 없다
		public int save(MultipartFile attach) throws IllegalStateException, IOException{
			//파일 업로드는 2단계로 진행된다 (DB와 실물파일 처리)	
					int attachNo = attachDao.sequence();//파일 번호 생성
					AttachDto attachDto = new AttachDto();//DB에 저장하기 위한 객체 생성
					attachDto.setAttachNo(attachNo);//번호 설정
					attachDto.setAttachName(attach.getOriginalFilename());//업로드된 파일명 설정
					attachDto.setAttachType(attach.getContentType());//파일 유형 설정
					attachDto.setAttachSize(attach.getSize());//파일 크기 설정
					attachDao.insert(attachDto);//DB 등록 요청
					
					
					
					//업로드된 파일을 저장하는 코드 
					File dir = new File("D:/upload");
					dir.mkdirs();
					File target = new File(dir, String.valueOf(attachNo));//시퀀스 번호로 실제 저장
					attach.transferTo(target);
					
					return attachNo;
		}
		
		//번호에 해당하는 파일을 지우고 DB정보도 삭제하도록 처리
		public void delete(int attachNo) {
			//정보가 있는지 먼저 확인
			AttachDto attachDto = attachDao.selectOne(attachNo);
			if(attachDto == null) throw new TargetNotfoundException("존재하지 않는 파일");
			
			attachDao.delete(attachNo);//DB 데이터 삭제
			
			File dir = new File("D:/upload");
			File target = new File(dir, String.valueOf(attachNo));//지워야 할 파일 객체 생성
			target.delete();//파일 삭제 지시
		}

}
