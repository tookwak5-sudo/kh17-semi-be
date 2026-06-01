package com.kh.khsemiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Service
public class PageLogInterceptor implements HandlerInterceptor {
	
	//@Autowired
	//private LogAccessDao logAccessDao
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		//페이지 로그 인터셉터
		// - 페이지 호출마다 로그 기록용 인터셉터
		HttpSession session = request.getSession();
//		String loginId = (String)session.getAttribute("loginId");
//		String currentUrl = request.getRequestURI();
//		String currentIp = request.
//		logAccessDao.insertLog(loginId, currentUrl);
		
		return true;
	}
}
