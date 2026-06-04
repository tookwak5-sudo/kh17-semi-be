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

import com.kh.khsemiprj.dto.AprvFormDto;
import com.kh.khsemiprj.dto.AttachDto;
import com.kh.khsemiprj.service.AprvFormService;
import com.kh.khsemiprj.vo.PageVO;

@Controller
@RequestMapping("/aprvForm")
public class AprvFormController {

	@Autowired
	private AprvFormService aprvFormService;

	@Autowired
	private AprvFormDao aprvFormDao;

	

	// 1. 결재 양식 목록 조회
	@GetMapping("/list")
	public String list(@ModelAttribute PageVO pageVO, Model model) {
		List<AprvFormDto> list = aprvFormDao.selectList(pageVO);
		model.addAttribute("list", list);
		return "aprvForm/list";
	}

	// 2. 결재 양식 상세 보기
	@GetMapping("/detail")
	public String detail(@RequestParam int formNo, Model model) {
		AprvFormDto aprvFormDto = aprvFormDao.selectOne(formNo);
		model.addAttribute("formDto", aprvFormDto);
		return "aprvForm/detail";
	}

	// 3. 결재 양식 신규 등록 페이지 열기
	@GetMapping("/insert")
	public String insert() {
		return "aprvForm/insert";
	}

	// 4. 결재 양식 신규 등록 처리 (텍스트 + 파일)
	@PostMapping("/insert")
	public String insert(@ModelAttribute AprvFormDto aprvFormDto, @RequestParam(required = false) MultipartFile attach)
			throws IllegalStateException, IOException {
		
		aprvFormDao.insertForm(aprvFormDto);
		aprvFormService.registerFormFile(aprvFormDto, attach);

		return "redirect:aprvForm/list";
	}

	// 5. 결재 양식 수정 페이지 열기
	@GetMapping("/edit")
	public String edit(@RequestParam int formNo, Model model) {
		AprvFormDto aprvFormDto = aprvFormDao.selectOne(formNo);
		model.addAttribute("formDto", aprvFormDto);
		return "aprvForm/edit";
	}

	// 6. 결재 양식 및 파일 수정 처리
	@PostMapping("/edit")
	public String edit(@ModelAttribute AprvFormDto aprvFormDto, @ModelAttribute AttachDto attachDto,
			@RequestParam(required = false) MultipartFile attach) throws IllegalStateException, IOException {

		// 1. 본문 텍스트 데이터 수정
		aprvFormDao.update(aprvFormDto);

		// 2. 파일 교체 로직
		aprvFormService.modifyFile(aprvFormDto, attachDto, attach);

		return "redirect:aprvForm/detail?formNo=" + aprvFormDto.getFormNo(); // 수정 완료 후 상세 페이지로 이동
	}

	@GetMapping("/delete")
	public String delete(@RequestParam int formNo, @RequestParam int attachNo)
			throws IllegalStateException, IOException {

		AprvFormDto aprvFormDto = new AprvFormDto();
		aprvFormDto.setFormNo(formNo);

		AttachDto attachDto = new AttachDto();
		attachDto.setAttachNo(attachNo);

		aprvFormService.deleteFile(aprvFormDto, attachDto);
		aprvFormDao.delete(formNo);

		return "redirect:aprvForm/deleteFinish";
	}

}
