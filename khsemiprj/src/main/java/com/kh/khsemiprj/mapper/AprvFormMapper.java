package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.AprvFormDto;
@Component
public class AprvFormMapper implements RowMapper<AprvFormDto>{

	@Override
	public AprvFormDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		String headName = "";
		try {
			headName = rs.getString("head_name");
		} catch(Exception e) {
			e.printStackTrace();
		}
		return AprvFormDto.builder()
                .formNo(rs.getInt("form_no"))
                .formName(rs.getString("form_name"))
                .formExplain(rs.getString("form_explain"))
                .formUseYn(rs.getString("form_use_yn"))
                .formWtime(rs.getTimestamp("form_wtime"))
                .formHeadNo(rs.getInt("form_head_no"))
                .headName(headName)
                .build();
	}

}
