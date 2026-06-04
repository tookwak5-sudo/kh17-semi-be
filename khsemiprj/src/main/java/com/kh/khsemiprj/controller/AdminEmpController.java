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
import com.kh.khsemiprj.dao.EmpDeptRelationDao;
import com.kh.khsemiprj.dao.EmpPositionDao;
import com.kh.khsemiprj.dao.EmpPositionDeptDao;
import com.kh.khsemiprj.dto.DeptDto;
import com.kh.khsemiprj.dto.EmpDto;
import com.kh.khsemiprj.dto.EmpPositionDeptDto;
import com.kh.khsemiprj.dto.EmpPositionDto;

@Controller
@RequestMapping("/admin/emp")
public class AdminEmpController {
	@Autowired
	private EmpPositionDeptDao empPositionDeptDao;
	@Autowired
	private EmpDao empDao;
	@Autowired
	private DeptDao deptDao;
	@Autowired
	private EmpDeptRelationDao empDeptRelationDao;
	@Autowired
	private EmpPositionDao empPositionDao;
	
	@RequestMapping("/list")
	public String list(Model model, 
			@RequestParam(required = false) String column,
			@RequestParam(required = false) String keyword) {
		
		List<EmpPositionDeptDto> list = empPositionDeptDao.selectList(column, keyword);
		model.addAttribute("list", list);
		
		List<EmpDto> wList = empDao.selectEmpByStatus(null);
		model.addAttribute("wList", wList);
		
		List<DeptDto> deptList = deptDao.deptList();
		model.addAttribute("deptList", deptList);
		
		List<EmpPositionDto> positionList = empPositionDao.positionSelectList();
		model.addAttribute("positionList", positionList);
		
		
		return "admin/emp/list"; 
	}
	
	@GetMapping("/detail")
	public String detail(@RequestParam String empId, Model model) {
		
		EmpDto empDto = empDao.selectOne(empId);
		EmpPositionDeptDto empPositionDeptDto = empPositionDeptDao.selectOne(empId);
		model.addAttribute("empDto", empDto);
		model.addAttribute("empPositionDeptDto", empPositionDeptDto);
		
		List<EmpPositionDto> positionList = empPositionDao.positionSelectList();
		model.addAttribute("positionList", positionList);
		
		return "admin/emp/detail";
	}
	
	@PostMapping("/detail")
	public String detail(@ModelAttribute EmpPositionDeptDto empPositionDeptDto) {
		empPositionDeptDao.updateByMaster(empPositionDeptDto);
		
		return "redirect:detail?empId=" + empPositionDeptDto.getEmpId();
	}
	
	@GetMapping("/reject")
	public String reject(@RequestParam String empId) {
		empDao.rejectEmp(empId);
		
		return "redirect:list";
	}
	
	@PostMapping("/approve")
	public String approve(@RequestParam String empId,
						  @RequestParam String empHireDate,
						  @RequestParam int deptNo,
						  @RequestParam int empPositionNo) {
		empDao.approveEmp(empId, empHireDate, empPositionNo);
		empDeptRelationDao.insertEmpDept(empId, deptNo);
		
		return "redirect:list";
	}
}
