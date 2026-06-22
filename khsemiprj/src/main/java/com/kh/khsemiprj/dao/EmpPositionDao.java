package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.AprvHeadDto;
import com.kh.khsemiprj.dto.EmpPositionDto;
import com.kh.khsemiprj.mapper.EmpPositionMapper;

@Repository
public class EmpPositionDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EmpPositionMapper empPositionMapper;
	
	public int sequence() {
		String sql = "select emp_position_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	
	//직급 이름, 숫자 조회
	public List<EmpPositionDto> positionSelectList(){
		String sql = "select emp_position_no, emp_position_name, emp_position_level "
	               + "from emp_position "
	               + "order by emp_position_level asc";
	    return jdbcTemplate.query(sql, empPositionMapper);
	}
		
	//직급 관련 인서트
	public void insert(EmpPositionDto empPositionDto) {
		String sql = "insert into emp_position(emp_position_no, emp_position_name, emp_position_level) "
				+ "values(?, ?, ?)";
		
		Object[] params = {empPositionDto.getEmpPositionNo(),empPositionDto.getEmpPositionName(),empPositionDto.getEmpPositionLevel()};
		jdbcTemplate.update(sql,params);
	}
		
	//직급 삭제
	public boolean delete(int empPositionNo) {
		String sql = "delete emp_position where emp_position_no=?";
		Object[] params = { empPositionNo };
		return jdbcTemplate.update(sql, params)>0;
	}
	
	//입력된 직급이름으로 같은 직급 이름이 있는 지 조회
	public EmpPositionDto selectOneByName(String positionName) {
		String sql = "select * from emp_position where emp_position_name = ? ";
		Object[] params = {positionName};
		List<EmpPositionDto> list = jdbcTemplate.query(sql, empPositionMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	//입력된 직급레벨로 같은 직급 레벨이 있는 지 조회
		public EmpPositionDto selectOneByLevel(int positionLevel) {
			String sql = "select * from emp_position where emp_position_level = ? ";
			Object[] params = {positionLevel};
			List<EmpPositionDto> list = jdbcTemplate.query(sql, empPositionMapper, params);
			return list.isEmpty() ? null : list.get(0);
		}
}
