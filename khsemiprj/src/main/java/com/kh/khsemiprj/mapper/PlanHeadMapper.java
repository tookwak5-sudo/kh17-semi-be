package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.PlanHeadVO;

@Component
public class PlanHeadMapper implements RowMapper<PlanHeadVO> {

	@Override
	public PlanHeadVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		return PlanHeadVO.builder()
				.planNo(rs.getInt("plan_no"))
				.planEmpId(rs.getNString("plan_emp_id"))
				.planAprvNo(rs.getObject("plan_aprv_no", Integer.class))
				.planDeptNo(rs.getObject("plan_dept_no", Long.class))
				.planHeadNo(rs.getObject("plan_head_no", Integer.class))
				.planName(rs.getString("plan_name"))
				.planExplain(rs.getNString("plan_explain"))
				.planSdate(rs.getString("plan_sdate"))
				.planEdate(rs.getString("plan_edate"))
				.planWtime(rs.getTimestamp("plan_Wtime"))
				.planType(rs.getString("plan_type"))
				.headNo(rs.getInt("head_name"))
				.headName(rs.getString("head_name"))
				.headType(rs.getString("head_type"))
			.build();
	}

}
