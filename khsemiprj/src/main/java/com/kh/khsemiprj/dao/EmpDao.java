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
		
	
		public void join(EmpDto empDto) {
			String sql = "insert into emp( "
					+ "emp_id, emp_email, emp_password, emp_name, emp_birth, "
					+ "emp_contact, emp_post, emp_address1, emp_address2)"
					+ "values(?,?,?,?,?,?,?,?,?)";
			Object[] params = {
					empDto.getEmpId(),empDto.getEmpEmail(),empDto.getEmpPassword(),
					empDto.getEmpName(),empDto.getEmpBirth(),empDto.getEmpContact(),
					empDto.getEmpPost(),empDto.getEmpAddress1(),empDto.getEmpAddress2()
				
			};
			jdbcTemplate.update(sql, params);
		}
		
	
		public EmpDto selectOne(String loginId) {
			String sql = "select * from emp where emp_id = ?";
			Object[] params = { loginId };
			List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
			return list.isEmpty() ? null : list.get(0);
		}

	
		//사원 전체 조회
		public List<EmpDto> empList() {
			String sql = "select * from emp order by emp_id asc";
			return jdbcTemplate.query(sql, empMapper);
		}

		public void connect(String empId, int attachNo) {
			String sql = "insert into member_profile(emp_id, attach_no) values(?, ?)";
			Object[] params = { empId, attachNo };
			jdbcTemplate.update(sql, params);
		}
	
		/*
		 * public List<EmpDto> selectList(){ String sql =
		 * "select * from emp order by emp_id asc"; return jdbcTemplate.query(sql,
		 * empMapper); } //검색 public List<EmpDto> selectList(String column, String
		 * keyword) { if(column == null || keyword == null || column.isEmpty() ||
		 * keyword.isEmpty()) return selectList();
		 * 
		 * String sql = "select * from emp " + "where instr("+column+", ?) > 0 " +
		 * "order by "+column+" asc, emp_id asc"; Object[] params = {keyword}; return
		 * jdbcTemplate.query(sql, empMapper, params); }
		 */
		
		
	//아이디찾기
	public EmpDto selectId(String empName, String empEmail) {
		String sql = "select * from emp where emp_name = ? and emp_email = ?";
		Object[] params = {empName, empEmail};
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//프로필 이미지 찾기
		public int searchProfile(String empId) {
			String sql = "select attach_no from emp_profile where emp_id=?";
			Object[] params = { empId };
			return jdbcTemplate.queryForObject(sql, int.class, params);
		}
	
}
