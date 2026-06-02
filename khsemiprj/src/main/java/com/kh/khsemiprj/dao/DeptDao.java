package com.kh.khsemiprj.dao;

import java.util.List;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.kh.khsemiprj.dto.DeptDto;
import com.kh.khsemiprj.dto.EmpDto;
import com.kh.khsemiprj.mapper.DeptMapper;

@Repository
public class DeptDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private DeptMapper deptMapper;
	
	
	//부서 등록
	public void insert(DeptDto deptDto) {
		
		// 1. 상위 부서 번호가 있다면 상위 부서의 깊이 조회 후 + 1		
		int depth = 0;
	    if (deptDto.getDeptParentNo() != null) {
	        String depthSql = "SELECT dept_depth FROM dept WHERE dept_no = ?";
	        Integer parentDepth = jdbcTemplate.queryForObject(depthSql, Integer.class, deptDto.getDeptParentNo());
	        depth = (parentDepth != null) ? parentDepth + 1 : 1;
	    }
		
	    // 2. 상위 부서가 없다면 default값(0)
		String sql = "insert into dept(dept_no, dept_parent_no, dept_name, dept_depth, dept_use_yn) "
				+ "values(?, ?, ?, ?, ?)";
		Object[] params = {deptDto.getDeptNo(), deptDto.getDeptParentNo(), deptDto.getDeptName(), depth, deptDto.getDeptUseYn()};
		jdbcTemplate.update(sql, params);
	}

	//부서 전체 조회
	public List<DeptDto> deptList() {
		String sql = "select * from dept order by dept_no asc";
		return jdbcTemplate.query(sql, deptMapper);
	}
	


	public List<DeptDto> selectListAll() {
		String sql = "select * from dept where dept_use_yn = 'Y'";
		Object[] params = {  };
		return jdbcTemplate.query(sql, deptMapper, params);
	}
}

