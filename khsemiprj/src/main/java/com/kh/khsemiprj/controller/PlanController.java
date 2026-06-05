package com.kh.khsemiprj.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.dto.PlanDto;
import com.kh.khsemiprj.exception.GetOutException;
import com.kh.khsemiprj.exception.TargetNotfoundException;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/plan")
public class PlanController {
	@Autowired
	private PlanDao planDao;
	
	//상세매핑
	@RequestMapping("/detail")
	public String detail(@RequestParam int planNo, Model model) {
		PlanDto planDto = planDao.selectOne(planNo);
		if(planDto ==  null) throw new TargetNotfoundException("존재하지 않는 일정입니다");
		model.addAttribute("planDto", planDto);
		
		return "plan/detail";
	}
	
	//등록 매핑
	@GetMapping("/write")
	public String write() {
		return "plan/write";
	}
	@PostMapping("/write")
	public String write(@ModelAttribute PlanDto planDto, HttpSession session) {
		//작성자 아이디 추출
		String loginId = (String)session.getAttribute("loginId");
		
		//세션을 통해 작성자 입력
		int planNo = planDao.sequence();
		
		// 시퀀스 번호 발급 후 DTO에 채우기
		planDto.setPlanNo(planNo);
		planDto.setPlanEmpId(loginId);
		
		planDao.insert(planDto);
		// 상세페이지로 리다이렉트
		return "redirect:./detail?planNo="+planDto.getPlanNo();
	}
	
	//삭제 매핑
	@RequestMapping("/delete")
	public String delete(@RequestParam int planNo, HttpSession session) {
		PlanDto planDto = planDao.selectOne(planNo);
		if(planDto == null) throw new TargetNotfoundException("존재하지 않는 일정입니다");
		
		planDao.delete(planNo);
		return "redirect:./list";
	}
	
	//수정 매핑
	 @GetMapping("/edit")
	 public String edit(@RequestParam int planNo, Model model) {
		 PlanDto planDto = planDao.selectOne(planNo);
		 if(planDto == null) throw new TargetNotfoundException("존재하지 않는 일정입니다");
		 
		 model.addAttribute("planDto", planDto);
		 return "plan/edit";
	 }
	 @PostMapping("/edit")
	 public String edit(@ModelAttribute PlanDto planDto, HttpSession session) {
		 String loginLevel = (String)session.getAttribute("loginLevel");
		 if("0".equals(loginLevel)) {
			 throw new GetOutException();
		 }
		 
		 PlanDto findPlanDto = planDao.selectOne(planDto.getPlanNo());
		 if(findPlanDto == null) throw new TargetNotfoundException("존재하지 않는 일정입니다");
		 
		 planDao.update(planDto);
		 return "redirect:./detail?planNo="+planDto.getPlanNo();
	 }
}
