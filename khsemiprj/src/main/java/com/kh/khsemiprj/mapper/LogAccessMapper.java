package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.EmpDto;
import com.kh.khsemiprj.dto.LogAccessDto;

@Component
public class LogAccessMapper implements RowMapper<LogAccessDto> {
	@Override
	public LogAccessDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return LogAccessDto.builder()
				.accessNo(rs.getLong("access_no"))
				.accessEmpId(rs.getString("access_emp_id"))
				.accessDate(rs.getTimestamp("access_date"))
				.accessUrl(rs.getString("access_url"))
				.accessIp(rs.getString("access_ip"))
			.build();	
	}
}
