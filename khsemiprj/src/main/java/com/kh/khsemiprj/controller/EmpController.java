package com.kh.khsemiprj.controller;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.kh.khsemiprj.dao.CertDao;
import com.kh.khsemiprj.dao.EmpDao;
import com.kh.khsemiprj.dto.CertDto;
import com.kh.khsemiprj.dto.EmpDto;
import com.kh.khsemiprj.exception.GetOutException;
import com.kh.khsemiprj.exception.WhoAreYouException;
import com.kh.khsemiprj.service.AttachService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/emp")
public class EmpController {
	
	@Autowired
	private EmpDao empDao;
	
	@Autowired
	private CertDao certDao;
	
	@Autowired
	private AttachService attachService;
	
	@GetMapping("/login")
	public String login() {
		return "emp/login";
	}
	
	@PostMapping("/login")
	public String login(@ModelAttribute EmpDto empDto
							, HttpSession session//세션을 사용하겠다고 요청
							, HttpServletRequest request//요청 정보를 모두 가져오기
							) {
		
		//로그인 시도
		EmpDto findEmpDto = empDao.selectOne(empDto.getEmpId());
		if(findEmpDto == null) {
			return "redirect:./login?error";
		}
		
		if(!findEmpDto.getEmpPassword().equals(empDto.getEmpPassword())) {
			return "redirect:./login?error";
		}
		
		// 이 회원의 승인 상태가 상태가 N이라면
		if(findEmpDto.getEmpValid().equals("N")) {
			return "redirect:./login?valid";
		}
		
		// 퇴사 회원이라면
//		if(findEmpDto.isExit()) {
//			return "redirect:./login?exit";
//		}
		
		//- 현재시간을 생성(완벽하게 동일한 시간으로 설정해야 할 경우 자바에서 시간을 생성해서 양측에 추가)
		//Timestamp now = Timestamp.valueOf(LocalDateTime.now());
		//- 로그인시간을 갱신
		//empDao.updateMemberLogin(findEmpDto.getEmpId());
		//- 로그인 이력 생성
//		EmpHistoryDto empHistoryDto = new EmpHistoryDto();
//		empHistoryDto.setMemberHistoryOrigin(findEmpDto.getEmpId());//아이디
//		empHistoryDto.setMemberHistoryAddress(request.getRemoteAddr());//IP
//		empHistoryDto.setMemberHistoryAgent(request.getHeader("User-Agent"));//Agent
//		empHistoryDao.insert(empHistoryDto);
		
		//- 세션(HttpSession)에 로그인 되었음을 표시
		session.setAttribute("loginId", findEmpDto.getEmpId());
		
		// loginLevel 
		// - 1. 관리자 테이블 조회 후 존재 시 → loginLevel = 2로 설정
		// - 2. 부서테이블의 부서장 조회 후 존재 시 → loginLevel = 1로 설정
		// - 3. 1~2 단계 진행 후 조회 안될 시 → loginLevel = 0
		session.setAttribute("empGrade", findEmpDto.getEmpGrade());
		
		// 비밀번호 변경한 시간을 비교해서 일정기간 이상이면 비밀번호 변경 안내 페이지로 리다이렉트
//		Timestamp last = findEmpDto.getEmpChange();
//		if(last == null) {
//			last = findEmpDto.getEmpValidDate();
//		}
//		LocalDateTime lastChange = last.toLocalDateTime();
//		LocalDateTime current = LocalDateTime.now();
//		Duration duration = Duration.between(lastChange, current);
//		if(duration.toDays() >= 30) {
//			return "redirect:./notice";
//		}
		
		return "redirect:/";
	}
	

	@GetMapping("/join")
	public String join() {
		return "emp/join";
	}
	@PostMapping("/join")
	public String join(@ModelAttribute EmpDto empDto, @RequestParam MultipartFile attach)throws IllegalStateException, IOException {
		empDao.join(empDto);
		//프로필이 있으면 추가 등록 및 연결
				if(!attach.isEmpty()) {
					int attachNo = attachService.save(attach);
					empDao.connect(empDto.getEmpId(), attachNo);
				}
				
				return "redirect:./joinFinish";
	}
	@RequestMapping("/joinFinish")
	public String joinFinish() {
		return "emp/joinFinish";
	}

	//아이디 찾기 페이지
	@GetMapping("/findId")
	public String findId() {
		return "emp/findId";
	}
	
	@PostMapping("/findId")
	public String findId(@RequestParam String empName,
					@RequestParam String empEmail,
						Model model){
		EmpDto empDto = empDao.selectId(empName, empEmail);
		
		if(empDto == null) {
			// 일치하는 회원이 없었을때 
			return "redirect:./findId?error";
		}
		else {
			model.addAttribute("empId", empDto.getEmpId());
			return "emp/findIdResult";
		}
		
	}
	
	//비밀번호 찾기 페이지
	@GetMapping("/findPassword")
	public String findPassword() {
		return "emp/findPassword";
	}
	
	@PostMapping("/findPassword")
	public String findPassword(@RequestParam String empId,@RequestParam String empName,
			@RequestParam String empEmail,  Model model) {
		EmpDto empDto = empDao.selectPassword(empId, empName, empEmail);
		
		if(empDto == null) {
			//일치하는 회원이 없었을때
			return "redirect:./findPassword?error";
		}
		else {
			model.addAttribute("empPassword", empDto.getEmpPassword());
			return "emp/findPasswordResult";
		}
	}

	//이메일 인증 완료 페이지
	@GetMapping("/cert")
	public String cert(@ModelAttribute CertDto certDto) {
		
		//1. 정보가 있는지 확인
		CertDto findDto = certDao.selectOne(certDto.getCertEmail());
		if(findDto == null) throw new WhoAreYouException();
		
		//2. 번호가 맞는지 확인
		boolean valid = certDto.getCertNumber().equals(findDto.getCertNumber());
		if(valid == false) throw new GetOutException();
		
		//3. 시간이 유효한지 확인
		LocalDateTime current = LocalDateTime.now();//현재시각
		LocalDateTime sent = findDto.getCertTime().toLocalDateTime();//발송시각
		Duration duration = Duration.between(sent, current);
		if(duration.toMinutes() > 10) {//10분이 지났어?
			throw new GetOutException();
		}
		
		//4. 인증 가능한 상태인지 확인 (cert_yn = 'N')
		if(findDto.getCertYn().equals("Y")) {
			throw new GetOutException();
		}
		
		certDao.delete(certDto.getCertEmail());//인증기록 삭제
		return "member/cert";
	}
	

}
