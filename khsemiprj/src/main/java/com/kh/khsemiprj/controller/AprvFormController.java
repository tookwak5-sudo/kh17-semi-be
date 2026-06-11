package com.kh.khsemiprj.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

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
import com.kh.khsemiprj.dto.AprvFormDto;
import com.kh.khsemiprj.dto.AttachDto;
import com.kh.khsemiprj.exception.TargetNotfoundException;
import com.kh.khsemiprj.service.AprvFormService;
import com.kh.khsemiprj.vo.AprvFormHeadNameVO;
import com.kh.khsemiprj.vo.AprvFormHeadTypeVO;
import com.kh.khsemiprj.vo.AprvFormSelectVO;
import com.kh.khsemiprj.vo.PageVO;

@Controller
@RequestMapping("/aprvForm")
public class AprvFormController {

	@Autowired
	private AprvFormService aprvFormService;

	@Autowired
	private AprvFormDao aprvFormDao;

	private Set<String> excludeHeadNames = Set.of("일정","영웅");
	private Set<String> excludeTypeNames = Set.of("일반");
	
	// 1. 결재 양식 목록 조회
	@GetMapping("/list")
	public String list(@ModelAttribute PageVO pageVO, Model model) {
		List<AprvFormSelectVO> list = aprvFormDao.selectList(pageVO);
		model.addAttribute("list", list);
		return "aprvForm/list";
	}

	// 2. 결재 양식 상세 보기
	@GetMapping("/detail")
	public String detail(@RequestParam int formNo, Model model) {
		AprvFormSelectVO aprvFormSelectVO = aprvFormDao.selectOneUsingHead(formNo);
		Integer attachNo = aprvFormDao.findAttachNo(formNo);
		model.addAttribute("attachNo", attachNo);
		model.addAttribute("aprvFormSelectVO", aprvFormSelectVO);
		return "aprvForm/detail";
	}

	// 3. 결재 양식 신규 등록 페이지 열기
	@GetMapping("/insert")
	public String insert(Model model) {
		//일단 헤드네임 전부 가져오고
//		List<AprvFormHeadNameVO> filteredHeadList = aprvFormDao.selectFilteredHeadList();
//		List<AprvFormHeadTypeVO> filteredTypeList = aprvFormDao.selectFilteredTypeList();
		
//		model.addAttribute("headList", filteredHeadList);
//		model.addAttribute("typeList", filteredTypeList);
//		
	
		return "aprvForm/insert";
	}

	// 4. 결재 양식 신규 등록 처리 (텍스트 + 파일)
	@PostMapping("/insert")
	public String insert(Model model, @ModelAttribute AprvFormDto aprvFormDto, @RequestParam(required = false) MultipartFile attach)
			throws IllegalStateException, IOException {
		AprvFormDto findNameDto = aprvFormDao.selectOneByName(aprvFormDto.getFormName());
		
		if (findNameDto != null) {
			return "redirect:/aprvForm/insert?duplicate";
		}
		if (aprvFormDto.getFormUseYn() != null) {
			aprvFormDto.setFormUseYn("Y");
		}
		
		
		
	
		aprvFormService.registerFormFile(aprvFormDto, attach);

		return "redirect:./list";
	}

	// 5. 결재 양식 수정 페이지 열기
	@GetMapping("/edit")
	public String edit(@RequestParam int formNo, Model model) {
		try {
			
			AprvFormDto aprvFormDto = aprvFormDao.selectOne(formNo);
			model.addAttribute("aprvFormDto", aprvFormDto);
			
			AprvFormSelectVO findHeadName = aprvFormDao.selectOneUsingHead(formNo);
			model.addAttribute("findHeadName", findHeadName);
			
			AprvFormSelectVO findHeadType = aprvFormDao.selectOneUsingType(formNo);
			model.addAttribute("findHeadType", findHeadType);
			
			Integer attachNo = aprvFormDao.findAttachNo(formNo);
			model.addAttribute("attachNo", attachNo);
			
			List<AprvFormHeadNameVO> headList = aprvFormDao.selectOnlyHeadList();
			
			List<AprvFormHeadTypeVO> typeList = aprvFormDao.selectOnlyTypeList();
			
			//필터링 된 헤드네임 바구니
			List<AprvFormHeadNameVO> filteredHeadList = new ArrayList<>();
			
			//필터링 된 타입네임 바구니
			List<AprvFormHeadTypeVO> filteredTypeList = new ArrayList<>();
			
			//filtered~에 위에서 제외한 이름이 아니면 때려 넣고
				for(AprvFormHeadNameVO head : headList) {
					if(!excludeHeadNames.contains(head.getHeadName()))filteredHeadList.add(head);
					}
			
				for(AprvFormHeadTypeVO type : typeList) {
					if(!excludeTypeNames.contains(type.getHeadType())) {
					filteredTypeList.add(type);
					}
				}
			model.addAttribute("headList", filteredHeadList);
			model.addAttribute("typeList",filteredTypeList);			
			
			return "aprvForm/edit";
		
		
		}
		
		catch (TargetNotfoundException e) {
			return "redirect:/error/500";
		}
}

	// 6. 결재 양식 및 파일 수정 처리
	@PostMapping("/edit")
	public String edit(@ModelAttribute AprvFormDto aprvFormDto, @ModelAttribute AttachDto attachDto,
			@RequestParam(required = false) MultipartFile attach) throws IllegalStateException, IOException {
		
		// 1. 본문 텍스트 데이터 수정
		aprvFormDao.update(aprvFormDto);

		// 2. 파일 교체 로직
		aprvFormService.modifyFile(aprvFormDto, attachDto, attach);

		return "redirect:/aprvForm/detail?formNo=" + aprvFormDto.getFormNo(); // 수정 완료 후 상세 페이지로 이동
	}

	@GetMapping("/delete")
	public String delete(@RequestParam int formNo) throws IllegalStateException, IOException {
		try {
			Integer attachNo = aprvFormDao.findAttachNo(formNo);
			if (attachNo != null&& attachNo>0) {
				AprvFormDto aprvFormDto = new AprvFormDto();
				aprvFormDto.setFormNo(formNo);

				AttachDto attachDto = new AttachDto();
				attachDto.setAttachNo(attachNo);

				aprvFormService.deleteFile(aprvFormDto, attachNo);
				
			}
			aprvFormDao.delete(formNo);
		} 
		
		catch (TargetNotfoundException e) {
			return "redirect:/error/500";
		}
		
		return "redirect:/aprvForm/deleteFinish";
	}
	
	// 8. 결재 양식 삭제 완료 페이지 열기
	@GetMapping("/deleteFinish")
	public String deleteFinish() {
	   
	    return "aprvForm/deleteFinish"; 
	}
}
