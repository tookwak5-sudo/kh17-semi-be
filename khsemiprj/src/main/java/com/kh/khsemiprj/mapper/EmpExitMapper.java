package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.EmpExitDto;

@Component
public class EmpExitMapper implements RowMapper<EmpExitDto>{

	@Override
	public EmpExitDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return EmpExitDto.builder()
				.empId(rs.getString("emp_id"))
				.empExitTime(rs.getTimestamp("emp_exit_time"))
			.build();
	}
}
