package com.kh.khsemiprj.controller;

import java.io.IOException;
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
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.khsemiprj.dao.AprvDao;
import com.kh.khsemiprj.dao.AprvFormDao;
import com.kh.khsemiprj.dao.AprvLineDao;
import com.kh.khsemiprj.dao.DeptDao;
import com.kh.khsemiprj.dao.EmpLeaveDao;
import com.kh.khsemiprj.dto.AprvDto;
import com.kh.khsemiprj.dto.AprvFormDto;
import com.kh.khsemiprj.dto.AprvLineDto;
import com.kh.khsemiprj.dto.DeptDto;
import com.kh.khsemiprj.dto.EmpLeaveDto;
import com.kh.khsemiprj.service.AttachService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@RequestMapping("/aprv")
@Controller
public class AprvController {
	
	@Autowired
	private EmpLeaveDao empLeaveDao;
	
	@Autowired
	private DeptDao deptDao;
	
	@Autowired
	private AprvDao aprvDao;
	
	@Autowired
	private AprvLineDao aprvLineDao;
	
	@Autowired
	private AprvFormDao aprvFormDao;
	
	@Autowired
	private AttachService attachService;
	
	@RequestMapping("/list")
	public String list(Model model) {
		
		List<AprvFormDto> formList = aprvFormDao.selectListForInsert();
		model.addAttribute("formList", formList);
		
		return "aprv/list";
	}
	
	@GetMapping("/insert")
	public String insert(HttpServletRequest request, Model model) throws JsonProcessingException {
		
		HttpSession session = request.getSession();
		String loginId = (String)session.getAttribute("loginId");
		
		EmpLeaveDto empLeaveDto = empLeaveDao.selectOne(loginId);
		model.addAttribute("leaveRemain", empLeaveDto.getLeaveRemain());
		
		// 1. 부서 목록 가져오기
 		//List<DeptDto> list = deptDao.selectListAll();
		List<DeptDto> list = deptDao.selectListMyDept(loginId);
 		
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
	
	@PostMapping("/insert")
	public String insert(@ModelAttribute AprvDto aprvDto, @RequestParam(required = false) MultipartFile attach
						, @RequestParam(value = "aprvLine1IdList") List<String> aprvLine1IdList
						, @RequestParam(value = "aprvLine2IdList", required = false) List<String> aprvLine2IdList
						, HttpServletRequest request) throws IllegalStateException, IOException {
		
		HttpSession session = request.getSession();
		String loginId = (String)session.getAttribute("loginId");
		
		aprvDto.setAprvWriter(loginId);
		
		int aprvNo = aprvDao.sequence();
		aprvDto.setAprvNo(aprvNo);
		if(aprvLine1IdList.size() > 0) {
			aprvDto.setAprvCurrentSeq(1);
		} else {
			aprvDto.setAprvCurrentSeq(0);
		}
		boolean result = aprvDao.insertAprv(aprvDto);
		if(result) {
			//첨부파일 연결
			if(!attach.isEmpty()) {
				int attachNo = attachService.save(attach);
				aprvDao.connect(aprvDto.getAprvNo(), attachNo);
			}
			
			//결재라인1 등록
			for(int i = 0; i < aprvLine1IdList.size(); i++) {
				int aprvLineNo = aprvLineDao.sequence();
				AprvLineDto aprvLineDto = new AprvLineDto();
				aprvLineDto.setAprvLineNo(aprvLineNo);
				aprvLineDto.setAprvDocumentNo(aprvNo);
				aprvLineDto.setEmpId(aprvLine1IdList.get(i));
				aprvLineDto.setAprvLineCurrentSeq(1);
				aprvLineDto.setAprvLineStatus("대기");
				aprvLineDao.insertAprvLine(aprvLineDto);
			}
			
			//결재라인2 등록
			if(aprvLine2IdList != null) {
				for(int i = 0; i < aprvLine2IdList.size(); i++) {
					int aprvLineNo = aprvLineDao.sequence();
					AprvLineDto aprvLineDto = new AprvLineDto();
					aprvLineDto.setAprvLineNo(aprvLineNo);
					aprvLineDto.setAprvDocumentNo(aprvNo);
					aprvLineDto.setEmpId(aprvLine2IdList.get(i));
					aprvLineDto.setAprvLineCurrentSeq(2);
					aprvLineDto.setAprvLineStatus("대기");
					aprvLineDao.insertAprvLine(aprvLineDto);
				}
			}
		}
		
		
		return "redirect:./list";
	}
}
