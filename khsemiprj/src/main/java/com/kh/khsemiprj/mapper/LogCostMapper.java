package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.LogCostDto;

@Component
public class LogCostMapper implements RowMapper<LogCostDto> {
	@Override
	public LogCostDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return LogCostDto.builder()
				.logCostNo(rs.getLong("log_cost_no"))
				.logEmpId(rs.getString("log_emp_id"))
				.logAprvDocumentNo(rs.getLong("log_cost_document_no"))
				.logCostUsed(rs.getLong("log_cost_used"))
				.logAprvRecord(rs.getString("log_aprv_record"))
				.logCostWtime(rs.getTimestamp("log_cost_wtime"))
				.build();
	}
}
