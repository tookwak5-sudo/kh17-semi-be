package com.kh.khsemiprj.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.kh.khsemiprj.dao.BoardDao;
import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.dto.BoardDto;
import com.kh.khsemiprj.dto.HeadDto;
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
			, HttpSession session) throws JsonProcessingException {

		String loginId = (String)session.getAttribute("loginId");
		
		List<PlanDto> planList = planDao.selectList(loginId);
		List<Map<String, Object>> eventList = new ArrayList<>();
		for(PlanDto planDto : planList) {
			Map<String, Object> event = new HashMap<>();
			event.put("title", planDto.getPlanName());
			Map<String, Object> extendedProps = new HashMap<>();
			extendedProps.put("planNo", planDto.getPlanNo());
			extendedProps.put("planHeadNo", planDto.getPlanHeadNo());
			extendedProps.put("planType", planDto.getPlanType());
			extendedProps.put("planExplain", planDto.getPlanExplain());
			event.put("extendedProps", extendedProps);
	        event.put("start", planDto.getPlanSdate());
	        event.put("end", planDto.getPlanEdate() + "T23:59:59");
	        
	        eventList.add(event);
		}
		
		model.addAttribute("eventList", new Gson().toJson(eventList));
		
		
		//목표: DB에 저장된 Head의 정보를 가져오기
		Map<Integer, HeadDto> dtoMap = new HashMap<>();
		List<HeadDto> list = planDao.selectListHeader();
		for (HeadDto dto : list) {
 	        dtoMap.put(dto.getHeadNo(), dto);
 	    }
 	    // 3. 자바 객체를 JSP의 JavaScript가 인식할 수 있도록 JSON 문자열로 변환
 	    ObjectMapper objectMapper = new ObjectMapper();
 	    String planHeadJson = objectMapper.writeValueAsString(list);
 	    
 	    // 4. Model에 담아서 jsp로 전달
 		model.addAttribute("planHeadJson", planHeadJson);
 		
 		// 홈에서 board 공지사항 전달하는 코드
 		
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
