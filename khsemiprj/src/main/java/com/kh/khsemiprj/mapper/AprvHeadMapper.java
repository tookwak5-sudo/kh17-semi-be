package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.AprvHeadDto;

@Component
public class AprvHeadMapper implements RowMapper<AprvHeadDto> {
	
	@Override
	public AprvHeadDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return AprvHeadDto.builder()
				.HeadNo(rs.getInt("head_no"))
				.HeadName(rs.getString("head_name"))
				.HeadType(rs.getString("head_type"))
			.build();
	}
}
