package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.EmpLeaveDto;
import com.kh.khsemiprj.mapper.EmpLeaveMapper;

//아직 더미데이터의 목록만 보여주는 정도의 dao입니다
@Repository
public class EmpLeaveDao {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EmpLeaveMapper empLeaveMapper;

	public List<EmpLeaveDto> selectList(String leaveEmpId) {
		if (leaveEmpId == null)
			return null;
		String sql = "select * from emp_leave " + "where leave_emp_id = ? order by leave_year desc";
		Object[] params = { leaveEmpId };

		return jdbcTemplate.query(sql, empLeaveMapper, params);

	}
	
	public EmpLeaveDto selectOne(String empId) {
		String sql = "select * from emp_leave where leave_emp_id = ?";
		Object[] params = { empId};
		List<EmpLeaveDto> list = jdbcTemplate.query(sql,  empLeaveMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

}
