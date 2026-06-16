package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.AprvFormSelectVO;
@Component
public class AprvFormSelectMapper implements RowMapper<AprvFormSelectVO>{

	@Override
	public AprvFormSelectVO mapRow(ResultSet rs, int rowNum) throws SQLException {
	
		return AprvFormSelectVO.builder()
                .formNo(rs.getInt("form_no"))
                .formName(rs.getString("form_name"))
                .formExplain(rs.getString("form_explain"))
                .formUseYn(rs.getString("form_use_yn"))
                .formWtime(rs.getTimestamp("form_wtime"))
                .formHeadNo(rs.getInt("form_head_no"))
                .headName(rs.getString("head_name")) //조인 시 필요합니다.
                .headType(rs.getString("head_type"))//조인을 이용한 타입명 검색 시에 필요합니다.
                .build(); 
	}

}
