package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.EmpPositionDto;
import com.kh.khsemiprj.mapper.EmpPositionMapper;

@Repository
public class EmpPositionDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EmpPositionMapper empPositionMapper;
	
	//직급 이름, 숫자 조회
		public List<EmpPositionDto> positionSelectList(){
			String sql = "select emp_position_no, emp_position_name, emp_position_level "
		               + "from emp_position "
		               + "order by emp_position_level asc";
		    return jdbcTemplate.query(sql, empPositionMapper);
		}
}
