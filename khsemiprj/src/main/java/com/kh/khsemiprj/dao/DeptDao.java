package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.DeptDto;
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
		String sql = "select * from dept where dept_use_yn = 'Y' order by dept_no asc";
		return jdbcTemplate.query(sql, deptMapper);
	}
	
	public List<DeptDto> selectListAll() {
		String sql = "select * from dept where dept_use_yn = 'Y' order by dept_name asc";
		Object[] params = {  };
		return jdbcTemplate.query(sql, deptMapper, params);
	}
	
	//내 부서와 관련된 부서만 조회
	public List<DeptDto> selectListMyDept(String empId) {
		String sql = 
				"WITH TargetDept AS ( "
				+ "    SELECT dept_no "
				+ "    FROM emp_dept_relation "
				+ "    WHERE emp_id = ? "//파라미터를 가장 위로 올림
				+ ") "
				+ "SELECT * FROM ("
				+ "SELECT dept_no, dept_parent_no, dept_name, dept_depth, dept_use_yn, dept_emp_id "
				+ "FROM dept "
				+ "START WITH dept_no = (SELECT dept_no FROM TargetDept) "
				+ "CONNECT BY PRIOR dept_parent_no = dept_no "//부모 쪽으로 거슬러 올라감
				+ "UNION "
				+ "SELECT dept_no, dept_parent_no, dept_name, dept_depth, dept_use_yn, dept_emp_id "
				+ "FROM dept "
				+ "START WITH dept_no = (SELECT dept_no FROM TargetDept) "
				+ "CONNECT BY PRIOR dept_no = dept_parent_no "//자식 쪽으로 내려감
				+ ") "
				+ "ORDER BY dept_depth ASC";
		Object[] params = { empId };
		return jdbcTemplate.query(sql, deptMapper, params);
	}
	
	// 부서 상세 조회
	public DeptDto selectOne(long deptNo) {
		String sql = "select * from dept where dept_no = ?";
		Object[] params = { deptNo };
		List<DeptDto> list = jdbcTemplate.query(sql, deptMapper, params);
		return list.isEmpty() ? null : list.get(0);		
	}
	
	// 부서 수정
	public boolean update(DeptDto deptDto) {
		String sql = "update dept "
				+ "set dept_parent_no = ?, "
				+ "dept_name = ?, "
				+ "dept_use_yn = ? "
				+ "where dept_no = ?";
		Object[] params = {
				deptDto.getDeptParentNo(), deptDto.getDeptName(), 
				deptDto.getDeptUseYn(), deptDto.getDeptNo()};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	// 부서 삭제
	public boolean delete(long deptNo) {
		String sql = "delete dept where dept_no = ?";
		Object[] params = {deptNo};
		return jdbcTemplate.update(sql, params) > 0;
	}
}

