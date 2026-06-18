package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.EmpExitVO;
@Component
public class EmpExitVOMapper implements RowMapper<EmpExitVO>{

	@Override
	public EmpExitVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		// TODO Auto-generated method stub
		return EmpExitVO.builder()
				.empId(rs.getString("emp_id"))
				.empExitTime(rs.getTimestamp("emp_exit_time"))
				.empName(rs.getString("emp_name"))
				.aprvEtime(rs.getTimestamp("aprv_etime"))
				.build();
	}

}
