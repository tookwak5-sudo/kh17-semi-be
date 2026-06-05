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

@RestController
@RequestMapping("/rest/aprv")
public class AprvRestController {
	
	@Autowired
	private AprvFormDao aprvFormDao;
	
	@Autowired
	private AttachDao attachDao;
	
	@RequestMapping("/getAprvFormFile")
	public Map<String, Object> getAprvFormFile(@RequestParam int formNo) {
		Map<String, Object> fileMap = new HashMap<>();
		try {
			AprvFormDto findAprvFormDto = aprvFormDao.selectOne(formNo);
			Integer attachNo = aprvFormDao.findAttachNo(formNo);
			
			AttachDto findAttachDto = attachNo == null ? null : attachDao.selectOne(attachNo);
			if (findAprvFormDto == null || findAttachDto == null) {
				fileMap.put("attachNo", "");
				fileMap.put("attachName", "");
				fileMap.put("result", "empty");
			} else {
				fileMap.put("attachNo", findAttachDto.getAttachNo());
				fileMap.put("attachName", findAttachDto.getAttachName());
				fileMap.put("result", "success");
			}
			return fileMap;
		} catch(Exception e) {
			e.printStackTrace();
			fileMap.put("attachNo", "");
			fileMap.put("attachName", "");
			fileMap.put("result", "error");
			
			return fileMap;
		}
	}
}
