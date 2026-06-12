package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.MemoDto;
import com.kh.khsemiprj.mapper.MemoMapper;

@Repository
public class MemoDao {
	@Autowired
	JdbcTemplate jdbcTemplate;
	@Autowired
	MemoMapper memoMapper;
	
	public int sequence() {
	    String sql = "select memo_seq.nextval from dual";
	    return jdbcTemplate.queryForObject(sql, int.class);//정해진 형태 (null 불가)
	}
	
	//쪽지 생성
	public void insert(MemoDto memoDto) {
		String sql = "insert into memo "
				+ "(memo_no, memo_receiver_id, memo_sender_id, memo_title, "
				+ "memo_content, memo_read_status, memo_type) "
				+ "values(?, ?, ?, ?, ?, ?, ?)";
		Object[] params = {
				memoDto.getMemoNo(), memoDto.getMemoReceiverId(), memoDto.getMemoSenderId(), 
				memoDto.getMemoTitle(), memoDto.getMemoContent(), memoDto.getMemoReadStatus(), 
				memoDto.getMemoType()
		};
		jdbcTemplate.update(sql, params);
	}
	
	//쪽지 상세 메소드
	public MemoDto selectOne(int memoNo) {
		String sql = "select * from memo where memo_no = ?";
		Object[] params = { memoNo };
		List<MemoDto> list = jdbcTemplate.query(sql, memoMapper, params);
		return list.isEmpty() ? null:list.get(0);
	}
	
	
}
