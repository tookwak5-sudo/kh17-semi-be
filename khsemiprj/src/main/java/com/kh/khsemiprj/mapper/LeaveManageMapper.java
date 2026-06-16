package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.LeaveManageVO;

@Component
public class LeaveManageMapper implements RowMapper<LeaveManageVO>{

	@Override
	public LeaveManageVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		return LeaveManageVO.builder()
//				.leaveEmpId(rs.getString("leave_emp_id"))
				.leaveYear(rs.getString("leave_year"))
		 		
				.empId(rs.getString("emp_id"))
				.empHireDate(rs.getString("emp_hire_date"))
				.empValid(rs.getString("emp_valid"))
				.leaveTotal(rs.getDouble("leave_total"))
				.leaveUsed(rs.getDouble("leave_used"))
				.leaveRemain(rs.getDouble("leave_remain"))
				.leaveUpdate(rs.getTimestamp("leave_update"))
				
//				.leaveNo(rs.getLong("leave_no"))
//				.leaveLogId(rs.getString("leave_log_id"))
//				.leaveType(rs.getString("leave_type"))
//				.leaveAmount(rs.getDouble("leave_amount"))
//				.leaveTotalAfter(rs.getDouble("leave_total_after"))
//				.leaveUsedAfter(rs.getDouble("leave_used_after"))
//				.leaveRecord(rs.getTimestamp("leave_record"))
				.build();
	}
}
