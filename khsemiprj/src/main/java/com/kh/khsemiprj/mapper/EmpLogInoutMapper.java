package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.vo.EmpLogInoutVO;

@Repository
public class EmpLogInoutMapper implements RowMapper<EmpLogInoutVO> {

	@Override
	public EmpLogInoutVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		return EmpLogInoutVO.builder()
				.logInoutNo(rs.getLong("log_inout_no"))
				.logInoutEmpId(rs.getString("log_inout_emp_id"))
				.logInoutTime(rs.getTimestamp("log_inout_time"))
				.logInoutType(rs.getString("log_inout_type"))
				.empName(rs.getString("emp_name"))
				.build();
	}

}
