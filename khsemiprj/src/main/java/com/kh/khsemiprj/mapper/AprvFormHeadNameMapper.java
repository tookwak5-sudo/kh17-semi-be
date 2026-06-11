package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.AprvFormHeadNameVO;
@Component
public class AprvFormHeadNameMapper implements RowMapper<AprvFormHeadNameVO>{

	@Override
	public AprvFormHeadNameVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		return AprvFormHeadNameVO.builder()
				.headName(rs.getString("head_name"))
				.build();
	}

}
