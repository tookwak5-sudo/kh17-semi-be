package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.PlanEmpDeptVO;
import com.kh.khsemiprj.vo.PlanHeadVO;

@Component
public class PlanEmpDeptMapper implements RowMapper<PlanEmpDeptVO> {

	@Override
	public PlanEmpDeptVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		return PlanEmpDeptVO.builder()
				.planNo(rs.getInt("plan_no"))
				.planEmpId(rs.getNString("plan_emp_id"))
				.planDeptNo(rs.getObject("plan_dept_no", Long.class))
				.planHeadNo(rs.getObject("plan_head_no", Integer.class))
				.planName(rs.getString("plan_name"))
				.planSdate(rs.getString("plan_sdate"))
				.planEdate(rs.getString("plan_edate"))
				.planType(rs.getString("plan_type"))
				.empName(rs.getString("emp_name"))
				.deptName(rs.getString("dept_name"))
				.headType(rs.getString("head_type"))
			.build();
	}
	
}
