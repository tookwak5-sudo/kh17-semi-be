package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.AprvFormHeadTypeVO;
@Component
public class AprvFormHeadTypeMapper implements RowMapper<AprvFormHeadTypeVO> {

	@Override
	public AprvFormHeadTypeVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		return AprvFormHeadTypeVO.builder()
				.headType(rs.getString("head_type"))
				.build();
	}

}
