package com.kh.khsemiprj.aop;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.khsemiprj.exception.GetOutException;
import com.kh.khsemiprj.exception.WhoAreYouException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class AdminOnlyInterceptor implements HandlerInterceptor{
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
		throws Exception {
		
		HttpSession session = request.getSession();
		
		Integer empGrade = (Integer) session.getAttribute("empGrade");
		
		//비회원?
		if(empGrade == null) throw new WhoAreYouException();
		
		//부서장 이상인지
		if(empGrade < 1) throw new GetOutException();
		
		return true;
	}
}
