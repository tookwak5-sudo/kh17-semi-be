package com.kh.khsemiprj.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.dto.PlanDto;

import jakarta.servlet.http.HttpSession;

//@CrossOrigin
@RestController
@RequestMapping("/rest/plan")
public class PlanRestController {
	@Autowired
	private PlanDao planDao;
	// 등록
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
		PlanDto planDto = planDao.selectOne(planNo);
		
		//[1] 관리자 확인
		
		//[2] 부서장 확인
		
		//[3] 작성자 확인
		//boolean owner = loginId != null && loginId.equals(planDto.getPlanEmpId());
		
		//작성자가 아니라면 -- 임시
		
		return planDto;
	}
	
	//삭제
	@PostMapping("/delete")
	public void delete(@RequestParam int planNo) {
		
		planDao.delete(planNo);
	}
		
	// 수정
	@PostMapping("/edit")
	public void edit(@ModelAttribute PlanDto planDto) {
		
		planDao.update(planDto);
	}

}
