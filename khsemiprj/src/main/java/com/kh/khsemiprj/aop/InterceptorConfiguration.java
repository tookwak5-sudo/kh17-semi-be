package com.kh.khsemiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

//스프링의 설정파일(Configuration)
//- application.properties에 하기 어려운 설정들(ex : 계산이 필요한 경우)
//- 인터셉터 등 홈페이지의 운영과 관련된 설정은 반드시 상속이 필요 (WebMvcConfigurer)
@Configuration
public class InterceptorConfiguration implements WebMvcConfigurer{
	//등록한 인터셉터를 가져오도록 설정하고
	@Autowired
	private PageLogInterceptor pageLogInterceptor;
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(pageLogInterceptor)
		.addPathPatterns("/**")
		.excludePathPatterns("/emp/login")
		;
	}
}
