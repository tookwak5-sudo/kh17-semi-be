package com.kh.khsemiprj.dto;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.Data;

@Data
public class BoardDto {
	private long boardNo;
	private String boardHead;
	private String boardTitle;
	private String boardWriter;
	private String boardContent;
	private Timestamp boardWtime, boardEtime;
	private long boardReadcount, boardLikecount, boardDisLikecount, boardReplycount;


	public String getBoardWtimeString() {
	//	LocalDate now = LocalDate.now();
	//	LocalDate WDate =  boardWtime.toLocalDateTime().toLocalDate();
	//	LocalDateTime Wtime =  boardWtime.toLocalDateTime();
		
		LocalDateTime current = LocalDateTime.now();
		LocalDateTime writeTime = boardWtime.toLocalDateTime();
		
		LocalDate currentDate = current.toLocalDate();
		LocalDate writeDate = writeTime.toLocalDate();
		
		DateTimeFormatter time = DateTimeFormatter.ofPattern("HH:mm");
		DateTimeFormatter days = DateTimeFormatter.ofPattern("MM-dd");
		
		if(writeDate.equals(currentDate)) return writeTime.format(time);
		else return writeDate.format(days);
}
}
