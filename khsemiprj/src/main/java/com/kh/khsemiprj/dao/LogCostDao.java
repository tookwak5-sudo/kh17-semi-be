package com.kh.khsemiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.LogAccessDto;
import com.kh.khsemiprj.dto.LogCostDto;
import com.kh.khsemiprj.mapper.LogCostMapper;

@Repository
public class LogCostDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired 
	private LogCostMapper logCostMapper;
	
	//입력 메소드
	public void insert(LogCostDto logCostDto) {
		String sql = "insert into log_cost "
				+ "(log_cost_no, log_emp_id, log_aprv_document_no, log_cost_used, log_aprv_record, log_cost_wtime) "
				+ "values(log_cost_seq.nextval, ?, ?, ?, ?, systimestamp)";
		Object[] params = {
				logCostDto.getLogEmpId(), logCostDto.getLogAprvDocumentNo(), logCostDto.getLogCostUsed(), logCostDto.getLogAprvRecord()
		};
		jdbcTemplate.update(sql, params);
	}
}
