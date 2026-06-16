package com.kh.khsemiprj.restcontroller;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.khsemiprj.dao.AprvDao;
import com.kh.khsemiprj.dao.AprvFormDao;
import com.kh.khsemiprj.dao.AprvLineDao;
import com.kh.khsemiprj.dao.AttachDao;
import com.kh.khsemiprj.dao.EmpDao;
import com.kh.khsemiprj.dao.EmpLeaveDao;
import com.kh.khsemiprj.dao.MemoDao;
import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.dto.AprvFormDto;
import com.kh.khsemiprj.dto.AprvLineDto;
import com.kh.khsemiprj.dto.AttachDto;
import com.kh.khsemiprj.dto.EmpLeaveDto;
import com.kh.khsemiprj.dto.MemoDto;
import com.kh.khsemiprj.dto.PlanDto;
import com.kh.khsemiprj.vo.AprvDetailVO;
import com.kh.khsemiprj.vo.AprvLineListVO;
import com.kh.khsemiprj.vo.LeaveManageVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/rest/aprv")
public class AprvRestController {
	
	@Autowired
	private AprvDao aprvDao;
	
	@Autowired
	private AprvFormDao aprvFormDao;
	
	@Autowired
	private AprvLineDao aprvLineDao;
	
	@Autowired
	private EmpLeaveDao empLeaveDao;
	
	@Autowired
	private PlanDao planDao;
	
	@Autowired
	private EmpDao empDao;
	
	@Autowired
	private MemoDao memoDao;
	
	@Autowired
	private AttachDao attachDao;
	
	//일정 등록할 분류
	private Set<String> planHead = Set.of("연차", "병가", "비용", "기타");
	
	@RequestMapping("/getAprvFormFile")
	public Map<String, Object> getAprvFormFile(@RequestParam int formNo) {
		Map<String, Object> fileMap = new HashMap<>();
		try {
			AprvFormDto findAprvFormDto = aprvFormDao.selectOne(formNo);
			Integer attachNo = aprvFormDao.findAttachNo(formNo);
			
			AttachDto findAttachDto = attachNo == null ? null : attachDao.selectOne(attachNo);
			if (findAprvFormDto == null || findAttachDto == null) {
				fileMap.put("attachNo", "");
				fileMap.put("attachName", "");
				fileMap.put("result", "empty");
			} else {
				fileMap.put("attachNo", findAttachDto.getAttachNo());
				fileMap.put("attachName", findAttachDto.getAttachName());
				fileMap.put("result", "success");
			}
			return fileMap;
		} catch(Exception e) {
			e.printStackTrace();
			fileMap.put("attachNo", "");
			fileMap.put("attachName", "");
			fileMap.put("result", "error");
			
			return fileMap;
		}
	}
	
	@RequestMapping("/setAprvLineStatus")
	public Map<String, String> setAprvLineStatus(HttpServletRequest request, @ModelAttribute AprvLineDto aprvLineDto) {
		Map<String, String> result = new HashMap<>();
		
		HttpSession session = request.getSession();
		String loginId = (String)session.getAttribute("loginId");
		if(loginId != null && loginId != "") {
			//DB에서 현재 결재 라인의 정보 구해와서
			AprvLineListVO aprvLineVO = aprvLineDao.selectOne(aprvLineDto.getAprvLineNo());
			if(aprvLineVO.getEmpId().equals(loginId)) {//결재자 아이디 비교
				if(aprvLineVO.getAprvLineStatus().equals("대기")) {//상태값 비교
					boolean dbResult = aprvLineDao.setAprvLineStatus(aprvLineDto);
					if(dbResult) {
						//결재상태 확인
						AprvDetailVO aprvDetailVO = aprvDao.selectOneForAprv(aprvLineVO.getAprvDocumentNo());
						if(aprvLineDto.getAprvLineStatus().equals("승인")) {
							//System.out.println("aprv_no : " + aprvLineVO.getAprvDocumentNo() + ", aprvLineCurrentSeq : " + aprvLineVO.getAprvLineCurrentSeq());
							//현재 순서의 결재가 모두 처리되었는지 확인 후 변경
							aprvLineDao.setAprvStatus(aprvLineVO.getAprvDocumentNo(), aprvLineVO.getAprvLineCurrentSeq());
							//상태값이 승인으로 변경되었다면
							if(aprvDetailVO.getAprvStatus().equals("승인")) {
								String headName = aprvDetailVO.getHeadName();
								//일정 등록해야 하는 분류라면
								if(planHead.contains(headName)) {
									//결재헤드가 연차일때 휴가계산 및 일정 등록 필요
									if(headName.equals("연차")) {
										//휴가 차감
										boolean leaveUpdate = empLeaveDao.leaveUpdate(aprvDetailVO.getAprvWriter(), aprvDetailVO.getAprvLeave());
										//휴가 변경 로그 등록
										if(leaveUpdate) {
											EmpLeaveDto empLeaveDto = empLeaveDao.selectOne(aprvDetailVO.getAprvWriter());
											double leaveRemain = empLeaveDto == null ? 0 : empLeaveDto.getLeaveRemain();
											double leaveUsed = empLeaveDto == null ? 0 : empLeaveDto.getLeaveUsed();
											LeaveManageVO leaveManagerVO = LeaveManageVO.builder()
													.leaveType("휴가")
													.leaveLogId(aprvDetailVO.getAprvWriter())
													.leaveAmount(aprvDetailVO.getAprvLeave())
													.leaveTotalAfter(leaveRemain)
													.leaveUsedAfter(leaveUsed)
													.build();
											empLeaveDao.logInsert(leaveManagerVO);
										}
									}
									//일정 등록
									int planNo = planDao.sequence();
									String planName = aprvDetailVO.getEmpName();
									if(aprvDetailVO.getEmpPositionName() != null && aprvDetailVO.getEmpPositionName() != "") {
										planName += " " + aprvDetailVO.getEmpPositionName();
									}
									planName += " " + headName;
									PlanDto planDto = PlanDto.builder()
											.planNo(planNo)
											.planEmpId(aprvDetailVO.getAprvWriter())
											.planAprvNo(aprvDetailVO.getAprvNo())
											.planDeptNo(aprvDetailVO.getDeptNo())
											.planHeadNo(aprvDetailVO.getHeadNo())
											.planName(planName)
											.planExplain(aprvDetailVO.getAprvContent())
											.planSdate(aprvDetailVO.getAprvSdate())
											.planEdate(aprvDetailVO.getAprvEdate())
											.planType("부서")
											.build();
									planDao.insert(planDto);
								} else {//일정 등록하지 않는 헤더라면
									if(headName.equals("사직")) {
										empDao.insertEmpExit(aprvDetailVO.getAprvWriter(), aprvDetailVO.getAprvSdate());
									}
								}
								
								//승인 결과 기안자에게 쪽지 보내기
								MemoDto memoDto = MemoDto.builder()
										.memoNo(memoDao.sequence())
										.memoReceiverId(aprvDetailVO.getAprvWriter())
										.memoSenderId("system")
										.memoTitle("결재 승인 알림")
										.memoContent("[" + aprvDetailVO.getAprvTitle() + "] 결재가 승인되었습니다.<br><br><a href='/aprv/detail?aprvNo=" + aprvDetailVO.getAprvNo() + "' target='_blank'>결재 문서 확인</a>")
										.memoReadStatus("N")
										.memoType("결재")
										.build();
								memoDao.insert(memoDto);
							}
						} else {
							//반려라면 결재의 상태값도 반려로 변경
							aprvDao.setAprvDeny(aprvLineVO.getAprvDocumentNo());
							//반려 결과 기안자에게 쪽지 보내기
							MemoDto memoDto = MemoDto.builder()
									.memoNo(memoDao.sequence())
									.memoReceiverId(aprvDetailVO.getAprvWriter())
									.memoSenderId("system")
									.memoTitle("결재 반려 알림")
									.memoContent("[" + aprvDetailVO.getAprvTitle() + "] 결재가 반려되었습니다.<br><br><a href='/aprv/detail?aprvNo=" + aprvDetailVO.getAprvNo() + "' target='_blank'>결재 문서 확인</a>")
									.memoReadStatus("N")
									.memoType("결재")
									.build();
							memoDao.insert(memoDto);
						}
						result.put("result", "Success");						
					} else {
						result.put("result", "Fail");//DB에서 처리 실패
					}
				} else {
					result.put("result", "AlreadyAprv");//결재 상태가 대기가 아닌 이미 처리가 된 상태라면
				}
			} else {
				result.put("result", "NotMyData");//처리자가 결재자와 다르다면
			}
		} else {
			result.put("result", "NeedLogin");//로그인이 안된 상태라면
		}
		
		return result;
	}
}
