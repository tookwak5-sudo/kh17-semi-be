package com.kh.khsemiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.khsemiprj.dao.AprvHeadDao;
import com.kh.khsemiprj.dto.AprvHeadDto;
import com.kh.khsemiprj.vo.PageVO;

@Controller
@RequestMapping("/aprvHead")
public class AprvHeadController {
	
	@Autowired
	private AprvHeadDao aprvHeadDao;
	
	
	
}
