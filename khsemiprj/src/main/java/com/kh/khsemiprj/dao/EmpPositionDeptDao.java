package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.EmpPositionDeptDto;
import com.kh.khsemiprj.mapper.EmpMapper;
import com.kh.khsemiprj.mapper.EmpPositionDeptMapper;

@Repository
public class EmpPositionDeptDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EmpPositionDeptMapper empPositionDepthMapper;
			
	// 사원아이디를 통해 사원의 직책, 부서 조회 //  부서가 입력되면  그 부서에 해당되는 사원 출력
		public List<EmpPositionDeptDto> selectDepthEmp(int deptNo) {
				String sql = "SELECT e.emp_id, e.emp_name, p.emp_position_name, p.emp_position_level, d.dept_no, d.dept_name "
						+ "FROM emp e "
						+ "LEFT JOIN emp_position p ON e.emp_position_no = p.emp_position_no "
						+ "LEFT JOIN emp_dept_relation edr ON e.emp_id = edr.emp_id "
						+ "LEFT JOIN dept d ON edr.dept_no = d.dept_no where d.dept_no = ?";
				Object[] params = {deptNo};
 				return jdbcTemplate.query(sql, empPositionDepthMapper, params);
		}
		
	//사원 목록 조회
	public List<EmpPositionDeptDto> selectList() {
		String sql = "SELECT e.emp_id, e.emp_name, e.emp_position_no, p.emp_position_name, p.emp_position_level, d.dept_no, d.dept_name "
				+ "FROM emp e "
				+ "LEFT JOIN emp_position p ON e.emp_position_no = p.emp_position_no "
				+ "LEFT JOIN emp_dept_relation edr ON e.emp_id = edr.emp_id "
				+ "LEFT JOIN dept d ON edr.dept_no = d.dept_no "
				+ "ORDER BY e.emp_id asc";
		
		return jdbcTemplate.query(sql, empPositionDepthMapper);
	}
	
	
	//사원 목록 검색
		public List<EmpPositionDeptDto> selectList(String column, String keyword) {
			if (column == null || keyword == null || column.isEmpty() || keyword.isEmpty()) {
				return selectList();
			}
			
			String sql = "SELECT e.emp_id, e.emp_name, e.emp_position_no, p.emp_position_name, p.emp_position_level, d.dept_no, d.dept_name "
					+ "FROM emp e "
					+ "LEFT JOIN emp_position p ON e.emp_position_no = p.emp_position_no "
					+ "LEFT JOIN emp_dept_relation edr ON e.emp_id = edr.emp_id "
					+ "LEFT JOIN dept d ON edr.dept_no = d.dept_no "
					+ "WHERE instr(" + column + ", ?) >0 "
					+ "ORDER BY " + column + " asc, e.emp_id asc";
			
			Object[] params = {keyword};
			return jdbcTemplate.query(sql, empPositionDepthMapper, params);
		}
		
	//사원 상세
		public EmpPositionDeptDto selectOne(String empId) {
			String sql = "SELECT e.emp_id, e.emp_name, e.emp_position_no, p.emp_position_name, p.emp_position_level, d.dept_no, d.dept_name "
					+ "FROM emp e "
					+ "LEFT JOIN emp_position p ON e.emp_position_no = p.emp_position_no "
					+ "LEFT JOIN emp_dept_relation edr ON e.emp_id = edr.emp_id "
					+ "LEFT JOIN dept d ON edr.dept_no = d.dept_no "
					+ "WHERE e.emp_id = ?";
			
			Object[] params = {empId};
			List<EmpPositionDeptDto> list = jdbcTemplate.query(sql, empPositionDepthMapper, params);
			
			return list.isEmpty() ? null : list.get(0);
		}
		
	//직책 수정
	public boolean updateByMaster(EmpPositionDeptDto empPositionDeptDto) {
		String sql = "update emp set emp_position_no = ? where emp_id = ?";
		Object[] params = {empPositionDeptDto.getEmpPositionNo(),
						   empPositionDeptDto.getEmpId()};
		
		return jdbcTemplate.update(sql, params) > 0;
	}
	
}
