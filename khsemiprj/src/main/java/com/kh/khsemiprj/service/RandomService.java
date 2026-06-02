package com.kh.khsemiprj.service;

import java.util.Random;

import org.springframework.stereotype.Service;

@Service
public class RandomService {
	
	private Random r = new Random();
	
	private String numbers = "0123456789";
	private String lowerCases = "abcdefghijklmnopqrstuvwxyz";
	private String upperCases = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	//숫자 생성
		public String generateNumber(int size) {
			StringBuffer buffer = new StringBuffer();
			for(int i=0; i < size; i++) {
				int index = r.nextInt(numbers.length());//랜덤위치
				char ch = numbers.charAt(index);//해당 위치 글자 추출
				buffer.append(ch);			
			}
			return buffer.toString();
		}
}
