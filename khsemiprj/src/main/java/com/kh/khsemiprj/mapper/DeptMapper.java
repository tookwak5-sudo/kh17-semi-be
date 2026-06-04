package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dao.EmpPositionDeptDao;
import com.kh.khsemiprj.dto.DeptDto;
import com.kh.khsemiprj.dto.EmpPositionDeptDto;

@Component
public class DeptMapper implements RowMapper<DeptDto> {
	
	@Autowired
	private EmpPositionDeptDao empPositionDeptDao;
	
	@Override
	public DeptDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		List<EmpPositionDeptDto> list = empPositionDeptDao.selectDepthEmp(rs.getLong("dept_no"));
		
		return DeptDto.builder()
				.deptNo(rs.getLong("dept_no"))
				.deptParentNo(rs.getLong("dept_parent_no"))
				.deptName(rs.getString("dept_name"))
				.deptDepth(rs.getInt("dept_depth"))
				.deptUseYn(rs.getString("dept_use_yn"))
				.deptEmpId(rs.getString("dept_emp_id"))
				.empList(list)
				.children(new ArrayList<>())
			.build();
	}
}
