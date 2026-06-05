package com.kh.khsemiprj.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.khsemiprj.dao.AprvFormDao;
import com.kh.khsemiprj.dao.DeptDao;
import com.kh.khsemiprj.dto.AprvFormDto;
import com.kh.khsemiprj.dto.DeptDto;

@RequestMapping("/aprv")
@Controller
public class AprvController {
	
	@Autowired
	private DeptDao deptDao;
	
	@Autowired
	private AprvFormDao aprvFormDao;
	
	@RequestMapping("/list")
	public String list() {
		
		return "aprv/list";
	}
	
	@GetMapping("/insert")
	public String insert(Model model) throws JsonProcessingException {
		
		// 1. 부서 목록 가져오기
 		List<DeptDto> list = deptDao.selectListAll();
 		
 		// 2. 부서 목록 트리구조로 변경
 		List<DeptDto> rootList = new ArrayList<>();
 	    Map<Long, DeptDto> dtoMap = new HashMap<>();
 	    
 	    // - 2-1. Map에 모두 저장
 	    for (DeptDto dto : list) {
 	        dtoMap.put(dto.getDeptNo(), dto);
 	    }
 	    
 	    // - 2-2. 부서번호를 키값으로 가지는 해시맵 생성
 	    for (DeptDto dto : list) {
 	    	Long deptParentNo = dto.getDeptParentNo();
 	    	dtoMap.put(dto.getDeptNo(), dto);
 	    	// 부모 ID가 없거나, 부모 ID가 있지만 Map에 존재하지 않는 경우 최상위(Root)로 취급
 	    	if (dto.getDeptDepth() == 0 || dto.getDeptParentNo() == null || !dtoMap.containsKey(deptParentNo)) {
 	            rootList.add(dto);
 	        } else {
 	        	// 부모가 있다면 해당 부모의 자식 리스트에 추가
 	            dtoMap.get(deptParentNo).getChildren().add(dto);
 	        }
 	    }
 		
 	    // 3. 자바 객체를 JSP의 JavaScript가 인식할 수 있도록 JSON 문자열로 변환
 	    ObjectMapper objectMapper = new ObjectMapper();
 	   String deptListJson = objectMapper.writeValueAsString(rootList);
 	    
 	    // 4. Model에 담아서 jsp로 전달
 		model.addAttribute("deptListJson", deptListJson);
		
 		List<AprvFormDto> formList = aprvFormDao.selectListForInsert();
		model.addAttribute("formList", formList);
 		
		return "aprv/insert";
	}
}
