package com.kh.khsemiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.dto.PlanDto;

@Controller
@RequestMapping("/plan")
public class PlanController {
	
	@Autowired
	private PlanDao planDao;
	
	@GetMapping("/write")
	public String write(Model model) {
        // DB에서 리스트를 조회하여 JSP로 전달
        List<PlanDto> list = planDao.selectListType(); 
        model.addAttribute("list", list);
        return "/home";
    }
}
