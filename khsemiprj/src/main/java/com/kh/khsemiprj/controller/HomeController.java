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
import com.kh.khsemiprj.dao.AprvDao;
import com.kh.khsemiprj.dao.BoardDao;
import com.kh.khsemiprj.dao.EmpPositionDeptDao;
import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.dto.BoardDto;
import com.kh.khsemiprj.dto.HeadDto;
import com.kh.khsemiprj.dto.PlanDto;
import com.kh.khsemiprj.vo.EmpAprvLineVO;
import com.kh.khsemiprj.vo.PlanHeadVO;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
	
	@Autowired
	private PlanDao planDao;
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private EmpPositionDeptDao empPositionDeptDao;
	@Autowired
	private AprvDao aprvDao;
	
	@RequestMapping("/")
	public String home(Model model
			, HttpSession session) throws JsonProcessingException {

		String loginId = (String)session.getAttribute("loginId");
		// 목표 아이디를 통해 일정에 부서번호 등록하기
		// [1] 아이디 입력을 통해 부서번호 조회
		Long deptNo = empPositionDeptDao.selectDeptbyId(loginId);  
		//List<PlanDto> planList = planDao.selectList(loginId);
		List<PlanHeadVO> planList = planDao.selectVOList(loginId);
		System.out.println("planList = " + planList);
		List<Map<String, Object>> eventList = new ArrayList<>();
		for(PlanHeadVO planHeadVO : planList) {
			Map<String, Object> event = new HashMap<>();
			event.put("title", planHeadVO.getPlanName());
			Map<String, Object> extendedProps = new HashMap<>();
			extendedProps.put("planNo", planHeadVO.getPlanNo());
			extendedProps.put("planHeadNo", planHeadVO.getPlanHeadNo());
			extendedProps.put("planHeadType", planHeadVO.getHeadType());
			extendedProps.put("planType", planHeadVO.getPlanType());
			extendedProps.put("planExplain", planHeadVO.getPlanExplain());
			extendedProps.put("planDeptNo", planHeadVO.getPlanDeptNo());
			extendedProps.put("planEmpId", planHeadVO.getPlanEmpId());
			event.put("extendedProps", extendedProps);
	        event.put("start", planHeadVO.getPlanSdate());
	        event.put("end", planHeadVO.getPlanEdate() + "T23:59:59");
	        eventList.add(event);
		}
		
		model.addAttribute("loginId", loginId);
		model.addAttribute("deptNo", deptNo);
		model.addAttribute("eventList", new Gson().toJson(eventList));
		
		//목표: DB에 저장된 Head의 정보를 가져오기
		//Map<Integer, HeadDto> DtoMap = new HashMap<>();
		List<HeadDto> list = planDao.selectListHeader();
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
		
		if (loginId != null) {
			//내가 쓴 글 결재 목록
			List<EmpAprvLineVO> myAprvList = aprvDao.selectMyList(loginId);
			if(myAprvList == null || myAprvList.isEmpty()) {
		        model.addAttribute("emptyMyList", true);
		    } else {
		        model.addAttribute("emptyMyList", false); // 데이터가 있다면 false
		    }
			model.addAttribute("myAprvList", myAprvList);
			
			//내가 승인해야 할 결재 목록
			List<EmpAprvLineVO> receivedAprvList = aprvDao.selectReceivedList(loginId);
			if(receivedAprvList == null || receivedAprvList.isEmpty()) {
		        model.addAttribute("emptyReceivedList", true);
		    } else {
		        model.addAttribute("emptyReceivedList", false); // 데이터가 있다면 false
		    }
			model.addAttribute("receivedAprvList", receivedAprvList);
		}
		return "home";
	}
}
