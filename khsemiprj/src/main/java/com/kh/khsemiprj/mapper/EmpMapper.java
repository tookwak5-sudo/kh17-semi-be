package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.EmpDto;

@Component
public class EmpMapper implements RowMapper<EmpDto> {
	@Override
	public EmpDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return EmpDto.builder()
				.empId(rs.getString("emp_id"))
				.empPositionNo(rs.getInt("emp_position_no"))
				.empEmail(rs.getString("emp_email"))
				.empPassword(rs.getString("emp_password"))
				.empName(rs.getString("emp_name"))
				.empBirth(rs.getString("emp_birth"))
				.empContact(rs.getString("emp_contact"))
				.empPost(rs.getString("emp_post"))
				.empAddress1(rs.getString("emp_address1"))
				.empAddress2(rs.getString("emp_address2"))
				.empHireDate(rs.getString("emp_hire_date"))
				.empLogin(rs.getTimestamp("emp_login"))
				.empValid(rs.getString("emp_valid"))
				.empValidDate(rs.getTimestamp("emp_valid_date"))
				.empChange(rs.getTimestamp("emp_change"))
				.empLongLeave(rs.getTimestamp("emp_long_leave"))
			.build();
	}
}
