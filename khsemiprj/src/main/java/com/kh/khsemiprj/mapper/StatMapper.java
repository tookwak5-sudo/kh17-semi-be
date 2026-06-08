package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.StatVO;

@Component
public class StatMapper implements RowMapper<StatVO>{
	@Override
	public StatVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		return StatVO.builder()
					.title(rs.getString("title"))
					.value(rs.getDouble("value"))
				.build();
	}
}




