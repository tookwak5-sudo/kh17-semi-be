package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.DeptDto;

@Component
public class DeptMapper implements RowMapper<DeptDto> {
	@Override
	public DeptDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return DeptDto.builder()
				.deptNo(rs.getInt("dept_no"))
				.deptParentNo(rs.getInt("dept_parent_no"))
				.deptName(rs.getString("dept_name"))
				.deptDepth(rs.getInt("dept_depth"))
				.deptUseYn(rs.getString("dept_use_yn"))
				.deptEmpId(rs.getString("dept_emp_id"))
			.build();
	}
}
