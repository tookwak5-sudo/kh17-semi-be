package com.kh.khsemiprj.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.khsemiprj.dao.AttachDao;
import com.kh.khsemiprj.dto.AttachDto;
import com.kh.khsemiprj.exception.TargetNotfoundException;

import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/download")
public class FileDownloadController {
	@Autowired
	private AttachDao attachDao;
	
	//레거시 다운로드 - Java EE의 객체들을 이용하여 다운로드를 설정
	@RequestMapping("/legacy")
	public void legacy(@RequestParam int attachNo, HttpServletResponse response) throws IOException {
		//목표 : 전달된 attachNo에 해당하는 정보를 불러와서 파일과 조합하여 사용자에게 전송
		
		//[1] 정보 조회
		AttachDto attachDto = attachDao.selectOne(attachNo);
		if(attachDto == null) throw new TargetNotfoundException("존재하지 않는 파일");
		
		//[2] 파일 조회
		File dir = new File("D:/upload");//파일이 모여있는 폴더
		File target = new File(dir, String.valueOf(attachNo));//다운로드 시킬 파일
		if(!target.isFile()) throw new TargetNotfoundException("존재하지 않는 파일");
		
		//[3] 사용자에게 알려줄 다운로드 정보(헤더) 설정 (무조건 String만 설정 가능)
		response.setHeader("Content-Encoding", "UTF-8");//내가 보낼 데이터의 표현방식
		response.setHeader("Content-Type", attachDto.getAttachTypeString());//파일유형
		response.setHeader("Content-Length", String.valueOf(attachDto.getAttachSize()));//파일크기
		
		StringBuffer sb = new StringBuffer();
		sb.append("attachment");
		sb.append(";");
		sb.append("filename=");
		sb.append("\"");
		//sb.append(attachDto.getAttachName());
		sb.append(URLEncoder.encode(attachDto.getAttachName(), "UTF-8"));
		sb.append("\"");
		response.setHeader("Content-Disposition", sb.toString());//파일명+행동지침
		
		//[4] 실제 파일을 불러와서 사용자에게 전송
		FileInputStream stream = new FileInputStream(target);
		byte[] buffer = new byte[1024];
		
		while(true) {
			int size = stream.read(buffer);//읽어!
			if(size == -1) break;//EOF면 나가!
			response.getOutputStream().write(buffer, 0, size);//내보내!
		}
		
		stream.close();
	}
	
	//스프링이 제공하는 시스템을 이용해서 파일 다운로드 처리
	//- 스프링은 HttpServletRequest, HttpServletResponse와 같은 Java EE 객체를 사용하는걸 싫어한다
	//- Controller는 문자열을 반환하면 이것을 화면의 경로라고 생각한다
	//- 파일 다운로드는 화면을 반환하는 것이 아니기 때문에 ResponseEntity라는 형태를 반환하도록 설계되어 있다
	@RequestMapping("/modern")
	public ResponseEntity<ByteArrayResource> modern(@RequestParam int attachNo) throws IOException {
		//[1] 정보 조회
		AttachDto attachDto = attachDao.selectOne(attachNo);
		if(attachDto == null) throw new TargetNotfoundException("존재하지 않는 파일");
		
		//[2] 파일 조회
		File dir = new File("D:/upload");//파일이 모여있는 폴더
		File target = new File(dir, String.valueOf(attachNo));//다운로드 시킬 파일
		if(!target.isFile()) throw new TargetNotfoundException("존재하지 않는 파일");
		
		//[3] 사용자에게 알려줄 다운로드 정보(헤더) 설정 (무조건 String만 설정 가능)
		//[4] 실제 파일을 불러와서 사용자에게 전송
		byte[] data = FileCopyUtils.copyToByteArray(target);//파일 내용을 읽어와서
		ByteArrayResource resource = new ByteArrayResource(data);//스프링이 원하는 형태로 포장
		
		//전통적인 자바방식
		//ResponseEntity entity = new ResponseEntity(resource, 헤더, 상태);
		//return entity;
		
		//모던 방식
		return ResponseEntity.ok()
				.contentLength(attachDto.getAttachSize())
				.header(HttpHeaders.CONTENT_TYPE, attachDto.getAttachTypeString())
				//.contentType(MediaType.APPLICATION_OCTET_STREAM)	
				.header(HttpHeaders.CONTENT_ENCODING, "UTF-8")
				.header(HttpHeaders.CONTENT_DISPOSITION, 
					ContentDisposition
						.attachment()
						.filename(attachDto.getAttachName(), StandardCharsets.UTF_8)
						.build().toString()
				)
			.body(resource);
	}
}	
	