package com.kh.khsemiprj.dto;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class EmpExitDto {
	private String empId;
	private Timestamp empExitTime;
	
	public boolean isExit() {
        LocalDateTime exitTime = empExitTime.toLocalDateTime();
        LocalDate today = LocalDate.now();
        if (exitTime.toLocalDate().isAfter(today)) {
        	//아직 퇴사일이 다가오지 않았다면 탈퇴자 처리 X
        	return false;
        } else {
        	return true;
        }
	}
}
