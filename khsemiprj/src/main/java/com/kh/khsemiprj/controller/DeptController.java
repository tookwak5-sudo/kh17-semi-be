package com.kh.khsemiprj.controller;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.khsemiprj.dao.DeptDao;
import com.kh.khsemiprj.dao.EmpPositionDeptDao;
import com.kh.khsemiprj.dto.DeptDto;
import com.kh.khsemiprj.exception.TargetNotfoundException;
import com.kh.khsemiprj.vo.DeptVO;

@Controller
@RequestMapping("/dept")
public class DeptController {
	@Autowired
	private DeptDao deptDao;
	@Autowired
	private EmpPositionDeptDao empPositionDeptDao;
	

	// 부서 정보 등록
	@GetMapping("/insert")
	public String insert(@ModelAttribute DeptDto deptDto, Model model) {
		List<DeptDto> deptList = deptDao.deptList();
		model.addAttribute("deptList", deptList);
		return "dept/insert";
	}
	@PostMapping("/insert")
	public String join(@ModelAttribute DeptDto deptDto, Model model) {
		
		deptDao.insert(deptDto);
		
		return "redirect:./insertComplete";
	}
	
	// 부서 정보 등록 완료
	@RequestMapping("/insertComplete")
	public String insertComplete() {
		return "dept/insertComplete";
	}
 	
	
	// 부서 목록 
	@RequestMapping("/list")

	public String list(Model model, @RequestParam(defaultValue = "0") long deptNo) throws JsonProcessingException {
		
		// 1. 부서 목록 가져오기
 		List<DeptVO> list = deptDao.selectListAll();
 		
 		// 2. 부서 목록 트리구조로 변경
 		List<DeptVO> rootList = new ArrayList<>();
 	    Map<Long, DeptVO> dtoMap = new HashMap<>();
 	    
 	    // - 2-1. Map에 모두 저장
 	    for (DeptVO dto : list) {
 	        dtoMap.put(dto.getDeptNo(), dto);
 	    }
 	    
 	    // - 2-2. 부서번호를 키값으로 가지는 해시맵 생성
 	    for (DeptVO dto : list) {
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
		
		return "dept/list";
	}
	
	// 부서 수정
	@GetMapping("/edit")
	public String edit(@RequestParam long deptNo, Model model) {
		DeptDto deptDto = deptDao.selectOne(deptNo);
		if(deptDto == null) throw new TargetNotfoundException("존재하지 않는 부서");
		//승인된 부서 체크
		boolean isChecked = "Y".equals(deptDto.getDeptUseYn());
		model.addAttribute("isChecked", isChecked);
		model.addAttribute("deptDto", deptDto);
		model.addAttribute("deptList",deptDao.deptList());
		return "dept/edit";
	}	
	@PostMapping("/edit")
	public String edit(@ModelAttribute DeptDto deptDto) {
		//오류 검사는 get에서 진행함 바로 값을 가져오기
		deptDao.update(deptDto);
		
		
		
		return "redirect:./list";
	//	return "redirect:dept/list"; //절대경로
	}
	
	// 부서 삭제
	@RequestMapping("/delete")
	public String delete(@RequestParam long deptNo) {
		DeptDto deptDto = deptDao.selectOne(deptNo);
		if(deptDto == null) throw new TargetNotfoundException("존재하지 않는 부서");
		deptDao.delete(deptNo);
		return "redirect:./list"; //상대경로
//		return "redirect:dept/list"; //절대경로
	}
	
	@RequestMapping("/chart")
	public String chart(Model model) throws JsonProcessingException {
		
		// 1. 부서 목록 가져오기
 		List<DeptVO> list = deptDao.selectListAll();
 		
 		// 2. 부서 목록 트리구조로 변경
 		List<DeptVO> rootList = new ArrayList<>();
 	    Map<Long, DeptVO> dtoMap = new HashMap<>();
 	    
 	    // - 2-1. Map에 모두 저장
 	    for (DeptVO dto : list) {
 	        dtoMap.put(dto.getDeptNo(), dto);
 	    }
 	    
 	    // - 2-2. 부서번호를 키값으로 가지는 해시맵 생성
 	    for (DeptVO dto : list) {
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
 	    String deptChartJson = objectMapper.writeValueAsString(rootList);
 	    
 	    // 4. Model에 담아서 jsp로 전달
 		model.addAttribute("deptChartJson", deptChartJson);
		System.out.println(deptChartJson);
		return "dept/chart";
	}
}
