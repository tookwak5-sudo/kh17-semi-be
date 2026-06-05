package com.kh.khsemiprj.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.google.gson.Gson;
import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.dto.PlanDto;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
	
	@Autowired
	private PlanDao planDao;
	
	@RequestMapping("/")
	public String home(Model model
			, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId"); 
		PlanDto findPlanDto = new PlanDto();
		
		List<PlanDto> planList = planDao.selectListByMine(findPlanDto.getPlanDeptNo(), loginId);
		
		List<Map<String, String>> eventList = new ArrayList<>();
		for(PlanDto planDto : planList) {
			Map<String, String> event = new HashMap<>();
			event.put("title", planDto.getPlanName());
	        event.put("start", planDto.getPlanSdate());
	        event.put("end", planDto.getPlanEdate() + "T23:59:59");
	        
	        eventList.add(event);
		}
		
		model.addAttribute("eventList", new Gson().toJson(eventList));
		
		return "home";
	}
}
