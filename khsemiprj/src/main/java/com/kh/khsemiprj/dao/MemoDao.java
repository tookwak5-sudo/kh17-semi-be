package com.kh.khsemiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.mapper.MemoMapper;

@Repository
public class MemoDao {
	@Autowired
	JdbcTemplate jdbcTemplate;
	@Autowired
	MemoMapper memoMapper;
}
