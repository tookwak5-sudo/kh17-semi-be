package com.kh.khsemiprj.exception;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

//@ControllerAdvice(annotations = {Controller.class})
@ControllerAdvice(basePackages = {"com.kh.khsemiprj.controller"})
public class ErrorController {
	
	//컨트롤러에서 예외가 생기면 그 예외에 대한 처리를 수행하는 매핑
	//- 코드는 컨트롤러와 동일하게 작성 가능
	//- 예외 객체를 제공받을 수 있음
	@ExceptionHandler(Exception.class)
	public String error(Exception e, Model model) {
		e.printStackTrace();//오류 로그를 서버에 출력하고
		model.addAttribute("message", e.getMessage());
		return "error/500";
	}
	
	@ExceptionHandler(TargetNotfoundException.class)
	public String notFound(Exception e, Model model) {
		model.addAttribute("message", e.getMessage());//메세지 화면에 전달하고
		return "error/404";//오류 페이지 연결
	}
	@ExceptionHandler(WhoAreYouException.class)
    public String unauthorize(WhoAreYouException e, Model model) {
        model.addAttribute("message", e.getMessage());//메세지 화면에 전달하고
        return "redirect:/emp/login";//로그인 페이지 연결
    }
	@ExceptionHandler(GetOutException.class)
	public String forbidden(Exception e, Model model) {
		model.addAttribute("message", e.getMessage());//메세지 화면에 전달하고
		return "error/403";//오류 페이지 연결
	}
}
