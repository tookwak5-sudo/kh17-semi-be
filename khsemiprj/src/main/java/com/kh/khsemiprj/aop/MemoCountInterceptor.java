package com.kh.khsemiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.kh.khsemiprj.dao.MemoDao;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class MemoCountInterceptor implements HandlerInterceptor {
	@Autowired
	private MemoDao memoDao;
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		if (modelAndView == null) {
	        return; // 비동기(@ResponseBody) 요청이나 가방이 없는 상태면 그냥 통과(패스)!
	    }
	    
	    // 2. 리다이렉트 이동("redirect:/home" 등)일 때도 헤더를 그릴 필요가 없으므로 패스!
	    if (modelAndView.getViewName() != null && modelAndView.getViewName().startsWith("redirect:")) {
	        return;
	    }
	    
		HttpSession session = request.getSession();
		String receiverId = (String) session.getAttribute("loginId");
		if(receiverId != null) {
			int countMemo = memoDao.memoCount(receiverId);
			
			modelAndView.addObject("countMemo", countMemo);
		}
	}
}
