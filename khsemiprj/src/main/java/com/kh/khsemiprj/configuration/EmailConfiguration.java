package com.kh.khsemiprj.configuration;

import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSenderImpl;

import com.kh.khsemiprj.configuration.EmailProperties;

//이메일 발송에 관련된 도구들을 등록해주는 설정파일
@Configuration
public class EmailConfiguration {
	
	@Autowired
	private EmailProperties emailProperties;
	
	@Bean
	public JavaMailSenderImpl sender() {
		//1. 메일 전송 도구 생성
				JavaMailSenderImpl sender = new JavaMailSenderImpl();
				
				System.out.println("★ HOST: " + emailProperties.getHost());
			    System.out.println("★ USERNAME: " + emailProperties.getUsername());
			    System.out.println("★ PASSWORD_LEN: " + (emailProperties.getPassword() != null ? emailProperties.getPassword().length() : "NULL"));
				
				//+ 메일 전송 도구의 정보 설정
				sender.setHost(emailProperties.getHost());//이용할 업체의 호스트 정보
				sender.setPort(emailProperties.getPort());//이용할 업체의 포트 번호
				sender.setUsername(emailProperties.getUsername());//이용자의 계정이름
				sender.setPassword(emailProperties.getPassword());//이용자의 앱비밀번호(개인X)
				
				Properties props = new Properties();//Map<String, String> 형태
				props.setProperty("mail.smtp.auth", "true");//인증 사용
				props.setProperty("mail.smtp.debug", "true");//에러 시 통신내역 출력(운영단계에선 false)
				props.setProperty("mail.smtp.starttls.enable", "true");//보안 프로토콜 사용
				props.setProperty("mail.smtp.ssl.protocols", "TLSv1.2");//보안 프로토콜 버전을 최신으로 지정
				props.setProperty("mail.smtp.ssl.trust", "*");//신뢰할 수 있는 업체 목록에 추가
				
				sender.setJavaMailProperties(props);//상세 옵션 설정
				
				return sender;
	}
}
