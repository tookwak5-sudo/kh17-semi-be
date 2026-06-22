package com.kh.khsemiprj.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.kh.khsemiprj.dao.AprvFormDao;
import com.kh.khsemiprj.dao.AttachDao;
import com.kh.khsemiprj.dao.EmpDao;
import com.kh.khsemiprj.dto.AprvFormDto;
import com.kh.khsemiprj.dto.AttachDto;
import com.kh.khsemiprj.dto.EmpDto;
import com.kh.khsemiprj.exception.TargetNotfoundException;
import com.kh.khsemiprj.service.AprvFormService;
import com.kh.khsemiprj.vo.AprvFormHeadNameVO;
import com.kh.khsemiprj.vo.AprvFormHeadTypeVO;
import com.kh.khsemiprj.vo.AprvFormSelectVO;
import com.kh.khsemiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/aprvForm")
public class AprvFormController {

	@Autowired
	private AprvFormService aprvFormService;

	@Autowired
	private AprvFormDao aprvFormDao;
	
	@Autowired
	private AttachDao attachDao;
	
	@Autowired
	private EmpDao empDao;

	@GetMapping("/list")
	public String list(@ModelAttribute PageVO pageVO, Model model,HttpSession session) {
	    
		String loginId = (String)session.getAttribute("loginId");
		
		EmpDto findEmpDto = new EmpDto();
		findEmpDto = empDao.selectOne(loginId);
		if(findEmpDto == null || findEmpDto.getEmpGrade()<1) {
			return "error/403";
		}
		
	    int count = aprvFormDao.count(pageVO);
	    pageVO.setCount(count);
	    
	
	    List<AprvFormSelectVO> list = aprvFormDao.selectList(pageVO);
	    List<AprvFormHeadNameVO> filterHeadList = aprvFormDao.selectFilteredHeadList();
	    
	    model.addAttribute("list", list);
	    model.addAttribute("pageVO", pageVO);
	    model.addAttribute("filterHeadList", filterHeadList);
	    
	    return "aprvForm/list";
	}


	// 2. 결재 양식 상세 보기
	@GetMapping("/detail")
	public String detail(@RequestParam int formNo, Model model) {
		
		AprvFormSelectVO aprvFormSelectVO = aprvFormDao.selectOneUsingHead(formNo);
		Integer attachNo = aprvFormDao.findAttachNo(formNo);
		model.addAttribute("attachNo", attachNo);
		model.addAttribute("aprvFormSelectVO", aprvFormSelectVO);
		
		if(attachNo != null) {
			AttachDto attachDto = attachDao.selectOne(attachNo);
			model.addAttribute("attachDto",attachDto);
		}
		
		return "aprvForm/detail";
	}

	// 3. 결재 양식 신규 등록 페이지 열기
	@GetMapping("/insert")
	public String insert(Model model, HttpSession session) {
		
		String loginId = (String)session.getAttribute("loginId");
		
		EmpDto findEmpDto = new EmpDto();
		findEmpDto = empDao.selectOne(loginId);
		if(findEmpDto == null || findEmpDto.getEmpGrade()<1) {
			return "error/403";
		}
		
		
		List<AprvFormHeadNameVO> filteredHeadList = aprvFormDao.selectFilteredHeadList();
		List<AprvFormHeadTypeVO> filteredTypeList = aprvFormDao.selectFilteredTypeList();

		model.addAttribute("headList", filteredHeadList);
		model.addAttribute("typeList", filteredTypeList);

		return "aprvForm/insert";
	}

	// 4. 결재 양식 신규 등록 처리 (텍스트 + 파일)
	@PostMapping("/insert")
	public String insert(
	        @RequestParam String formName,
	        @RequestParam String formExplain,
	        @RequestParam String headName,
	        @RequestParam(required = false) String formUseYn,
	        @RequestParam(required = false) MultipartFile attach
	        ,HttpSession session) throws IllegalStateException, IOException {

		String loginId = (String)session.getAttribute("loginId");
		
		EmpDto findEmpDto = new EmpDto();
		findEmpDto = empDao.selectOne(loginId);
		if(findEmpDto == null || findEmpDto.getEmpGrade()<1) {
			return "redirect:/error/403";
		}
		
		
		
		// 1. DTO 객체 수동 생성 후 파라미터 매핑
	    AprvFormDto aprvFormDto = new AprvFormDto();
	    aprvFormDto.setFormName(formName);
	    aprvFormDto.setFormExplain(formExplain);
	    
	    // 2. 체크박스 null 처리 해주고 Y/N 세팅
	    aprvFormDto.setFormUseYn(formUseYn != null ? "Y" : "N");

	    // 3. 화면에서 넘어온 명칭으로 진짜 head_no를 DB에서 조회
	    int headNo = aprvFormDao.findHeadNo(headName);

	    if (headNo == 0) {
	        return "redirect:/aprvForm/insert?error=invalid_head";
	    }

	    // 4. 찾아온 외래키 번호를 DTO에 세팅
	    aprvFormDto.setFormHeadNo(headNo);

	    // 5. 서비스 호출해서 인서트 진행 (파일이 없어도 알아서 처리됨)
	    aprvFormService.registerFormFile(aprvFormDto, attach);

	    int newFormNo = aprvFormDto.getFormNo();
	    return "redirect:./detail?formNo="+newFormNo;
	}

	// 5. 결재 양식 수정 페이지 열기
	@GetMapping("/edit")
	public String edit(@RequestParam int formNo, Model model, HttpSession session) {
		
		String loginId = (String)session.getAttribute("loginId");
		
		EmpDto findEmpDto = new EmpDto();
		findEmpDto = empDao.selectOne(loginId);
		if(findEmpDto == null || findEmpDto.getEmpGrade() < 1) {
			return "redirect:/error/500";
		}
		
		try {

			AprvFormDto aprvFormDto = aprvFormDao.selectOne(formNo);
			model.addAttribute("aprvFormDto", aprvFormDto);

			AprvFormSelectVO findHeadName = aprvFormDao.selectOneUsingHead(formNo);
			model.addAttribute("findHeadName", findHeadName);

			AprvFormSelectVO findHeadType = aprvFormDao.selectOneUsingType(formNo);
			model.addAttribute("findHeadType", findHeadType);

			Integer attachNo = aprvFormDao.findAttachNo(formNo);
			model.addAttribute("attachNo", attachNo);

			List<AprvFormHeadNameVO> filteredHeadList = aprvFormDao.selectFilteredHeadList();
			List<AprvFormHeadTypeVO> filteredTypeList = aprvFormDao.selectFilteredTypeList();

			model.addAttribute("headList", filteredHeadList);
			model.addAttribute("typeList", filteredTypeList);

			return "aprvForm/edit";

		}

		catch (TargetNotfoundException e) {
			return "redirect:/error/403";
		}
	}

	// 6. 결재 양식 및 파일 수정 처리
	@PostMapping("/edit")
	public String edit(@ModelAttribute AprvFormDto aprvFormDto, @ModelAttribute AttachDto attachDto,
			@RequestParam(value = "head_name") String headName, @RequestParam(value = "head_type") String headType,
			@RequestParam(required = false) MultipartFile attach, HttpSession session) throws IllegalStateException, IOException {

		String loginId = (String)session.getAttribute("loginId");
		
		EmpDto findEmpDto = new EmpDto();
		findEmpDto = empDao.selectOne(loginId);
		if(findEmpDto == null || findEmpDto.getEmpGrade()<1) {
			return "redirect:/error/403";
		}
		
		
		int headNo = aprvFormDao.findHeadNo(headName);

		if (headNo == 0) {
			// 이상한 조합이면 수정 안 시키고 에러 리다이렉트
			return "redirect:/aprvForm/edit?formNo=" + aprvFormDto.getFormNo() + "&error=invalid_head";
		}

		// 2. 찾아온 외래키 번호를 세팅
		aprvFormDto.setFormHeadNo(headNo);

		// 3. 사용 여부 체크박스에 반영
		aprvFormDto.setFormUseYn(aprvFormDto.getFormUseYn() != null ? "Y" : "N");

		// 4. 본문 텍스트 데이터 수정
		aprvFormDao.update(aprvFormDto);

		// 5. 파일 교체 로직 (파일이 실제로 첨부됐을 때만 실행)
		if (attach != null && !attach.isEmpty()) {
			aprvFormService.modifyFile(aprvFormDto, attachDto, attach);
		}

		return "redirect:/aprvForm/detail?formNo=" + aprvFormDto.getFormNo(); // 수정 완료 후 상세 페이지로 이동
	}

	@GetMapping("/delete")
	public String delete(@RequestParam int formNo,HttpSession session) throws IllegalStateException, IOException {
		
		String loginId = (String)session.getAttribute("loginId");
		
		EmpDto findEmpDto = new EmpDto();
		findEmpDto = empDao.selectOne(loginId);
		if(findEmpDto == null || findEmpDto.getEmpGrade()<1) {
			return "redirect:/error/403";
		}
		
		
		try {
			Integer attachNo = aprvFormDao.findAttachNo(formNo);
			if (attachNo != null && attachNo > 0) {
				AprvFormDto aprvFormDto = new AprvFormDto();
				aprvFormDto.setFormNo(formNo);

				AttachDto attachDto = new AttachDto();
				attachDto.setAttachNo(attachNo);

				aprvFormService.deleteFile(aprvFormDto, attachNo);

			}
			aprvFormDao.delete(formNo);
		}

		catch (TargetNotfoundException e) {
			return "redirect:/error/403";
		}

		return "redirect:/aprvForm/list";
	}

}
