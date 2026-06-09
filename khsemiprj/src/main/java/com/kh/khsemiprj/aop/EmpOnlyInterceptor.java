package com.kh.khsemiprj.aop;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.khsemiprj.exception.WhoAreYouException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Service
public class EmpOnlyInterceptor implements HandlerInterceptor {
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
		throws Exception {
		HttpSession session = request.getSession();
		
		String loginId = (String) session.getAttribute("loginId");
		Integer empGrade = (Integer) session.getAttribute("empGrade");
		
		
		if(loginId == null || empGrade == null) {
			throw new WhoAreYouException();
		}
		
		return true;
	}
}
