package com.kh.khsemiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class BoardDislikeDao {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	//구현해야하는 기능 : 등록, 삭제, 검사, 개수확인
	
	public void insert(String empId, int boardNo) {
		String sql = "insert into board_dislike(emp_id, board_no) values(?, ?)";
		Object[] params = {empId, boardNo};
		jdbcTemplate.update(sql, params);
	}
	
//	public boolean delete(String empId, int boardNo) {
//		String sql = "delete board_dislike where emp_id=? and board_no=?";
//		Object[] params = {empId, boardNo };
//		return jdbcTemplate.update(sql, params) > 0;
//	}
	
	public boolean check(String empId, int boardNo) {
		String sql = "select count(*) from board_dislike where emp_id=? and board_no=?";
		Object[] params = { empId, boardNo };
		return jdbcTemplate.queryForObject(sql, int.class, params) > 0;
	}
	
	public int count(int boardNo) {
		String sql = "select count(*) from board_dislike where board_no=?";
		Object[] params = {boardNo};
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
}
