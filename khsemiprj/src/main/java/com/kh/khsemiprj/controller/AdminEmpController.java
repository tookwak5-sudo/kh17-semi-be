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
import com.kh.khsemiprj.dao.EmpExitDao;
import com.kh.khsemiprj.dao.EmpLeaveDao;
import com.kh.khsemiprj.dao.EmpPositionDao;
import com.kh.khsemiprj.dao.EmpPositionDeptDao;
import com.kh.khsemiprj.dto.DeptDto;
import com.kh.khsemiprj.dto.EmpDto;
import com.kh.khsemiprj.dto.EmpPositionDeptDto;
import com.kh.khsemiprj.dto.EmpPositionDto;
import com.kh.khsemiprj.vo.EmpExitVO;
import com.kh.khsemiprj.vo.PageVO;

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
	@Autowired
	private EmpLeaveDao empLeaveDao;
	@Autowired
	private EmpExitDao empExitDao;
	
	@RequestMapping("/list")
	public String list(Model model, @ModelAttribute PageVO pageVO) {
		
		int count = empPositionDeptDao.count(pageVO);
		pageVO.setCount(count);
		model.addAttribute("pageVO", pageVO);
		
		List<EmpPositionDeptDto> list = empPositionDeptDao.selectList(pageVO);
		model.addAttribute("list", list);
		
		List<EmpDto> wList = empDao.selectEmpByStatus(null);
		model.addAttribute("wList", wList);
		
		//
		
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
	
//	@PostMapping("/detail")
//	public String detail(@ModelAttribute EmpPositionDeptDto empPositionDeptDto) {
//		empPositionDeptDao.updateByMaster(empPositionDeptDto);
//		
//		return "redirect:detail?empId=" + empPositionDeptDto.getEmpId();
//	}
	
	@PostMapping("/edit")
	public String edit(@ModelAttribute EmpDto empDto, @RequestParam Integer empPositionNo) {
		
		empDao.updateByAdmin(empDto, empPositionNo);
		
		return "redirect:detail?empId=" + empDto.getEmpId();
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
		
		//1.사원의 승인정보 업데이트
		empDao.approveEmp(empId, empHireDate, empPositionNo);
		//2. 부서 관계 테이블 등록
		empDeptRelationDao.insertEmpDept(empId, deptNo);
		//3. 휴가 테이블 등록
		empLeaveDao.insert(empId);
		
		return "redirect:/admin/emp/list?alarm=empApprove";
	}
	

	// 퇴사자 목록
	@RequestMapping("/exitList")
	public String exitList(@ModelAttribute PageVO pageVO, Model model) {
	   
	    int count = empExitDao.count(pageVO);
	    pageVO.setCount(count);
	    model.addAttribute("pageVO", pageVO);

	  
	    List<EmpExitVO> exitList = empExitDao.selectList(pageVO);
	    model.addAttribute("exitList", exitList);
	    
	    return "/admin/emp/exitList";
	}
}
