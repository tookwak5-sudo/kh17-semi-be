package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.AprvFormVO;
@Component
public class AprvFormVOMapper implements RowMapper<AprvFormVO>{

	@Override
	public AprvFormVO mapRow(ResultSet rs, int rowNum) throws SQLException {
	
		return AprvFormVO.builder()
                .formNo(rs.getInt("form_no"))
                .formName(rs.getString("form_name"))
                .formExplain(rs.getString("form_explain"))
                .formUseYn(rs.getString("form_use_yn"))
                .formWtime(rs.getTimestamp("form_wtime"))
                .formHeadNo(rs.getInt("form_head_no"))
                .headName(rs.getString("head_name"))
                .build();
	}
}
