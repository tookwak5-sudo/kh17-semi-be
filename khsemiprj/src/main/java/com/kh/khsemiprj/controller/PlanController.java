package com.kh.khsemiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.khsemiprj.dao.AprvHeadDao;
import com.kh.khsemiprj.dao.EmpPositionDeptDao;
import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.dto.AprvHeadDto;
import com.kh.khsemiprj.dto.PlanDto;
import com.kh.khsemiprj.vo.PageForPlanVO;
import com.kh.khsemiprj.vo.PlanEmpDeptVO;

import jakarta.servlet.http.HttpSession;


@Controller
@RequestMapping("/plan")
public class PlanController {
	
	@Autowired
	private PlanDao planDao;
	@Autowired
	private AprvHeadDao aprvHeadDao;
	@Autowired
	private EmpPositionDeptDao empPositionDeptDao;

	@RequestMapping("/list")
	public String list(HttpSession session,Model model, @ModelAttribute PageForPlanVO pageVO) {
		String loginId = (String)session.getAttribute("loginId");
		
		if ("null".equals(pageVO.getPlanSdate())) {
			pageVO.setPlanSdate(""); 
		}
		if ("null".equals(pageVO.getPlanEdate())) {
			pageVO.setPlanEdate(""); 
		}
		
	    int count = planDao.count(pageVO, loginId);
	    pageVO.setCount(count);
	    model.addAttribute("pageVO", pageVO);
	    
	   
	    List<PlanEmpDeptVO> planList = planDao.selectList(pageVO, loginId);
	    model.addAttribute("planList", planList); 
	    
	    return "plan/list"; 
	}
	
	// 등록
		// 유형 및 헤더 목록을 가져오는 메서드 추가
	    @GetMapping("/write")
	    public String write(Model model) {
	    	List<AprvHeadDto> headList = aprvHeadDao.selectListNormal();
	    	model.addAttribute("headList", headList);
	    	
	    	return "plan/write";
	    }
	    
		@PostMapping("/write")
		public String write(@ModelAttribute PlanDto planDto, HttpSession session) {
		
			int planNo = planDao.sequence();
			// 로그인 여부 확인
			String loginId = (String) session.getAttribute("loginId");
			Long deptNo = empPositionDeptDao.selectDeptbyId(loginId);
			
			planDto.setPlanDeptNo(deptNo);
			planDto.setPlanNo(planNo);
			planDto.setPlanEmpId(loginId);
			planDao.insert(planDto);
			
			return "redirect:/plan/list";
		}
}
