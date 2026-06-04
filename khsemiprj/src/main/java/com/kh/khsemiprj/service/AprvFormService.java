package com.kh.khsemiprj.service;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.kh.khsemiprj.dao.AprvFormDao;
import com.kh.khsemiprj.dto.AprvFormDto;

import com.kh.khsemiprj.vo.AprvFormVO;

@Service
public class AprvFormService {

	@Autowired
	private AprvFormDao aprvFormDao;

	@Autowired
	private AttachService attachService; // 강사님이 만든 파일 서비스라고 가정

	public void registerForm(AprvFormDto aprvFormDto, MultipartFile attach) throws IllegalStateException, IOException {
		AprvFormVO aprvFormVo = aprvFormDao.insertForm(aprvFormDto);

		int formNo = aprvFormVo.getFormNo();
		if (attach != null && !attach.isEmpty()) {
			int attachNo = attachService.save(attach);

			aprvFormDao.connect(formNo, attachNo);
		}

	}

}