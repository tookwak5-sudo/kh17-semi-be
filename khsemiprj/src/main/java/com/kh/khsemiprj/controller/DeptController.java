package com.kh.khsemiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.khsemiprj.dao.DeptDao;
import com.kh.khsemiprj.dao.EmpDao;
import com.kh.khsemiprj.dao.EmpPositionDeptDao;
import com.kh.khsemiprj.dto.DeptDto;
import com.kh.khsemiprj.dto.EmpDto;
import com.kh.khsemiprj.dto.EmpPositionDeptDto;



@Controller
@RequestMapping("/dept")
public class DeptController {
	@Autowired
	private DeptDao deptDao;
	@Autowired
	private EmpPositionDeptDao empPositionDeptDao;
	
	// 부서 정보 등록
	@GetMapping("/insert")
	public String insert(@ModelAttribute DeptDto deptDto, Model model) {
		List<DeptDto> deptList = deptDao.deptList();
		model.addAttribute("deptList", deptList);
		return "dept/insert";
	}
	@PostMapping("/insert")
	public String join(@ModelAttribute DeptDto deptDto, Model model) {
		
		deptDao.insert(deptDto);
		
		return "redirect:./insertComplete";
	}
	
	// 부서 정보 등록 완료
	@RequestMapping("/insertComplete")
	public String insertComplete() {
		return "dept/insertComplete";
	}
 	
	
	// 부서 목록 
	@RequestMapping("/list")
	public String list(Model model, @RequestParam(defaultValue = "0") int deptNo) {
		
		List<EmpPositionDeptDto> empList = empPositionDeptDao.selectDepthEmp(deptNo);
		System.out.println("컨트롤러에서 넘기는 리스트 사이즈: " + (empList == null ? "NULL입니다" : empList.size()));
		model.addAttribute("empList", empList);
		return "dept/list";
	}
	
	@RequestMapping("/chart")
	public String chart() {
		return "dept/chart";
	}
}
