package com.kh.khsemiprj;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableAsync // 이제부터 이 프로그램에서는 비동기 시스템을 사용
@EnableScheduling // 이제부터 이 프로그램에서는 스케줄러 시스템을 사용
@SpringBootApplication
public class KhsemiprjApplication {

	public static void main(String[] args) {
		SpringApplication.run(KhsemiprjApplication.class, args);
	}

}
