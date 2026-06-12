package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.EmpPositionDeptVO;

@Component
public class EmpPositionDeptVOMapper implements RowMapper<EmpPositionDeptVO> {
	@Override
	public EmpPositionDeptVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		String empPositionName = rs.getString("emp_position_name") == null ? "직급없음" : rs.getString("emp_position_name");
		
		return EmpPositionDeptVO.builder()
				.empId(rs.getString("emp_id"))
				.empName(rs.getString("emp_name"))
				.empPositionName(empPositionName)
				.empPositionLevel(rs.getInt("emp_position_level"))
				.empEmail(rs.getString("emp_email"))
				.empContact(rs.getString("emp_contact"))
				.deptNo(rs.getLong("dept_no"))
				.empPositionNo(rs.getInt("emp_position_no"))
				.deptName(rs.getString("dept_name"))
				.deptEmpId(rs.getString("dept_emp_id"))
			.build();
	}
}