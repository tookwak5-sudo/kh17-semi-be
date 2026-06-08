package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.ReplyDto;

@Component
public class ReplyMapper implements RowMapper<ReplyDto>{
	@Override
	public ReplyDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return ReplyDto.builder()
					.replyNo(rs.getLong("reply_no"))
					.replyWriter(rs.getString("reply_writer"))
					.replyOrigin(rs.getLong("reply_origin"))
					.replyContent(rs.getString("reply_content"))
					.replyWtime(rs.getTimestamp("reply_wtime"))
					.replyEtime(rs.getTimestamp("reply_etime"))
					.replyParent(rs.getObject("reply_parent", Long.class))
					.replyStatus(rs.getString("reply_status"))
				.build();
	}
}
