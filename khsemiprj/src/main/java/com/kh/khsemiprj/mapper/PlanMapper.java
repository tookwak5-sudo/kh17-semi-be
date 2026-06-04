package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.PlanDto;

@Component
public class PlanMapper implements RowMapper<PlanDto> {
	@Override
	public PlanDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return PlanDto.builder()
				.planNo(rs.getInt("plan_no"))
				.planEmpId(rs.getNString("plan_emp_id"))
				.planAprvNo(rs.getInt("plan_aprv_no"))
				.planDeptNo(rs.getLong("plan_dept_no"))
				.planName(rs.getString("plan_name"))
				.planType(rs.getString("plan_type"))
				.planExplain(rs.getNString("plan_explain"))
				.planSdate(rs.getTimestamp("plan_sdate"))
				.planEdate(rs.getTimestamp("plan_edate"))
				.planWtime(rs.getTimestamp("plan_Wtime"))
			.build();
	}
}
