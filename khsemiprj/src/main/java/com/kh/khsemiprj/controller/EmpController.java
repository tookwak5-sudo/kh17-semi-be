package com.kh.khsemiprj.controller;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
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

import com.kh.khsemiprj.dao.CertDao;
import com.kh.khsemiprj.dao.EmpDao;
import com.kh.khsemiprj.dao.EmpExitDao;
import com.kh.khsemiprj.dao.EmpLeaveDao;
import com.kh.khsemiprj.dao.EmpPositionDeptDao;
import com.kh.khsemiprj.dao.LogAccessDao;
import com.kh.khsemiprj.dao.LogInoutDao;
import com.kh.khsemiprj.dao.MemoDao;
import com.kh.khsemiprj.dto.CertDto;
import com.kh.khsemiprj.dto.EmpDto;
import com.kh.khsemiprj.dto.EmpExitDto;
import com.kh.khsemiprj.dto.EmpLeaveDto;
import com.kh.khsemiprj.dto.LogAccessDto;
import com.kh.khsemiprj.dto.LogInoutDto;
import com.kh.khsemiprj.dto.MemoDto;
import com.kh.khsemiprj.exception.GetOutException;
import com.kh.khsemiprj.exception.WhoAreYouException;
import com.kh.khsemiprj.service.AttachService;
import com.kh.khsemiprj.vo.EmpPositionDeptVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/emp")
public class EmpController {

	@Autowired
	private EmpDao empDao;

	@Autowired
	private EmpExitDao empExitDao;

	@Autowired
	private CertDao certDao;

	@Autowired
	private EmpLeaveDao empLeaveDao;

	@Autowired
	private AttachService attachService;

	@Autowired
	private LogInoutDao logInoutDao;

	@Autowired
	private LogAccessDao logAccessDao;
	@Autowired
	private EmpPositionDeptDao empPositionDemptDao;

	@Autowired
	private MemoDao memoDao;
	
	@GetMapping("/login")
	public String login() {
		return "emp/login";
	}

	@PostMapping("/login")

	public String login(@ModelAttribute EmpDto empDto, HttpSession session// 세션을 사용하겠다고 요청
			, HttpServletRequest request// 요청 정보를 모두 가져오기
	) {

		// [1] 사용자가 입력한 아이디를 이용하여 DB에 대상이 있는 지를 조회

		EmpDto findEmpDto = empDao.selectOne(empDto.getEmpId());
		if (findEmpDto == null) {
			return "redirect:./login?error";
		}

		// [2] 비밀번호 확인
		if (!findEmpDto.getEmpPassword().equals(empDto.getEmpPassword())) {

			return "redirect:./login?error";
		}

		// 이 회원의 승인 상태가 상태가 N이라면
		if (findEmpDto.getEmpValid().equals("N")) {
			return "redirect:./login?valid";
		}

		// 퇴사 회원이라면
		EmpExitDto empExitDto = empExitDao.selectOne(empDto.getEmpId());
		if (empExitDto != null && empExitDto.isExit()) {
			return "redirect:./login?exit";
		}

		// - 현재시간을 생성(완벽하게 동일한 시간으로 설정해야 할 경우 자바에서 시간을 생성해서 양측에 추가)
		// Timestamp now = Timestamp.valueOf(LocalDateTime.now());
		// - 로그인시간을 갱신
		// empDao.updateMemberLogin(findEmpDto.getEmpId());
		// - 로그인 이력 생성
//		EmpHistoryDto empHistoryDto = new EmpHistoryDto();
//		empHistoryDto.setMemberHistoryOrigin(findEmpDto.getEmpId());//아이디
//		empHistoryDto.setMemberHistoryAddress(request.getRemoteAddr());//IP
//		empHistoryDto.setMemberHistoryAgent(request.getHeader("User-Agent"));//Agent
//		empHistoryDao.insert(empHistoryDto);

		// - 세션(HttpSession)에 로그인 되었음을 표시
		session.setAttribute("loginId", findEmpDto.getEmpId());

		// loginLevel
		// - 1. 관리자 테이블 조회 후 존재 시 → loginLevel = 2로 설정
		// - 2. 부서테이블의 부서장 조회 후 존재 시 → loginLevel = 1로 설정
		// - 3. 1~2 단계 진행 후 조회 안될 시 → loginLevel = 0
		session.setAttribute("empGrade", findEmpDto.getEmpGrade());
		
		// 직책 
		EmpPositionDeptVO empPositionDeptVO = empPositionDemptDao.selectDeptPositionbyId(empDto.getEmpId());
		session.setAttribute("empPosition", empPositionDeptVO.getEmpPositionName());
		session.setAttribute("empDept", empPositionDeptVO.getDeptName());
		
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

		// 목표: 로그인과 동시에 직원 출근처리
		LogInoutDto logInoutDto = new LogInoutDto();
		logInoutDto.setLogInoutEmpId(empDto.getEmpId());
		logInoutDto.setLogInoutType("출근");
		logInoutDao.insert(logInoutDto);
		return "redirect:/";
	}

	// 로그아웃(
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		session.removeAttribute("loginId");
		session.removeAttribute("empGrade");

		return "redirect:/emp/login";
	}

	// 목표 출근버튼을 누르면 출근 처리
	@PostMapping("/work-in")
	public String workIn(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");

		// 아이디를 조회해서 출퇴근 여부 확인
		LogInoutDto logInoutDto = logInoutDao.getLastType(loginId);

		// 출근 상태라면 상태변화x
		if (logInoutDto != null && "출근".equals(logInoutDto.getLogInoutType().trim())) {
			return "redirect:/?workIn";
		}

		LogInoutDto newDto = new LogInoutDto();
		newDto.setLogInoutEmpId(loginId);
		newDto.setLogInoutType("출근");
		logInoutDao.insert(newDto);

		// [추가] 세션에 상태 저장
		session.setAttribute("logInoutType", "퇴근");

		return "redirect:/";
	}

	// 목표 퇴근 버튼을 누르면 퇴근 처리
	@PostMapping("/work-out")
	public String workOut(HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");

		// 아이디를 조회해서 출퇴근 여부 확인
		LogInoutDto logInoutDto = logInoutDao.getLastType(loginId);
		// 퇴근 상태라면 상태변화x
		if (logInoutDto != null && "퇴근".equals(logInoutDto.getLogInoutType().trim())) {
			return "redirect:/?workOut";
		}
		// 출근 상태라면
		LogInoutDto newDto = new LogInoutDto();
		newDto.setLogInoutEmpId(loginId);
		newDto.setLogInoutType("퇴근");
		logInoutDao.insert(newDto);

		// [추가] 세션에 상태 저장
		session.setAttribute("logInoutType", "출근");

		return "redirect:/";
	}

	// 로그아웃 및 퇴근
	@RequestMapping("/logoutOut")
	public String logoutOut(HttpSession session) {
		// [1] 세션을 지우기 전에 현재 로그인 ID를 먼저 확보해야 합니다
		String loginId = (String) session.getAttribute("loginId");

		if (loginId != null) {
			// [2] 마지막 상태 확인
			LogInoutDto logInoutDto = logInoutDao.getLastType(loginId);

			// 출근 상태인 경우에만 퇴근 처리
			if (logInoutDto != null && "출근".equals(logInoutDto.getLogInoutType().trim())) {
				LogInoutDto newDto = new LogInoutDto();
				newDto.setLogInoutEmpId(loginId);
				newDto.setLogInoutType("퇴근");
				logInoutDao.insert(newDto);
			}
		}

		// [3] 세션제거
		session.removeAttribute("loginId");
		session.removeAttribute("empGrade");

		return "redirect:/emp/login";
	}

	// 회원가입

	@GetMapping("/join")
	public String join() {
		return "emp/join";
	}

	@PostMapping("/join")
	public String join(@ModelAttribute EmpDto empDto, @RequestParam MultipartFile attach)
			throws IllegalStateException, IOException {

		// 회원가입 정보 등록
		empDao.join(empDto);

		// 프로필이 있으면 추가 등록 및 연결
		if (!attach.isEmpty()) {
			int attachNo = attachService.save(attach);
			empDao.connect(empDto.getEmpId(), attachNo);
		}
		
		List<EmpDto> adminList = empDao.selectAdminList();
		for(int i = 0; i < adminList.size(); i++) {			
			MemoDto memoDto = MemoDto.builder()
					.memoNo(memoDao.sequence())
					.memoReceiverId(adminList.get(i).getEmpId())
					.memoSenderId("system")
					.memoTitle("신규 사원 등록 알림")
					.memoContent("<a href='/admin/emp/list' class='btn btn-positive' target='_blank'>사원 관리 확인</a>")
					.memoReadStatus("N")
					.memoType("일반")
					.build();
			memoDao.insert(memoDto);
		}
		
		return "redirect:/emp/login?alarm=join";
	}

	// 아이디 찾기 페이지
	@GetMapping("/findId")
	public String findId() {
		return "emp/findId";
	}

	@PostMapping("/findId")
	public String findId(@RequestParam String empName, @RequestParam String empEmail, Model model) {
		EmpDto empDto = empDao.selectId(empName, empEmail);

		if (empDto == null) {
			// 일치하는 회원이 없었을때
			return "redirect:./findId?error";
		} else {
			model.addAttribute("empId", empDto.getEmpId());
			return "emp/findIdResult";
		}

	}

	// 비밀번호 찾기 페이지
	@GetMapping("/findPassword")
	public String findPassword() {
		return "emp/findPassword";
	}

	@PostMapping("/findPassword")
	public String findPassword(@RequestParam String empId, @RequestParam String empName, @RequestParam String empEmail,
			Model model) {
		EmpDto empDto = empDao.selectPassword(empId, empName, empEmail);

		if (empDto == null) {
			// 일치하는 회원이 없었을때
			return "redirect:./findPassword?error";
		} else {
			model.addAttribute("empPassword", empDto.getEmpPassword());
			return "emp/findPasswordResult";
		}
	}

	// 이메일 인증 완료 페이지
	@GetMapping("/cert")
	public String cert(@ModelAttribute CertDto certDto) {

		// 1. 정보가 있는지 확인
		CertDto findDto = certDao.selectOne(certDto.getCertEmail());
		if (findDto == null)
			throw new WhoAreYouException();

		// 2. 번호가 맞는지 확인
		boolean valid = certDto.getCertNumber().equals(findDto.getCertNumber());
		if (valid == false)
			throw new GetOutException();

		// 3. 시간이 유효한지 확인
		LocalDateTime current = LocalDateTime.now();// 현재시각
		LocalDateTime sent = findDto.getCertTime().toLocalDateTime();// 발송시각
		Duration duration = Duration.between(sent, current);
		if (duration.toMinutes() > 10) {// 10분이 지났어?
			throw new GetOutException();
		}

		// 4. 인증 가능한 상태인지 확인 (cert_yn = 'N')
		if (findDto.getCertYn().equals("Y")) {
			throw new GetOutException();
		}

		certDao.delete(certDto.getCertEmail());// 인증기록 삭제
		return "emp/cert";

	}

	@RequestMapping("/mypage")
	public String mypage(HttpSession session, Model model) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {

			return "redirect:./login";

		}
		EmpDto findEmpDto = empDao.selectOne(loginId);

		if (findEmpDto == null)
			return "redirect:./login";
		model.addAttribute("findEmpDto", findEmpDto);

		try {
			int profileAttachNo = empDao.searchProfile(loginId);
			System.out.println("가져온 프사번호: " + profileAttachNo);
			model.addAttribute("profileAttachNo", profileAttachNo);
		} catch (Exception e) {
			// 프로필 사진이 없으면 번호를 안 넘김
		}

		// 근태 로그 및 로그인 로그 필요.

		List<EmpLeaveDto> empLeaveList = empLeaveDao.selectList(loginId);

		model.addAttribute("empLeaveList", empLeaveList);

		LogAccessDto lastAccess = logAccessDao.getLastAccess(loginId);
		model.addAttribute("lastAccess", lastAccess);

		LogInoutDto lastLogIn = logInoutDao.getLastLogin(loginId);
		model.addAttribute("lastLogIn", lastLogIn);

		return "emp/mypage";
	}

	@GetMapping("/checkPassword")
	public String checkPassword(HttpSession session, @ModelAttribute EmpDto empDto) {
		String loginId = (String) session.getAttribute("loginId");

		if (loginId == null) {
			return "redirect:./login";
		}

		EmpDto findEmpDto = empDao.selectOne(loginId);
		if (findEmpDto == null) {
			return "redirect:./login";

		}
		return "emp/checkPassword";

	}

	// 내 정보 수정 전 비밀번호 확인 페이지
	@PostMapping("/checkPassword")
	public String checkPassword(HttpSession session, @ModelAttribute EmpDto empDto, @RequestParam String empPassword) {

		String loginId = (String) session.getAttribute("loginId");

		if (loginId == null) {
			return "redirect:./login";
		}
		EmpDto findEmpDto = empDao.selectOne(loginId);
		if (findEmpDto == null) {
			return "redirect:./login";
		}
		boolean isValid = findEmpDto.getEmpPassword().equals(empDto.getEmpPassword());
		if (!isValid) {
			return "redirect:./checkPassword?error";
		}

		return "redirect:/emp/edit";

	}

	// 비밀번호 바꾸는 페이지 겟매핑
	@GetMapping("/changePassword")
	public String changePassword(HttpSession session, @ModelAttribute EmpDto empDto) {
		String loginId = (String) session.getAttribute("loginId");

		if (loginId == null) {
			return "redirect:./login";
		}

		EmpDto findEmpDto = empDao.selectOne(loginId);
		if (findEmpDto == null) {
			return "redirect:./login";

		}
		return "emp/changePassword";

	}

	// 비밀번호 바꾸는 페이지
	@PostMapping("/changePassword")
	public String changePassword(HttpSession session, @ModelAttribute EmpDto empDto, @RequestParam String newPassword) {

		String loginId = (String) session.getAttribute("loginId");

		if (loginId == null) {
			return "redirect:./login";
		}
		EmpDto findEmpDto = empDao.selectOne(loginId);
		if (findEmpDto == null) {
			return "redirect:./login";
		}
		boolean isValid = findEmpDto.getEmpPassword().equals(empDto.getEmpPassword());
		if (!isValid) {
			return "redirect:./changePassword?error";
		}

		empDto.setEmpId(loginId);
		empDto.setEmpPassword(newPassword);
		empDao.changePassword(empDto);

		return "redirect:/emp/mypage";

	}

	// 내 정보 수정의 겟 매핑
	@GetMapping("/edit")
	public String edit(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		EmpDto empDto = empDao.selectOne(loginId);
		if (empDto == null) {
			return "redirect:./login";
		}
		model.addAttribute("empDto", empDto);
		
		try {
	        int profileAttachNo = empDao.searchProfile(loginId);
	        model.addAttribute("profileAttachNo", profileAttachNo);
	    } catch (Exception e) {
	        
	    }
		return "emp/edit";
	}

	// edit 포스트 매핑

	@PostMapping("/edit")
	public String edit(HttpSession session, @ModelAttribute EmpDto empDto,
			@RequestParam(required = false) MultipartFile attach, 
			@RequestParam(defaultValue = "N") String deleteProfileFlag) throws IllegalStateException, IOException {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			return "redirect:./login";
		}

		EmpDto findEmpDto = empDao.selectOne(loginId);
		// 빈 칸 입력시 세터로 팅기는거 막아줬습니다.
		if (empDto.getEmpEmail() == null || empDto.getEmpEmail().isEmpty()) {

			empDto.setEmpEmail(findEmpDto.getEmpEmail());
		}

		if (empDto.getEmpContact() == null || empDto.getEmpContact().isEmpty()) {

			empDto.setEmpContact(findEmpDto.getEmpContact());
		}

		if (empDto.getEmpBirth() == null || empDto.getEmpBirth().isEmpty()) {

			empDto.setEmpBirth(findEmpDto.getEmpBirth());
		}

		if (empDto.getEmpBirth() == null || empDto.getEmpBirth().isEmpty()) {

			empDto.setEmpBirth(findEmpDto.getEmpBirth());
		}

		if (empDto.getEmpPost() == null || empDto.getEmpPost().isEmpty()) {

			empDto.setEmpPost(findEmpDto.getEmpPost());
		}

		if (empDto.getEmpAddress1() == null || empDto.getEmpAddress1().isEmpty()) {

			empDto.setEmpAddress1(findEmpDto.getEmpAddress1());
		}

		if (empDto.getEmpAddress2() == null || empDto.getEmpAddress2().isEmpty()) {

			empDto.setEmpAddress2(findEmpDto.getEmpAddress2());
		}

		empDto.setEmpId(loginId);
		empDao.update(empDto);

		// 프로필 교체 작업 (중복 제거 및 로직 통합)
	    if (attach != null && !attach.isEmpty()) {
	        // 1. 기존 프사 지우기
	        try {
	            int oldAttachNo = empDao.searchProfile(loginId);
	            empDao.deleteProfile(loginId); // DB에서 프로필 연결 끊기
	            attachService.delete(oldAttachNo); // 물리적 파일 및 첨부파일 테이블 기록 삭제
	        } catch (Exception e) {
	            // 기존 프사 없으면 예외 발생하니까 무시하고 진행
	        }

	        // 2. 새 프사 등록 및 연결
	        int newAttachNo = attachService.save(attach);
	        empDao.connect(loginId, newAttachNo);
	    }
	    
	    else if ("Y".equals(deleteProfileFlag)) {
			try {
				int oldAttachNo = empDao.searchProfile(loginId);
				empDao.deleteProfile(loginId); // DB 관계 끊기
				attachService.delete(oldAttachNo); // 물리 파일 + attach 테이블 레코드 완전 삭제
			} catch (Exception e) {
				// 기존 프사가 원래 없었으면 패스
			}
		}
		return "redirect:./mypage";
	}

	// 프로필 매핑
	@RequestMapping("/profile")
	public String profile(@RequestParam String empId) {
		try {
			int attachNo = empDao.searchProfile(empId);
			return "redirect:/download/modern?attachNo=" + attachNo;
		} catch (Exception e) {
			return "redirect:/images/no_image.png";
		}
	}

	@RequestMapping("/removeProfile")
	public String removeProfile(HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");

		if (loginId == null) {
			return "redirect:/login";
		}

		try {

			int attachNo = empDao.searchProfile(loginId);

			empDao.deleteProfile(loginId);

			attachService.delete(attachNo);

		} catch (Exception e) {
			// 프사가 애초에 없었거나 에러 터져도 티 안 내고 스무스하게 넘어감
		}

		return "redirect:./mypage";
	}

}
