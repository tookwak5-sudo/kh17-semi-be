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
import com.kh.khsemiprj.dao.BoardDao;
import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.dto.BoardDto;
import com.kh.khsemiprj.dto.PlanDto;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
	
	@Autowired
	private PlanDao planDao;
	@Autowired
	private BoardDao boardDao;
	@RequestMapping("/")
	public String home(Model model
			, HttpSession session) {

		String loginId = (String)session.getAttribute("loginId");
		PlanDto findPlanDto = new PlanDto();
		
		List<PlanDto> planList = planDao.selectListByMine(findPlanDto.getPlanDeptNo(), loginId);
		
		List<Map<String, Object>> eventList = new ArrayList<>();
		for(PlanDto planDto : planList) {
			Map<String, Object> event = new HashMap<>();
			event.put("title", planDto.getPlanName());
			Map<String, Object> extendedProps = new HashMap<>();
			extendedProps.put("planType", planDto.getPlanType());
			extendedProps.put("planNo", planDto.getPlanNo());
			extendedProps.put("planExplain", planDto.getPlanExplain());
			event.put("extendedProps", extendedProps);
	        event.put("start", planDto.getPlanSdate());
	        event.put("end", planDto.getPlanEdate() + "T23:59:59");
	        
	        eventList.add(event);
		}
		
		model.addAttribute("eventList", new Gson().toJson(eventList));
		
		List<BoardDto> grabNoticeList = boardDao.selectNoticeList();
		
		List<Map<String,Object>> noticeList = new ArrayList<>();
		for(BoardDto boardDto:grabNoticeList) {
			Map<String,Object>notice=new HashMap<>();
			notice.put("boardNo", boardDto.getBoardNo());
			notice.put("boardWriter", boardDto.getBoardWriter());
			notice.put("boardTitle", boardDto.getBoardTitle());
		
			
			noticeList.add(notice);
		}
		
		model.addAttribute("noticeList", noticeList);
		
		return "home";
	}
}
