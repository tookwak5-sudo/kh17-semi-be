package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.EmpLeaveDto;
import com.kh.khsemiprj.mapper.EmpLeaveMapper;
import com.kh.khsemiprj.mapper.LeaveCalMapper;
import com.kh.khsemiprj.vo.LeaveCalVO;

//아직 더미데이터의 목록만 보여주는 정도의 dao입니다
@Repository
public class EmpLeaveDao {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EmpLeaveMapper empLeaveMapper;
	@Autowired
	private LeaveCalMapper leaveCalMapper;
	
	//회원가입이 되면 자동으로 휴가DB에 등록
	public void insert(String leaveEmpId) {
		String sql = "insert into emp_leave(leave_emp_id) "
				+ "values(?)";
		Object[] params = { leaveEmpId };
		jdbcTemplate.update(sql, params);
	}
	
	public List<EmpLeaveDto> selectList(String leaveEmpId) {
		if (leaveEmpId == null)
			return null;
		String sql = "select * from emp_leave " 
				+ "where leave_emp_id = ? order by leave_year desc";
		Object[] params = { leaveEmpId };

		return jdbcTemplate.query(sql, empLeaveMapper, params);

	}
	
	// [1] 입사일을 포함하여 전 직원 휴가 날짜 조회
	public List<LeaveCalVO> selectAll(){
		String sql = "select "
				+ "l.leave_emp_id, l.leave_total, l.leave_used, "
				+ "l.leave_remain, l.leave_update, e.emp_hire_date "
				+ "from emp_leave l "
				+ "join emp e on l.leave_emp_id = e.emp_id "
				+ "order by e.emp_hire_date asc";
		return jdbcTemplate.query(sql, leaveCalMapper);
	}
	
	// [2] 업데이트한 직원의 휴가일수를 DB에 저장
	public void updateLeave(String empId, double leaveTotal) {
		String sql = "update emp_leave set leave_total = ? where leave_emp_id";
	}
	
	public EmpLeaveDto selectOne(String empId) {
		String sql = "select * from emp_leave where leave_emp_id = ?";
		Object[] params = { empId};
		List<EmpLeaveDto> list = jdbcTemplate.query(sql,  empLeaveMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

}
