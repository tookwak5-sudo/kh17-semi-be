package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;


import com.kh.khsemiprj.dto.EmpLeaveDto;

@Component
public class EmpLeaveMapper implements RowMapper<EmpLeaveDto> {
	@Override
	public EmpLeaveDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return EmpLeaveDto.builder()
				.leaveEmpId(rs.getString("leave_emp_id"))
				.leaveYear(rs.getString("leave_year"))
				.leaveTotal(rs.getDouble("leave_total"))
				.leaveUsed(rs.getDouble("leave_used"))
				.leaveRemain(rs.getDouble("leave_remain"))
				.leaveUpdate(rs.getTimestamp("leave_update"))
			.build();
	}

}
