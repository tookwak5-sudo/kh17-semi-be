package com.kh.khsemiprj.service;

import java.util.Random;

import org.springframework.stereotype.Service;

@Service
public class RandomService {
	
	private Random r = new Random();
	
	private String numbers = "0123456789";
	private String lowerCases = "abcdefghijklmnopqrstuvwxyz";
	private String upperCases = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	private String hashCases = "!@#$%&";
	
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
	//임시 비밀번호 생성
	public String generatePassword(int size) {
		StringBuffer buffer = new StringBuffer();
		
		// 1. 대문자(upperCases)에서 랜덤 1글자 추가
	    char upper = upperCases.charAt(r.nextInt(upperCases.length()));
	    buffer.append(upper);
	    
	    // 2. 소문자(lowerCases)에서 랜덤 1글자 추가
	    char lower = lowerCases.charAt(r.nextInt(lowerCases.length()));
	    buffer.append(lower);
	    
	    // 3. 특수문자(hashCases)에서 랜덤 1글자 추가
	    char hash = hashCases.charAt(r.nextInt(hashCases.length()));
	    buffer.append(hash);
		
		for(int i=0; i < size; i++) {
			int index = r.nextInt(numbers.length());//랜덤위치
			char ch = numbers.charAt(index);//해당 위치 글자 추출
			buffer.append(ch);			
		}
		return buffer.toString();
	}
}
