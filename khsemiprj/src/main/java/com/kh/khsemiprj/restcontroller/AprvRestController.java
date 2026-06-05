package com.kh.khsemiprj.restcontroller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.khsemiprj.dao.AprvFormDao;
import com.kh.khsemiprj.dao.AttachDao;
import com.kh.khsemiprj.dto.AprvFormDto;
import com.kh.khsemiprj.dto.AttachDto;
import com.kh.khsemiprj.exception.TargetNotfoundException;

@RestController
@RequestMapping("/rest/aprv")
public class AprvRestController {
	
	@Autowired
	private AprvFormDao aprvFormDao;
	
	@Autowired
	private AttachDao attachDao;
	
	@RequestMapping("/")
	public Map<String, String> getAprvFormFile(@RequestParam int formNo) {
		AprvFormDto findAprvFormDto = aprvFormDao.selectOne(formNo);
		Integer attachNo = aprvFormDao.findAttachNo(formNo);

		AttachDto findAttachDto = attachDao.selectOne(attachNo);

		if (findAprvFormDto == null || findAttachDto == null) {
			throw new TargetNotfoundException("파일이나 양식이 존재하지 않습니다.");
		}
		
		Map<String, String> fileMap = new HashMap<>();
		
		return fileMap;
	}
}
