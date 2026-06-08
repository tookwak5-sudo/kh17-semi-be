package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.AprvLineDto;

@Component
public class AprvLineMapper implements RowMapper<AprvLineDto> {
	@Override
	public AprvLineDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return AprvLineDto.builder()
				.aprvLineNo(rs.getInt("aprv_line_no"))
				.aprvDocumentNo(rs.getInt("aprv_document_no"))
				.aprvLineCurrentSeq(rs.getInt("aprv_line_current_seq"))
				.aprvLineStatus(rs.getString("aprv_line_status"))
				.aprvLineComment(rs.getString("aprv_line_comment"))
				.aprvLineDate(rs.getTimestamp("aprv_line_date"))
				.empId(rs.getString("emp_id"))
				.build();
	}
}
