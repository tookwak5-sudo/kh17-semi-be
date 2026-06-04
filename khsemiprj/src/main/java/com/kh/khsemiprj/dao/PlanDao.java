package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.PlanDto;
import com.kh.khsemiprj.mapper.PlanMapper;

@Repository
public class PlanDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private PlanMapper planMapper;
	
	public int sequence() {
	    String sql = "select plan_seq.nextval from dual";
	    return jdbcTemplate.queryForObject(sql, int.class);//정해진 형태 (null 불가)
	}
	
	//일정 등록
	public void insert(PlanDto planDto) {
		String sql = "insert into plan "
				+ "(plan_no, plan_emp_id, plan_aprv_no, plan_dept_no, plan_name, "
				+ "plan_type, plan_explain, plan_sdate, plan_edate) "
				+ "values(?, ?, ?, ?, ?, ? ,?, ? ,?)";
		Object[] params = { planDto.getPlanNo(), 
				planDto.getPlanEmpId(), planDto.getPlanAprvNo(), planDto.getPlanDeptNo(),
				planDto.getPlanName(), planDto.getPlanType(), planDto.getPlanExplain(), 
				planDto.getPlanSdate(), planDto.getPlanEdate()
		};
		jdbcTemplate.update(sql, params);
	}
	
	//일정 수정
	public boolean update(PlanDto planDto) {
		String sql = "update plan set "
				+ "plan_name=?, plan_type=?, plan_explain=?, plan_sdate=?, plan_edate=? "
				+ "where plan_no = ?";
		Object[] params = {
				planDto.getPlanName(), planDto.getPlanType(), planDto.getPlanExplain(), 
				planDto.getPlanSdate(), planDto.getPlanEdate(), planDto.getPlanNo()
		};
		return jdbcTemplate.update(sql, params)> 0;
	}
	
	//일정 삭제
	public boolean delete(int planNo) {
		String sql = "delete plan where plan_no=?";
		Object[] params = { planNo };
		return jdbcTemplate.update(sql, params)>0;
	}
	
	//일정 상세
	public PlanDto selectOne(int planNo) {
		String sql = "select * from plan where plan_no = ?";
		Object[] params = { planNo };
		List<PlanDto> list = jdbcTemplate.query(sql,  planMapper, params);
		return list.isEmpty() ? null : list.get(0);
	} 
	
}
