package com.kh.khsemiprj.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @AllArgsConstructor @NoArgsConstructor
public class MemoDto {
	private int memoNo;
	private String memoReceiverId;
	private String memoSenderId;
	private String memoTitle;
	private String memoContent;
	private String memoReadStatus = "N";
	private String memoType = "일반";
	private Timestamp memoWtime;
}
