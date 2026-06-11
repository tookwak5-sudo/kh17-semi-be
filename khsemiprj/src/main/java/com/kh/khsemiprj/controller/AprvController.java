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
import com.kh.khsemiprj.dao.AttachDao;
import com.kh.khsemiprj.dao.DeptDao;
import com.kh.khsemiprj.dao.EmpLeaveDao;
import com.kh.khsemiprj.dto.AprvDto;
import com.kh.khsemiprj.dto.AprvFormDto;
import com.kh.khsemiprj.dto.AprvLineDto;
import com.kh.khsemiprj.dto.AttachDto;
import com.kh.khsemiprj.dto.DeptDto;
import com.kh.khsemiprj.dto.EmpLeaveDto;
import com.kh.khsemiprj.exception.GetOutException;
import com.kh.khsemiprj.service.AttachService;
import com.kh.khsemiprj.vo.AprvLineListVO;
import com.kh.khsemiprj.vo.PageVO;

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
	private AttachDao attachDao;
	
	@Autowired
	private AttachService attachService;
	
	@RequestMapping("/list")
	public String list(HttpServletRequest request, Model model, @ModelAttribute PageVO pageVO) {
		
		HttpSession session = request.getSession();
		String loginId = (String)session.getAttribute("loginId");
		
		List<AprvFormDto> formList = aprvFormDao.selectListForInsert();
		model.addAttribute("formList", formList);
		
		List<AprvDto> aprvList = aprvDao.selectList(pageVO, loginId);
		model.addAttribute("aprvList", aprvList);
		
		//페이징을 위해 추가로 전달할 값이 있다면 전달해야 한다
		int count = aprvDao.count(pageVO);
		pageVO.setCount(count);//데이터 개수 설정
		model.addAttribute("pageVO", pageVO);
		
		return "aprv/list";
	}
	
	@GetMapping("/insert")
	public String insert(HttpServletRequest request, Model model) throws JsonProcessingException {
		
		HttpSession session = request.getSession();
		String loginId = (String)session.getAttribute("loginId");
		
		EmpLeaveDto empLeaveDto = empLeaveDao.selectOne(loginId);
		double leaveRemain = empLeaveDto == null ? 0 : empLeaveDto.getLeaveRemain();
		model.addAttribute("leaveRemain", leaveRemain);
		
		// 1. 부서 목록 가져오기
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
		
		boolean result = aprvDto.getAprvStatus().equals("대기") ? aprvDao.insertAprv(aprvDto)
														: aprvDao.insertAprvTemp(aprvDto);
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
	
	@RequestMapping("/detail")
	public String detail(Model model
						, @RequestParam int aprvNo) {
		
		AprvDto aprvDto = aprvDao.selectOne(aprvNo);
		model.addAttribute("aprvDto", aprvDto);
		
		Integer attachNo = aprvDao.searchAttach(aprvNo);
		if(attachNo != null) {
			AttachDto attachDto = attachDao.selectOne(attachNo);
			model.addAttribute("attachDto", attachDto);
		}
		
		List<AprvLineListVO> aprvLine1List = aprvLineDao.selectList1(aprvNo);
		List<AprvLineListVO> aprvLine2List = aprvLineDao.selectList2(aprvNo);
		model.addAttribute("aprvLine1List", aprvLine1List);
		model.addAttribute("aprvLine2List", aprvLine2List);
		return "aprv/detail";
	}
	
	@GetMapping("/edit")
	public String edit(HttpServletRequest request, Model model, @RequestParam int aprvNo) throws JsonProcessingException {
		HttpSession session = request.getSession();
		String loginId = (String)session.getAttribute("loginId");
		
		//결재 정보
		AprvDto aprvDto = aprvDao.selectOne(aprvNo);
		model.addAttribute("aprvDto", aprvDto);
		
		//첨부파일
		Integer attachNo = aprvDao.searchAttach(aprvNo);
		if(attachNo != null) {
			AttachDto attachDto = attachDao.selectOne(attachNo);
			model.addAttribute("attachDto", attachDto);
		}
		
		//결재 라인 목록
		List<AprvLineListVO> aprvLine1List = aprvLineDao.selectList1(aprvNo);
		List<AprvLineListVO> aprvLine2List = aprvLineDao.selectList2(aprvNo);
		model.addAttribute("aprvLine1List", aprvLine1List);
		model.addAttribute("aprvLine2List", aprvLine2List);
		
		//잔여 휴가 일수
		EmpLeaveDto empLeaveDto = empLeaveDao.selectOne(loginId);
		double leaveRemain = empLeaveDto == null ? 0 : empLeaveDto.getLeaveRemain();
		model.addAttribute("leaveRemain", leaveRemain);
		
		// 1. 부서 목록 가져오기
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
 		
		return "aprv/edit";
	}
	
	@PostMapping("/edit")
	public String edit(@ModelAttribute AprvDto aprvDto, @RequestParam(required = false) MultipartFile attach
						, @RequestParam(value = "aprvLine1IdList") List<String> aprvLine1IdList
						, @RequestParam(value = "aprvLine2IdList", required = false) List<String> aprvLine2IdList
						, @RequestParam(value = "deleteFileNo", defaultValue = "") String deleteFileNo
						, HttpServletRequest request) throws IllegalStateException, IOException {
		
		HttpSession session = request.getSession();
		String loginId = (String)session.getAttribute("loginId");
		
		aprvDto.setAprvWriter(loginId);
		if(aprvLine1IdList.size() > 0) {
			aprvDto.setAprvCurrentSeq(1);
		} else {
			aprvDto.setAprvCurrentSeq(0);
		}
		
		boolean result = aprvDto.getAprvStatus().equals("대기") ? aprvDao.updateAprv(aprvDto)
														: aprvDao.updateAprvTemp(aprvDto);
		int aprvNo = aprvDto.getAprvNo();
		if(result) {
			//첨부파일 제거
			if(!deleteFileNo.equals("")) {
				aprvDao.deleteAttach(Integer.parseInt(deleteFileNo));//결재첨부파일 삭제
				attachService.delete(Integer.parseInt(deleteFileNo));//첨부파일 삭제
			}
			
			//첨부파일 연결
			if(!attach.isEmpty()) {
				int attachNo = attachService.save(attach);
				aprvDao.connect(aprvNo, attachNo);
			}
			
			//기존 결재라인 삭제
			aprvLineDao.deleteAprvLine(aprvNo);
			
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
		
		
		return "redirect:./detail?aprvNo=" + aprvNo;
	}
	
	@PostMapping("/save")
	public String save(@RequestParam int aprvNo) {
		
		boolean result =  aprvDao.save(aprvNo);
		
		return "redirect:./detail?aprvNo=" + aprvNo;
	}
	
	@PostMapping("/delete")
	public String delete(@RequestParam int aprvNo) throws Exception {
		AprvDto aprvDto = aprvDao.selectOne(aprvNo);
		if(aprvDto.getAprvStatus().equals("임시저장")) {
			boolean result = aprvDao.delete(aprvNo);
			if(result) {
				
			} else {
				throw new Exception("결재파일 삭제에 실패했습니다.");
			}
		} else {
			throw new GetOutException("삭제 할 수 없는 결재문서입니다.");
		}
		return "redirect:./list";
	}
}
