package com.kh.khsemiprj.dto;

import java.sql.Timestamp;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class EmpLeaveDto {
private String leaveEmpId;
private String leaveYear;
private double leaveTotal;
private double leaveUsed;
private double leaveRemain;
private Timestamp leaveUpdate;

public Double leavePeriod(EmpLeaveDto leaveDto) {
	
	if (leaveDto == null || leaveDto.getLeaveUpdate() == null) {
        return null;
    }
	
	LocalDateTime baseTime = leaveDto.getLeaveUpdate().toLocalDateTime();
	
	double usedDays = leaveDto.getLeaveTotal() - leaveDto.getLeaveUsed();
	
	//
	long totalHours = (long) (usedDays*24);
	
	
	LocalDateTime realUsedDateTimeHr = baseTime.plusHours(totalHours);
	
	if(realUsedDateTimeHr.getHour()>=8) {
		return 0.5;
	}
	
	
	return totalHours/24.0;
	
	
	
	
	
	
	
	
 }
}
