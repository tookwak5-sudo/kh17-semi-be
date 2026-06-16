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
	
		return AprvFormDto.builder()
                .formNo(rs.getInt("form_no"))
                .formName(rs.getString("form_name"))
                .formExplain(rs.getString("form_explain"))
                .formUseYn(rs.getString("form_use_yn"))
                .formWtime(rs.getTimestamp("form_wtime"))
                .formHeadNo(rs.getInt("form_head_no"))
                .build();
	}
//헤드 네임도 1대1 관계를 맞추기 위해 트라이 캐치 삭제 및 빌더에서 제외시켰습니다.
}
