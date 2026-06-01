package com.kh.khsemiprj.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/dept")
public class DeptController {
	
	@RequestMapping("/list")
	public String list() {
		return "dept/list";
	}
	
	@GetMapping("/insert")
	public String insert() {
		
		return "dept/insert";
	}
	
	@RequestMapping("/chart")
	public String chart() {
		return "dept/chart";
	}
}
