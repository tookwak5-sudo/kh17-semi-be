package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.EmpDto;
import com.kh.khsemiprj.mapper.EmpMapper;

@Repository
public class EmpPositionDeptDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EmpMapper empMapper;
	
	public EmpDto selectOne(String loginId) {
		String sql = "select * from emp where emp_id = ?";
		Object[] params = { loginId };
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
		
	// 사원아이디를 통해 사원의 직책, 부서 조회
		public List<EmpDto> selectList(EmpDto empDto) {
				String sql = "SELECT e.emp_id, e.emp_name, p.emp_position_name, d.dept_name "
						+ "FROM emp e "
						+ "LEFT JOIN emp_position p ON e.emp_position_no = p.emp_position_no "
						+ "LEFT JOIN emp_dept_relation edr ON e.emp_id = edr.emp_id "
						+ "LEFT JOIN dept d ON edr.dept_no = d.dept_no;";
				return jdbcTemplate.query(sql, empMapper);
		}
}
