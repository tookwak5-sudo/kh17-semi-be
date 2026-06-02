package com.kh.khsemiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.khsemiprj.dao.EmpDao;
import com.kh.khsemiprj.dto.EmpDto;

@Controller
@RequestMapping("/admin/emp")
public class AdminEmpController {
	@Autowired
	private EmpDao empDao;
	
	@RequestMapping("/list")
	public String list(Model model, 
			@RequestParam(required = false) String column,
			@RequestParam(required = false) String keyword) {
		List<EmpDto> list = empDao.selectList(column, keyword);
		model.addAttribute("list", list);
		
		return "admin/emp/list"; 
	}

}
