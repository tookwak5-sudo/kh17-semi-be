package com.kh.khsemiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.khsemiprj.dao.AprvHeadDao;
import com.kh.khsemiprj.dao.EmpPositionDeptDao;
import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.dto.AprvHeadDto;
import com.kh.khsemiprj.dto.HeadDto;
import com.kh.khsemiprj.dto.PlanDto;
import com.kh.khsemiprj.exception.GetOutException;
import com.kh.khsemiprj.exception.TargetNotfoundException;
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
	public String list(HttpSession session, Model model, @ModelAttribute PageForPlanVO pageVO) {
	    String loginId = (String) session.getAttribute("loginId");
	    
	    // 1. 파라미터 null 처리 (기존 유지)
	    if ("null".equals(pageVO.getPlanSdate())) pageVO.setPlanSdate(""); 
	    if ("null".equals(pageVO.getPlanEdate())) pageVO.setPlanEdate(""); 
	    
	    // 2. 개수 조회 (이제 내부적으로 조인이 포함되어 있음)
	    int count = planDao.count(pageVO, loginId);
	    pageVO.setCount(count);
	    model.addAttribute("pageVO", pageVO);
	    
	    // 3. 일정 리스트 조회 (이제 각 planDto마다 headType이 채워져서 옴)
	    List<PlanEmpDeptVO> planList = planDao.selectList(pageVO, loginId);
	    model.addAttribute("planList", planList); 
	    
	    // 4. 불필요한 model.addAttribute("planHead", planHead); 삭제!
	    
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
		
		@RequestMapping("/delete")
		public String delete(HttpSession session, @RequestParam int planNo) {
			String loginId = (String) session.getAttribute("loginId");
			PlanDto planDto = planDao.selectOne(planNo);
			
			if(planDto == null) throw new TargetNotfoundException("존재하지 않는 일정");
			
			if(!loginId.equals(planDto.getPlanEmpId())) {
				throw new GetOutException("내가 쓴 일정만 삭제 할 수 있습니다."); 
			}
			
			planDao.delete(planNo);
			return "redirect:./list?alarm=planDelete";
		}
		
		//수정 매핑
		@GetMapping("/edit")
		public String edit(@RequestParam int planNo, Model model, HttpSession session) {
			PlanDto planDto = planDao.selectOne(planNo);
			if(planDto == null) throw new TargetNotfoundException("존재하지 않는 일정");
			String loginId = (String)session.getAttribute("loginId");
			if(!planDto.getPlanEmpId().equals(loginId)) {
				throw new GetOutException("작성자만 수정할 수 있습니다");
			}
			
			List<HeadDto> planHead = planDao.selectListHead();
			model.addAttribute("planHead", planHead);
			model.addAttribute("planDto", planDto);
			return "plan/edit";
		}
		
		@PostMapping("/edit")
		public String edit(@ModelAttribute PlanDto planDto, HttpSession session) {
			// 세션의 로그인 아이디 가져오기
		    String loginId = (String)session.getAttribute("loginId");
		    
		    // DB에서 원본 데이터를 다시 조회해서 작성자 일치 여부 확인 (필수)
		    PlanDto originDto = planDao.selectOne(planDto.getPlanNo());
		    if(!originDto.getPlanEmpId().equals(loginId)) {
		        throw new GetOutException("권한이 없습니다.");
		    }
			
			planDao.update(planDto);
			return "redirect:/plan/list?alarm=planEdit";
		}
}
