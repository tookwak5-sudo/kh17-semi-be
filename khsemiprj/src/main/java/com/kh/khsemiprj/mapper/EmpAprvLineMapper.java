package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.EmpAprvLineVO;

@Component
public class EmpAprvLineMapper implements RowMapper<EmpAprvLineVO> {

	@Override
	public EmpAprvLineVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		return EmpAprvLineVO.builder()
				.empName(rs.getString("emp_name"))
				.aprvNo(rs.getInt("aprv_no"))
				.aprvWriter(rs.getString("aprv_writer"))
				.aprvTitle(rs.getString("aprv_title"))
				.aprvStatus(rs.getString("aprv_status"))
				.empId(rs.getString("emp_id"))
			.build();
	}
	
}
