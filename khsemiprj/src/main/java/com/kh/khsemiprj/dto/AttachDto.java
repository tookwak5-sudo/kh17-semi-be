package com.kh.khsemiprj.dto;

import lombok.Data;

@Data
public class AttachDto {
	private int attachNo;
	private String attachName;
	private String attachType;
	private long attachSize;
	
	//파일 유형을 알려주기 위한 메소드
	public String getAttachTypeString() {
		if(attachType == null) {
			return "application/octet-stream";
		}
		return attachType;
	}
	
}
