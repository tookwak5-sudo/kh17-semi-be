package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.AprvFormSelectHomeListVO;
@Component
public class AprvFormSelectHomeListMapper implements RowMapper<AprvFormSelectHomeListVO> {

	@Override
	public AprvFormSelectHomeListVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		return AprvFormSelectHomeListVO.builder()
		.formNo(rs.getInt("formNo"))         
        .formName(rs.getString("formName"))
        .headName(rs.getString("headName"))
        .aprvTitle(rs.getString("aprvTitle"))
        .aprvWriter(rs.getString("aprvWriter"))
        .aprvSdate(rs.getTimestamp("aprvSdate"))
        .aprvEdate(rs.getTimestamp("aprvEdate"))
        .build();
	}

	

}
