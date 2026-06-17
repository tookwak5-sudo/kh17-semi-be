package com.kh.khsemiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.vo.PageVO;
import com.kh.khsemiprj.vo.PlanEmpDeptVO;

import jakarta.servlet.http.HttpSession;


@Controller
@RequestMapping("/plan")
public class PlanController {
	
	@Autowired
	private PlanDao planDao;
	
	@RequestMapping("/list")
	public String list(HttpSession session,Model model, @ModelAttribute PageVO pageVO) {
		String loginId = (String)session.getAttribute("loginId");
		
	    int count = planDao.count(pageVO, loginId);
	    pageVO.setCount(count);
	    model.addAttribute("pageVO", pageVO);
	    
	   
	    List<PlanEmpDeptVO> planList = planDao.selectList(pageVO, loginId);
	    model.addAttribute("planList", planList); 
	    
	    return "plan/list"; 
	}
}
