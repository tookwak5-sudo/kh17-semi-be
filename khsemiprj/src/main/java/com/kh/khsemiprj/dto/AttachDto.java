package com.kh.khsemiprj.dto;



import lombok.Data;

@Data
public class AttachDto {
	private int attachNo;
	private String attachName;
	private String attachType;
	private long attachSize;
	
	//파일 유형(MIME TYPE)을 알려주기 위한 메소드
	//- 만약 유형을 알 수 없으면 null 대신 application/octet-stream 을 반환한다
	public String getAttachTypeString() {
		if(attachType == null) { 
			return "application/octet-stream";
		}
		return attachType;
	}
}
