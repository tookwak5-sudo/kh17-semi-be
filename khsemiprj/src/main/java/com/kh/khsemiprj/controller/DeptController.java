package com.kh.khsemiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.khsemiprj.dao.DeptDao;
import com.kh.khsemiprj.dto.DeptDto;

@Controller
@RequestMapping("/dept")
public class DeptController {
	
	@Autowired
	private DeptDao deptDao;
	
	@RequestMapping("/list")
	public String list() {
		return "dept/list";
	}
	
	@GetMapping("/insert")
	public String insert() {
		
		return "dept/insert";
	}
	
	@RequestMapping("/chart")
	public String chart(Model model) {
 		List<DeptDto> list = deptDao.selectListAll();
 		model.addAttribute("list", list);
		
		return "dept/chart";
	}
}
