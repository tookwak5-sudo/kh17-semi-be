package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.BoardDto;

@Repository
public class BoardMapper implements RowMapper<BoardDto>{
	@Override
	public BoardDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		BoardDto boardDto = new BoardDto();
		boardDto.setBoardNo(rs.getLong("board_no"));
		boardDto.setBoardHead(rs.getString("board_head"));
		boardDto.setBoardTitle(rs.getString("board_title"));
		boardDto.setBoardContent(rs.getString("board_content"));
		boardDto.setBoardWriter(rs.getString("board_writer"));
		boardDto.setBoardWtime(rs.getTimestamp("board_wtime"));
		boardDto.setBoardEtime(rs.getTimestamp("board_etime"));
		boardDto.setBoardReadcount(rs.getLong("board_readcount"));
		boardDto.setBoardLikecount(rs.getLong("board_likecount"));
		boardDto.setBoardDislikecount(rs.getLong("board_dislikecount"));
		boardDto.setBoardReplycount(rs.getLong("board_replycount"));
		
		return boardDto;
	}
}
