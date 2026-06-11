package com.kh.khsemiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class ReplyLikeDao {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	//구현해야하는 기능 : 등록, 삭제, 검사, 개수확인
	
	public void insert(String empId, long replyNo) {
		String sql = "insert into reply_like(emp_id, reply_no) values(?, ?)";
		Object[] params = {empId, replyNo};
		jdbcTemplate.update(sql, params);
	}
	
	public boolean delete(String empId, long replyNo) {
		String sql = "delete reply_like where emp_id=? and reply_no=?";
		Object[] params = {empId, replyNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean check(String empId, long replyNo) {
		String sql = "select count(*) from reply_like where emp_id=? and reply_no=?";
		Object[] params = { empId, replyNo };
		return jdbcTemplate.queryForObject(sql, long.class, params) > 0;
	}
	
	public long count(long replyNo) {
		String sql = "select count(*) from reply_like where reply_no=?";
		Object[] params = {replyNo};
		return jdbcTemplate.queryForObject(sql, long.class, params);
	}
}

