package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.EmpPositionDeptDto;
import com.kh.khsemiprj.dto.EmpPositionDto;

@Component
public class EmpPositionMapper implements RowMapper<EmpPositionDto> {
	@Override
	public EmpPositionDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		String empPositionName = rs.getString("emp_position_name") == null ? "직급없음" : rs.getString("emp_position_name");
		
		return EmpPositionDto.builder()
				.empPositionName(empPositionName)
				.empPositionLevel(rs.getInt("emp_position_level"))
				.empPositionNo(rs.getInt("emp_position_no"))
			.build();
	}
}