package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.LogInoutDto;

@Component
public class LogInoutMapper implements RowMapper<LogInoutDto> {

	@Override
	public LogInoutDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		return LogInoutDto.builder()
				.logInoutNo(rs.getLong("log_inout_no"))
				.logInoutEmpId(rs.getString("log_inout_emp_id"))
				.logInoutTime(rs.getTimestamp("log_inout_time"))
				.logInoutType(rs.getString("log_inout_type"))
				.build();
	}
}
