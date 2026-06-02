package com.kh.khsemiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

//게시글 조회이력만 관리하는 DAO
@Repository
public class BoardReadDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	//등록
	public void insert(String empId, long boardNo){
		String sql = "insert into board_read(emp_id, board_no) values(?,?)";
		Object[] params = {empId, boardNo};
		jdbcTemplate.update(sql, params);
	}
	//카운트
	public long count(String empId, long boardNo) {
		String sql = "select count(*) from board_read "
				+ "where emp_id = ? and board_no = ?";
		Object[] params = {empId, boardNo};
		return jdbcTemplate.queryForObject(sql, long.class, params);
	}
}

