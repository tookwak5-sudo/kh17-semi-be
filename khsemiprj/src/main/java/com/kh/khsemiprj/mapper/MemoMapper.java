package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.dto.MemoDto;

@Component
public class MemoMapper implements RowMapper<MemoDto>{
	@Override
	public MemoDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return MemoDto.builder()
					.memoNo(rs.getInt("memo_no"))
					.memoReceiverId(rs.getString("memo_receiver_id"))
					.memoSenderId(rs.getString("memo_sender_id"))
					.memoTitle(rs.getString("memo_title"))
					.memoContent(rs.getString("memo_content"))
					.memoReadStatus(rs.getString("memo_read_status"))
					.memoType(rs.getString("memo_type"))
					.memoWtime(rs.getTimestamp("memo_wtime"))
				.build();
	}
		
}
