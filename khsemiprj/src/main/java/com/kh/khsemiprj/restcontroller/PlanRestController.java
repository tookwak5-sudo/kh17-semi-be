	package com.kh.khsemiprj.restcontroller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.dto.PlanDto;
import com.kh.khsemiprj.service.PlanService;

import jakarta.servlet.http.HttpSession;

//@CrossOrigin
@RestController
@RequestMapping("/rest/plan")
public class PlanRestController {
	@Autowired
	private PlanDao planDao;
	@Autowired
	private PlanService planService;
	
	// 등록
	// 유형 및 헤더 목록을 가져오는 메서드 추가
    @GetMapping("/write")
    public List<PlanDto> getPlanList() {
        return planDao.selectListType();
    }
    
	@PostMapping("/write")
	public void write(@ModelAttribute PlanDto planDto, HttpSession session) {
	
		int planNo = planDao.sequence();
		// 로그인 여부 확인
		String loginId = (String) session.getAttribute("loginId");
		
		planDto.setPlanNo(planNo);
		
		planDto.setPlanEmpId(loginId);
		
		planDao.insert(planDto);
	}
	
	// 상세
	@PostMapping("/detail")
	public PlanDto detail(@RequestParam int planNo, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		return planService.getMyPlan(planNo, loginId);
	}
	
	//삭제
	@PostMapping("/delete")
	public void delete(@RequestParam int planNo, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		planService.getMyPlan(planNo, loginId);
		planDao.delete(planNo);
	}
		
	// 수정
	@PostMapping("/edit")
	public void edit(@ModelAttribute PlanDto planDto, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		
		planService.getMyPlan(planDto.getPlanNo(), loginId);
		planDao.update(planDto);
	}
}
