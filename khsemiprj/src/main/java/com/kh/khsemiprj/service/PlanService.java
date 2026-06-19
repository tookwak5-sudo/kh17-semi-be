package com.kh.khsemiprj.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.khsemiprj.dao.PlanDao;
import com.kh.khsemiprj.dto.PlanDto;
import com.kh.khsemiprj.exception.GetOutException;
import com.kh.khsemiprj.exception.TargetNotfoundException;

@Service
public class PlanService {
	@Autowired
	private PlanDao planDao;
	
	public PlanDto getMyPlan(int planNo, String loginId) {
		PlanDto planDto = planDao.selectOne(planNo);
		
		//1. 데이터가 없는 경우
		if (planDto == null) throw new TargetNotfoundException("데이터가 없습니다");
		
		//2. 본인확인 로직
		if (!planDto.getPlanEmpId().equals(loginId))	{
			throw new GetOutException("본인만 수정/삭제 가능합니다");
		}
		
		return planDto;
	}
}
