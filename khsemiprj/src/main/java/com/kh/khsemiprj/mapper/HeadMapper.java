package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.EmpPositionDeptDto;
import com.kh.khsemiprj.dto.HeadDto;

@Component
public class HeadMapper implements RowMapper<HeadDto>  {

	@Override
	public HeadDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return HeadDto.builder()
				.headNo(rs.getInt("head_no"))
				.headName(rs.getString("head_name"))
				.headType(rs.getString("head_type"))
			.build();
	}
	
}
