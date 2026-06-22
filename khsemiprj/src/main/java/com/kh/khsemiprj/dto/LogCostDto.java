package com.kh.khsemiprj.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class LogCostDto {
	private long logCostNo;
	private String logEmpId;
	private long logAprvDocumentNo;
	private long logCostUsed;
	private String logAprvRecord;
	private Timestamp logCostWtime;
}
