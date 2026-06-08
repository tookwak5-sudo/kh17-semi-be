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

	public List<EmpPositionDeptDto> selectDepthEmp(Long deptNo) {
		String sql = "SELECT e.emp_id, e.emp_name, p.emp_position_name, p.emp_position_level, p.emp_position_no, d.dept_no, d.dept_name, d.dept_emp_id "
				+ "FROM emp e "
				+ "LEFT JOIN emp_position p ON e.emp_position_no = p.emp_position_no "
				+ "LEFT JOIN emp_dept_relation edr ON e.emp_id = edr.emp_id "
				+ "LEFT JOIN dept d ON edr.dept_no = d.dept_no where d.dept_no = ? "
				+ "order by e.emp_grade desc, p.emp_position_no asc, e.emp_name asc";
		Object[] params = {deptNo};
		return jdbcTemplate.query(sql, empPositionDepthMapper, params);
	}
	
	//부서 없는 사원 목록 조회
	public List<EmpPositionDeptDto> selectDepthEmpByNull() {
		String sql = "SELECT e.emp_id, e.emp_name, p.emp_position_name, p.emp_position_level, p.emp_position_no, d.dept_no, d.dept_name, d.dept_emp_id "
				+ "FROM emp e "
				+ "LEFT JOIN emp_position p ON e.emp_position_no = p.emp_position_no "
				+ "LEFT JOIN emp_dept_relation edr ON e.emp_id = edr.emp_id "
				+ "LEFT JOIN dept d ON edr.dept_no = d.dept_no where d.dept_no is null";
		Object[] params = {};
		return jdbcTemplate.query(sql, empPositionDepthMapper, params);
	}
	
	//결재라인 사원목록 가져오기(조회사원의 직급보다 상급자만 가져오도록)
	public List<EmpPositionDeptDto> selectDepthEmpForAprv(Long deptNo, Integer empPosition) {
		String sql = "SELECT e.emp_id, e.emp_name, p.emp_position_name, p.emp_position_level, p.emp_position_no, d.dept_no, d.dept_name, d.dept_emp_id "
				+ "FROM emp e "
				+ "LEFT JOIN emp_position p ON e.emp_position_no = p.emp_position_no and e.emp_position_no IS NOT NULL "
				+ "LEFT JOIN emp_dept_relation edr ON e.emp_id = edr.emp_id "
				+ "LEFT JOIN dept d ON edr.dept_no = d.dept_no where d.dept_no = ? and e.emp_position_no >= ?"
				+ "order by e.emp_grade desc, p.emp_position_no desc, e.emp_name asc";
		Object[] params = {deptNo,empPosition};
		return jdbcTemplate.query(sql, empPositionDepthMapper, params);
	}
	
	//해당 부서 부서장 아이디 조회
	public String checkDeptEmpId(long deptNo) {
		String sql = "select dept_emp_id from dept where dept_no = ?";
		Object[] params = { deptNo };
		return jdbcTemplate.queryForObject(sql, String.class, params);
	}
	
	//사원의 소속 부서 등록
	public boolean empPositionDeptInsert(String empId, long deptNo) {
		String sql = "insert into emp_dept_relation(emp_id, dept_no) values(?, ?)";
		Object[] params = { empId, deptNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//사원의 소속 부서 변경
	public boolean empPositionDeptUpdate(String empId, long deptNo) {
		String sql = "update emp_dept_relation set dept_no = ? where emp_id = ?";
		Object[] params = { deptNo, empId };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//사원의 소속 부서 삭제
	public boolean empPositionDeptDelete(String empId) {
		String sql = "delete emp_dept_relation where emp_id = ?";
		Object[] params = { empId };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//해당 부서 부서장 제거
	public boolean deptEmpIdReset(long deptNo) {
		String sql = "update dept set dept_emp_id = null where dept_no = ?";
		Object[] params = { deptNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//해당 부서 부서장 변경
	public boolean deptEmpIdUpdate(long deptNo, String empId) {
		String sql = "update dept set dept_emp_id = ? where dept_no = ?";
		Object[] params = { empId, deptNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//사원의 권한 상승
	public boolean empGradePromotion(String empId) {
		String sql = "update emp set emp_grade = 1 where emp_id = ? and emp_grade <= 1";
		Object[] params = { empId };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//사원의 권한 강등
	public boolean empGradeDemotion(String empId) {
		String sql = "update emp set emp_grade = 0 where emp_id = ? and emp_grade <= 1";
		Object[] params = { empId };
		return jdbcTemplate.update(sql, params) > 0;
	}
  
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
		String sql = "SELECT e.emp_id, e.emp_name, e.emp_position_no, e.emp_grade, p.emp_position_name, p.emp_position_level, d.dept_no, d.dept_name, d.dept_emp_id "
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
			
			String sql = "SELECT e.emp_id, e.emp_name, e.emp_position_no, e.emp_grade, p.emp_position_name, p.emp_position_level, d.dept_no, d.dept_name, d.dept_emp_id "
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
			String sql = "SELECT e.emp_id, e.emp_name, e.emp_position_no, e.emp_grade, p.emp_position_name, p.emp_position_level, d.dept_no, d.dept_name, d.dept_emp_id "
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


