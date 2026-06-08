package com.kh.khsemiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.AprvLineDto;
import com.kh.khsemiprj.mapper.AprvLineMapper;

@Repository
public class AprvLineDao {
	@Autowired
	JdbcTemplate jdbcTemplate;
	@Autowired
	AprvLineMapper aprvLineMapper;
	
	public int sequence() {
		String sql = "select aprv_line_seq.nextval from dual";
		int nextNo = jdbcTemplate.queryForObject(sql, int.class);
		return nextNo;
	}
	
	public boolean insertAprvLine(AprvLineDto aprvLineDto) {
		String sql = "insert into aprv_line(aprv_line_no, aprv_document_no, aprv_line_current_seq, aprv_line_status) "
				+ "values(?, ?, ?, ?)";
		Object[] params = {};
		return jdbcTemplate.update(sql, params) > 0;
	}
}
