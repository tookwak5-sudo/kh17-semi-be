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
import com.kh.khsemiprj.dto.AprvHeadDto;
import com.kh.khsemiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {
	@Autowired
	AprvHeadDao aprvHeadDao;
	
	@RequestMapping("/manage")
	public String list(Model model, HttpSession session ,PageVO pageVO ) {

		List<AprvHeadDto> aprvList = aprvHeadDao.selectList(pageVO.getBeginRownum(), pageVO.getEndRownum());
		model.addAttribute("aprvHeadList", aprvList);
		int count = aprvHeadDao.count();
		pageVO.setCount(count);
		model.addAttribute("AprvHeadPageVO", pageVO);
		
		return "admin/manage";
	}
	
	//등록
		@PostMapping("/write")
		public String write(@ModelAttribute AprvHeadDto aprvHeadDto) {
			int headNo = aprvHeadDao.sequence();
			aprvHeadDto.setHeadNo(headNo);
			aprvHeadDao.insert(aprvHeadDto);
			
			return "redirect:manage";
		}
		
		//삭제
		@PostMapping("/delete")
		public String delete(@RequestParam int headNo) {
			aprvHeadDao.delete(headNo);
			
			return "redirect:manage";
		}
	
}
