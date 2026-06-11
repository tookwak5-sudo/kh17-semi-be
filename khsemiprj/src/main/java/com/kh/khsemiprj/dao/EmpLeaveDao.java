package com.kh.khsemiprj.dao;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.EmpLeaveDto;
import com.kh.khsemiprj.mapper.EmpLeaveMapper;
import com.kh.khsemiprj.mapper.LeaveManageMapper;
import com.kh.khsemiprj.vo.LeaveManageVO;

//아직 더미데이터의 목록만 보여주는 정도의 dao입니다
@Repository
public class EmpLeaveDao {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EmpLeaveMapper empLeaveMapper;
	@Autowired
	private LeaveManageMapper leaveManageMapper;
	
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
	public List<LeaveManageVO> selectAll(){
		String sql = "select "
				+ "l.leave_emp_id, l.leave_total, l.leave_used, "
				+ "l.leave_remain, l.leave_update, e.emp_hire_date "
				+ "from emp_leave l "
				+ "join emp e on l.leave_emp_id = e.emp_id "
				+ "order by e.emp_hire_date asc";
		return jdbcTemplate.query(sql, leaveManageMapper);
	}
	
	// [1] (1년차 이상) 오늘이 입사기념일인 사원들 조회
	public List<LeaveManageVO> selectTarget() {
		String sql = "select "
				+ "e.emp_id, e.emp_hire_date, l.leave_total, "
				+ "l.leave_used, l.leave_remain, l.leave_update "
				+ "from emp e "
				+ "join emp_leave l on e.emp_id = l.leave_emp_id "
				+ "where substr(emp_hire_date, 6, 5) = to_char(sysdate, 'MM-DD') "
				+ "and "
				+ "to_date(emp_hire_date, 'YYYY-MM-DD') <= add_months(sysdate, - 12)";
		return jdbcTemplate.query(sql,  leaveManageMapper);
	}
	
	// [2] 업데이트한 직원의 휴가일수를 DB에 저장
		public boolean updateLeave(LeaveManageVO leaveManageVO) {
			String sql = "update emp_leave set "
					+ "leave_year, leave_total=?, leave_used=?, leave_remain=?, leave_update= ? "
					+ "where leave_emp_id";
			Object[] params = {
					leaveManageVO.getLeaveYear(), leaveManageVO.getLeaveTotal(), 
					leaveManageVO.getLeaveUsed(), leaveManageVO.getLeaveRemain(),
					leaveManageVO.getLeaveUpdate(), leaveManageVO.getLeaveEmpId()
			};
			return jdbcTemplate.update(sql, leaveManageMapper, params) > 0;
		}
	
	public EmpLeaveDto selectOne(String empId) {
		String sql = "select * from emp_leave where leave_emp_id = ?";
		Object[] params = { empId};
		List<EmpLeaveDto> list = jdbcTemplate.query(sql,  empLeaveMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

}
