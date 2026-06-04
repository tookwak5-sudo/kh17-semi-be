package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.EmpPositionDeptDto;

@Component
public class EmpPositionDeptMapper implements RowMapper<EmpPositionDeptDto> {
	@Override
	public EmpPositionDeptDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		String empPositionName = rs.getString("emp_position_name") == null ? "직급없음" : rs.getString("emp_position_name");
		
		return EmpPositionDeptDto.builder()
				.empId(rs.getString("emp_id"))
				.empName(rs.getString("emp_name"))
				.empPositionName(empPositionName)
				.empPositionLevel(rs.getInt("emp_position_level"))
				.deptNo(rs.getLong("dept_no"))
				.deptName(rs.getString("dept_name"))
				.deptEmpId(rs.getString("dept_emp_id"))
			.build();
	}
}
