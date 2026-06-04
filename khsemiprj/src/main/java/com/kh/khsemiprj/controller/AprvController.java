package com.kh.khsemiprj.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/aprv")
@Controller
public class AprvController {
	@RequestMapping("/list")
	public String list() {
		
		return "aprv/list";
	}
	
	@GetMapping("/insert")
	public String insert() {
		return "aprv/insert";
	}
}
