package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.DeptDto;

@Component
public class DeptMapper implements RowMapper<DeptDto> {
	@Override
	public DeptDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return DeptDto.builder()
				.deptNo(rs.getLong("dept_no"))
				.deptParentNo(rs.getLong("dept_parent_no"))
				.deptName(rs.getString("dept_name"))
				.deptDepth(rs.getInt("dept_depth"))
				.deptUseYn(rs.getString("dept_use_yn"))
				.deptEmpId(rs.getString("dept_emp_id"))
				.emp(new ArrayList<>())
				.children(new ArrayList<>())
			.build();
	}
}
