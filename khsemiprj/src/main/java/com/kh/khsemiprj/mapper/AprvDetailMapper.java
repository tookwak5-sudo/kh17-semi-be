package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import com.kh.khsemiprj.vo.AprvDetailVO;


@Component
public class AprvDetailMapper implements RowMapper<AprvDetailVO> {
	@Override
	public AprvDetailVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		return AprvDetailVO.builder()
				.aprvNo(rs.getInt("aprv_no"))
				.aprvWriter(rs.getString("aprv_writer"))
				.aprvFormNo(rs.getInt("aprv_form_no"))
				.aprvTitle(rs.getString("aprv_title"))
				.aprvContent(rs.getString("aprv_content"))
				.aprvStatus(rs.getString("aprv_status"))
				.aprvCurrentSeq(rs.getInt("aprv_current_seq"))
				.aprvTempWtime(rs.getTimestamp("aprv_temp_wtime"))
				.aprvTempUtime(rs.getTimestamp("aprv_temp_utime"))
				.aprvSdate(rs.getString("aprv_sdate"))
				.aprvEdate(rs.getString("aprv_edate"))
				.aprvWtime(rs.getTimestamp("aprv_wtime"))
				.aprvEtime(rs.getTimestamp("aprv_etime"))
				.aprvLeave(rs.getObject("aprv_leave", Double.class))
				.headNo(rs.getInt("head_no"))
				.headName(rs.getString("head_name"))
				.deptNo(rs.getLong("dept_no"))
				.empName(rs.getString("emp_name"))
				.empPositionName(rs.getString("emp_position_name"))
				.deptName(rs.getString("dept_name"))
				.build();
	}
}