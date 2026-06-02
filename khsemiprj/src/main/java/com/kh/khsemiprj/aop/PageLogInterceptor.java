package com.kh.khsemiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.khsemiprj.dao.LogAccessDao;
import com.kh.khsemiprj.dto.LogAccessDto;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Service
public class PageLogInterceptor implements HandlerInterceptor {
	
	@Autowired
	private LogAccessDao logAccessDao;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		//페이지 로그 인터셉터
		// - 페이지 호출마다 로그 기록용 인터셉터
		HttpSession session = request.getSession();
		String loginId = (String)session.getAttribute("loginId");
		
		if(loginId == null) {
			loginId = "비회원";
		}
		String currentUrl = request.getRequestURI();
		String currentIp = request.getHeader("X-Forwarded-For");
		if (currentIp == null || currentIp.isEmpty() || "unknown".equalsIgnoreCase(currentIp)) {
			currentIp = request.getHeader("Proxy-Client-IP");
		}
		if (currentIp == null || currentIp.isEmpty() || "unknown".equalsIgnoreCase(currentIp)) {
			currentIp = request.getRemoteAddr(); // 가장 기본적인 IP 추출법
		}
		
		// [로컬 테스트 팁] IPv6 주소인 0:0:0:0:0:0:0:1 로 나온다면 내 컴퓨터로 접속한 것입니다.
		if(currentIp.equals("0:0:0:0:0:0:0:1")) {
			currentIp = "127.0.0.1";
		}
		
		//받은 데이터 Dto
		LogAccessDto logAccessDto = new LogAccessDto();
		logAccessDto.setAccessEmpId(loginId);
		logAccessDto.setAccessUrl(currentUrl);
		logAccessDto.setAccessIp(currentIp);
		
		logAccessDao.insert(logAccessDto);
		
		return true;
	}
}
