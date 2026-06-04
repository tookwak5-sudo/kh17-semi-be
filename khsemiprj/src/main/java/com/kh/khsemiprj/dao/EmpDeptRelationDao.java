package com.kh.khsemiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.mapper.EmpDeptRelationMapper;

@Repository
public class EmpDeptRelationDao {
	@Autowired
	JdbcTemplate jdbcTemplate;
	@Autowired
	EmpDeptRelationMapper deptRelationMapper;
	
	//승인 후 부서 입력
	public void insertEmpDept(String empId, int deptNo) {
		String sql = "INSERT INTO emp_dept_relation (emp_id, dept_no) VALUES (?, ?)";
		Object[] params = {empId, deptNo};
		jdbcTemplate.update(sql, params);
	}
}
