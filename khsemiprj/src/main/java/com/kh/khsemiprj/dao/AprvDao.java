package com.kh.khsemiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.AprvDto;
import com.kh.khsemiprj.mapper.AprvMapper;

@Repository
public class AprvDao {
	@Autowired
	JdbcTemplate jdbcTemplate;
	@Autowired
	AprvMapper aprvMapper;
	
	public int sequence() {
		String sql = "select aprv_no_seq.nextval from dual";
		int nextNo = jdbcTemplate.queryForObject(sql, int.class);
		return nextNo;
	}
	
	public boolean insertAprv(AprvDto aprvDto) {
		String sql = "insert into aprv_document(aprv_no, aprv_writer, aprv_form_no, aprv_title, aprv_content, aprv_status, aprv_current_seq, aprv_sdate, aprv_edate) "
				+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = { aprvDto.getAprvNo(), aprvDto.getAprvWriter(), aprvDto.getAprvFormNo()
							, aprvDto.getAprvTitle(), aprvDto.getAprvContent(), aprvDto.getAprvStatus()
							, aprvDto.getAprvCurrentSeq(), aprvDto.getAprvSdate(), aprvDto.getAprvEdate() };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public void connect(int aprvNo, int attachNo) {
		String sql = "insert into document_file(aprv_no, attach_no) values(?, ?)";
		Object[] params = { aprvNo, attachNo };
		jdbcTemplate.update(sql, params);
	}
}
