package com.kh.khsemiprj.dto;

import java.sql.Timestamp;

import lombok.Builder;
import lombok.Data;

@Data @Builder
public class MemoDto {
	private int memoNo;
	private String memoReceiverId;
	private String memoSenderId;
	private String memoTitle;
	private String memoContent;
	private String memoReadStatus;
	private String memoType;
	private Timestamp memoWtime;
}
