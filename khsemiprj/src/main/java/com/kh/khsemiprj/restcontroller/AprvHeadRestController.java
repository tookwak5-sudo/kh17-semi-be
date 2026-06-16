package com.kh.khsemiprj.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.khsemiprj.dao.AprvHeadDao;
import com.kh.khsemiprj.dto.AprvHeadDto;

@RestController
@RequestMapping("/rest/aprvHead")
public class AprvHeadRestController {
	@Autowired
	private AprvHeadDao aprvHeadDao;
	
	//등록
	@PostMapping("/write")
	public void write(@ModelAttribute AprvHeadDto aprvHeadDto) {
		int headNo = aprvHeadDao.sequence();
		
		aprvHeadDto.setHeadNo(headNo);
		
		aprvHeadDao.insert(aprvHeadDto);
	}
	
	//삭제
	@PostMapping("/delete")
	public void delete(@RequestParam int headNo) {
		aprvHeadDao.delete(headNo);
	}
	
}
