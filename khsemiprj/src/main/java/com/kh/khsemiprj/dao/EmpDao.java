package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.EmpDto;
import com.kh.khsemiprj.mapper.EmpMapper;

@Repository
public class EmpDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EmpMapper empMapper;
	
	//아이디를 통해 회원정보 불러오기 
	public EmpDto selectOne(String loginId) {
		String sql = "select * from emp where emp_id = ?";
		Object[] params = { loginId };
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//아이디찾기
	public EmpDto selectId(String empName, String empEmail) {
		String sql = "select emp_id from emp where emp_name = ? and emp_email = ?";
		Object[] params = {empName, empEmail};
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
}
