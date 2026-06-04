package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.EmpDeptRelationDto;

@Component
public class EmpDeptRelationMapper implements RowMapper<EmpDeptRelationDto> {
	@Override
	public EmpDeptRelationDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return EmpDeptRelationDto.builder()
				.deptNo(rs.getLong("dept_no"))
				.empId(rs.getString("emp_id"))
			.build();
	}
}
