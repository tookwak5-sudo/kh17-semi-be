package com.kh.khsemiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class LogCostDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	/*
	 * @Autowired private LogCostDto logCostDto;
	 * 
	 * @Autowired private LogCostMapper logCostMapper;
	 */
}
