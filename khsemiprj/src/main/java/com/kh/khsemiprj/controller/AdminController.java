package com.kh.khsemiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.khsemiprj.dao.AprvHeadDao;
import com.kh.khsemiprj.dao.EmpExitDao;
import com.kh.khsemiprj.dao.EmpPositionDao;
import com.kh.khsemiprj.dto.AprvHeadDto;
import com.kh.khsemiprj.dto.EmpPositionDto;
import com.kh.khsemiprj.vo.EmpExitVO;
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
	EmpExitDao empExitDao;
	
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
		int headNo = aprvHeadDao.sequence();
		aprvHeadDto.setHeadNo(headNo);
		aprvHeadDao.insert(aprvHeadDto);
		
		return "redirect:manage";
	}
	
	//헤더 삭제
	@PostMapping("/headDelete")
	public String headDelete(@RequestParam int headNo) {
		aprvHeadDao.delete(headNo);
		
		return "redirect:manage";
	}
	
	//직급 등록
	@PostMapping("/empPositionWrite")
	public String empPositionWrite(@ModelAttribute EmpPositionDto empPositionDto) {
		int empPositionNo = empPositionDao.sequence();
		empPositionDto.setEmpPositionNo(empPositionNo);
		empPositionDao.insert(empPositionDto);
		
		return "redirect:manage";
	}
	
	//직급 삭제
	@PostMapping("/empPositionDelete")
	public String empPositionDelete(@RequestParam int empPositionNo) {
		empPositionDao.delete(empPositionNo);
		
		return "redirect:manage";
	}
	
	//퇴사자 목록
		@RequestMapping("/exitList")
		public String exitList(@ModelAttribute PageVO pageVO, Model model) {
			List<EmpExitVO> exitList = empExitDao.selectList(pageVO);
			model.addAttribute("exitList", exitList);
			int count = empExitDao.count(pageVO);
			pageVO.setCount(count);
			model.addAttribute("pageVO",pageVO);
			return "emp/exitList";
		}
		
	
}
