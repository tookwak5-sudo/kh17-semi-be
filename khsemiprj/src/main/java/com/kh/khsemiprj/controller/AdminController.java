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

import com.kh.khsemiprj.dao.AprvHeadDao;
import com.kh.khsemiprj.dao.DeptDao;
import com.kh.khsemiprj.dao.EmpDao;
import com.kh.khsemiprj.dao.EmpLeaveDao;
import com.kh.khsemiprj.dao.EmpPositionDao;
import com.kh.khsemiprj.dao.EmpPositionDeptDao;
import com.kh.khsemiprj.dao.LogAccessDao;
import com.kh.khsemiprj.dao.LogInoutDao;
import com.kh.khsemiprj.dto.AprvHeadDto;
import com.kh.khsemiprj.dto.DeptDto;
import com.kh.khsemiprj.dto.EmpDto;
import com.kh.khsemiprj.dto.EmpLeaveDto;
import com.kh.khsemiprj.dto.EmpPositionDeptDto;
import com.kh.khsemiprj.dto.EmpPositionDto;
import com.kh.khsemiprj.dto.HeadDto;
import com.kh.khsemiprj.dto.LogAccessDto;
import com.kh.khsemiprj.dto.LogInoutDto;
import com.kh.khsemiprj.vo.LeaveManageVO;
import com.kh.khsemiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {
	@Autowired
	AprvHeadDao aprvHeadDao;
	@Autowired
	EmpPositionDao empPositionDao;
	@Autowired
	private EmpPositionDeptDao empPositionDeptDao;
	@Autowired
	private EmpDao empDao;
	@Autowired
	private DeptDao deptDao;
	@Autowired
	private EmpLeaveDao empLeaveDao;
	@Autowired
	private LogInoutDao logInoutDao;
	@Autowired
	private LogAccessDao logAccessDao;
	
	@RequestMapping("/manage")
	public String list(Model model, HttpSession session ,PageVO pageVO ) {
		//헤드 리스트 
		List<AprvHeadDto> aprvList = aprvHeadDao.selectList();
		model.addAttribute("aprvHeadList", aprvList);
		
		//직급 리스트
		List<EmpPositionDto> empPositionList = empPositionDao.positionSelectList();
		model.addAttribute("empPositionList", empPositionList);
		
		return "admin/manage";
	}
	
	//헤더 등록
	@PostMapping("/headWrite")
	public String headWrite(@ModelAttribute AprvHeadDto aprvHeadDto) {
		
		// 1. DB에서 같은 이름의 헤더가 있는지 조회 (DAO에 selectOneByName 같은 메서드 필요)
	    AprvHeadDto findDto = aprvHeadDao.selectOneByName(aprvHeadDto.getHeadName());
	    
		if(findDto != null || aprvHeadDto == null) {
			return "redirect:/admin/manage?alarm=duplicateHead";
		}
		
		int headNo = aprvHeadDao.sequence();
		aprvHeadDto.setHeadNo(headNo);
		aprvHeadDao.insert(aprvHeadDto);
		
		return "redirect:/admin/manage?alarm=headWriter";
	}
	
	//헤더 삭제
	@PostMapping("/headDelete")
	public String headDelete(@RequestParam int headNo) {
		aprvHeadDao.delete(headNo);
		
		return "redirect:/admin/manage?alarm=headDelete";
	}
	
	//직급 등록
	@PostMapping("/empPositionWrite")
	public String empPositionWrite(@ModelAttribute EmpPositionDto empPositionDto) {
		
		
		// 1. DB에서 같은 이름의 직급이 있는지 조회
	    EmpPositionDto findNameDto = empPositionDao.selectOneByName(empPositionDto.getEmpPositionName());
	    // 2. DB에서 같은 단계의 직급단계가 있는지 조회
	    EmpPositionDto findLevelDto = empPositionDao.selectOneByLevel(empPositionDto.getEmpPositionLevel());
	    
	    if(empPositionDto.getEmpPositionName().length() == 0 || empPositionDto.getEmpPositionLevel() == 0) {
	    	return "redirect:/admin/manage?alarm=duplicatePosition";
	    }
	    
		if(findNameDto != null) {
			return "redirect:/admin/manage?alarm=duplicatePositionName";
		}
		if(findLevelDto != null) {
			return "redirect:/admin/manage?alarm=duplicatePositionLevel";
		}
		
		
		int empPositionNo = empPositionDao.sequence();
		empPositionDto.setEmpPositionNo(empPositionNo);
		empPositionDao.insert(empPositionDto);
		
		return "redirect:/admin/manage?alarm=positionWriter";
	}
	
	//직급 삭제
	@PostMapping("/empPositionDelete")
	public String empPositionDelete(@RequestParam int empPositionNo) {
		empPositionDao.delete(empPositionNo);
		
		return "redirect:/admin/manage?alarm=positionDelete";
	}
	
	
	@RequestMapping("/leave/list")
	public String list(Model model, @ModelAttribute PageVO pageVO) {
		
		int count = empPositionDeptDao.count(pageVO);
		pageVO.setCount(count);
		model.addAttribute("pageVO", pageVO);
		
		List<EmpPositionDeptDto> list = empPositionDeptDao.selectList(pageVO);
		model.addAttribute("list", list);
		
		List<EmpDto> wList = empDao.selectEmpByStatus(null);
		model.addAttribute("wList", wList);
		
		
		List<DeptDto> deptList = deptDao.deptList();
		model.addAttribute("deptList", deptList);
		
		List<EmpPositionDto> positionList = empPositionDao.positionSelectList();
		model.addAttribute("positionList", positionList);
		
		return "admin/leave/list"; 
	}
	
	@GetMapping("/leave/detail")
	public String detail(HttpSession session,
						@RequestParam String empId, Model model) {
		
		EmpDto empDto = empDao.selectOne(empId);
		EmpPositionDeptDto empPositionDeptDto = empPositionDeptDao.selectOne(empId);
		model.addAttribute("empDto", empDto);
		model.addAttribute("empPositionDeptDto", empPositionDeptDto);
		
		List<EmpPositionDto> positionList = empPositionDao.positionSelectList();
		model.addAttribute("positionList", positionList);
		
		
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {

			return "redirect:/login";

		}
		
		List<EmpLeaveDto> empLeaveList = empLeaveDao.selectList(empId);
		model.addAttribute("empLeaveList", empLeaveList);

		return "admin/leave/detail";
	}
	
	@PostMapping("/leave/edit")
	public String edit(@ModelAttribute EmpLeaveDto empLeaveDto) {
		// 1. DAO를 통해 휴가 데이터 업데이트 및 로그 기록ㅇㅇ
		empLeaveDao.updateLeaveTotal(empLeaveDto);
		
		// 2. 수정이 끝난 후 원래 보던 사원의 상세 페이지로 리다이렉트
		return "redirect:/admin/leave/detail?empId=" + empLeaveDto.getLeaveEmpId() + "&alarm=editLeave";
	}
}
