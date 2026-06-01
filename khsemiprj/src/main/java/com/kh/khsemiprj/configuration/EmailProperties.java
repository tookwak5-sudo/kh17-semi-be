package com.kh.khsemiprj.configuration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
@ConfigurationProperties(prefix = "custon.email")
public class EmailProperties {
	private String host;//접두사 + host라는 항목을 읽어서 여기에 저장해!
	private int port;//접두사 + port라는 항목을 읽어서 여기에 저장해!
	private String username;//접두사 + username 항목을 읽어서 여기에 저장해!
	private String password;//접두사 + password 항목을 읽어서 여기에 저장해!
}
