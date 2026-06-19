package com.kh.khsemiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.EmpDto;
import com.kh.khsemiprj.mapper.EmpMapper;
import com.kh.khsemiprj.vo.PageVO;

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
		String sql = "insert into emp_profile(emp_id, attach_no) values(?, ?)";
		Object[] params = { empId, attachNo };
		jdbcTemplate.update(sql, params);
	}

	//프사 삭제
	public boolean deleteProfile(String empId) {
	    String sql = "delete from emp_profile where emp_id=?";
	    Object[] params = { empId };
	    return jdbcTemplate.update(sql, params) > 0;
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
	
	//승인 대기 목록 조회
	public List<EmpDto> selectEmpByStatus(String empValid) {
		String sql = "select * from emp where emp_valid = 'W'order by emp_hire_date desc";
		
		return jdbcTemplate.query(sql, empMapper);
	}
	
	//승인 거부 메소드
	public boolean rejectEmp(String empId) {
		String sql = "update emp set emp_valid = 'N' where emp_id = ?";
		Object[] params = {empId};
		
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//승인 메소드
	public boolean approveEmp(String empId, String empHireDate, int empPositionNo) {
		String sql = "UPDATE emp "
				+ "SET emp_valid = 'Y', emp_hire_date = ?, "
				+ "emp_position_no = ?, emp_valid_date = SYSTIMESTAMP "
				+ "WHERE emp_id = ?";
		
		Object[] params = {empHireDate, empPositionNo, empId};
		return jdbcTemplate.update(sql, params) > 0;
	}
		

	//아이디찾기
	public EmpDto selectId(String empName, String empEmail) {
		String sql = "select * from emp where emp_name = ? and emp_email = ?";
		Object[] params = {empName, empEmail};
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//비밀번호찾기
	public EmpDto selectPassword(String empId, String empName, String empEmail) {
		String sql = "select * from emp where emp_id = ? and emp_name = ? and emp_email = ?";
		Object[] params = {empId,empName, empEmail};
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	//프로필 이미지 찾기
	public int searchProfile(String empId) {
		String sql = "select attach_no from emp_profile where emp_id=?";
		Object[] params = { empId };
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	public boolean update(EmpDto empDto) {
		String sql = "update emp "
				+ "set emp_email=?,  emp_birth=?, "
					+ "emp_contact=?, emp_post=?, emp_address1=?, "
					+ "emp_address2=?"
				+ "where emp_id=?";
	Object[] params = {
		empDto.getEmpEmail(),
		empDto.getEmpBirth(), empDto.getEmpContact(),
		empDto.getEmpPost(), empDto.getEmpAddress1(),
		empDto.getEmpAddress2(), 
		empDto.getEmpId()
	};
	return jdbcTemplate.update(sql, params) > 0;
	}
	
	public EmpDto selectOneByEmail(String empEmail) {
		String sql = "select * from emp where emp_email = ?";
		Object[] params = {empEmail};
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper,params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public EmpDto selectOneById(String empId) {
		String sql = "select * from emp where emp_id = ?";
		Object[] params = {empId};
		List<EmpDto> list = jdbcTemplate.query(sql,empMapper,params);
		return list.isEmpty() ? null : list.get(0);
	}
	//비밀번호 대조용
	public EmpDto selectOneByPassword(String empPassword) {
		String sql ="select * from emp where emp_password =?";
		Object[] params = {empPassword};
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper,params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public boolean changePassword(EmpDto empDto) {
		String sql="update emp set emp_password = ? where emp_id = ?";
		Object[] params = { empDto.getEmpPassword(), empDto.getEmpId()};
		
		return jdbcTemplate.update(sql,params)>0;
	}

	//관리자->사원정보 수정
	public boolean updateByAdmin(EmpDto empDto, int empPositionNo) {
		String sql = "UPDATE emp "
				   + "SET emp_email = ?, "
				   + "    emp_contact = ?, "
				   + "    emp_post = ?, "
				   + "    emp_address1 = ?, "
				   + "    emp_address2 = ?, "
				   + "    emp_position_no = ? "
				   + "WHERE emp_id = ?";
		
		Object[] params = {
				empDto.getEmpEmail(),
				empDto.getEmpContact(),
				empDto.getEmpPost(),
				empDto.getEmpAddress1(),
				empDto.getEmpAddress2(),
				empPositionNo,
				empDto.getEmpId()
		};
		
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//회원 퇴사 처리
	public boolean insertEmpExit(String empId, String exitDate) {
		String sql = "insert into emp_exit(emp_id, emp_exit_time) values(?, ?)";
		Object[] params = { empId, exitDate };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//관리자 목록 가져오기
	public List<EmpDto> selectAdminList() {
		String sql = "select * from emp where emp_valid = 'Y' and emp_grade = 2 ";
		Object[] params = {};
		return jdbcTemplate.query(sql, empMapper, params);
	}
	
	//로그인한 직원의 로그인 시각 업데이트
	public boolean updateLoginTime(String empId) {
		String sql = "update emp set emp_login = systimestamp where emp_id = ?";
		Object[] params = {empId};
		return jdbcTemplate.update(sql, params) > 0;
	}
}
