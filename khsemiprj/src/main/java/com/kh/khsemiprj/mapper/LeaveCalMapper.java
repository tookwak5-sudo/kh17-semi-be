package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.LeaveCalVO;

@Component
public class LeaveCalMapper implements RowMapper<LeaveCalVO>{

	@Override
	public LeaveCalVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		return LeaveCalVO.builder()
				.leaveEmpId(rs.getString("leave_emp_id"))
				.leaveTotal(rs.getDouble("leave_total"))
				.leaveUsed(rs.getDouble("leave_used"))
				.leaveRemain(rs.getDouble("leave_remain"))
				.leaveUpdate(rs.getTimestamp("leave_update"))
				.empHireDate(rs.getString("emp_hire_date"))
				.build();
	}
}
