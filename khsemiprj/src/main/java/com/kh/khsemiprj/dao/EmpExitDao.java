package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.EmpExitDto;
import com.kh.khsemiprj.mapper.EmpExitMapper;

@Repository
public class EmpExitDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EmpExitMapper empExitMapper;
	
	public EmpExitDto selectOne(String empId) {
		String sql = "select * from emp_exit where emp_id = ? ";
		Object[] params = { empId };
		List<EmpExitDto> list = jdbcTemplate.query(sql, empExitMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
}
