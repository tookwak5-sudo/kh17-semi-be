package com.kh.khsemiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.khsemiprj.vo.ReplyVO;

@Component
public class ReplyVOMapper implements RowMapper<ReplyVO>{
	@Override
	public ReplyVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		return ReplyVO.builder()
					.replyNo(rs.getLong("reply_no"))
					.replyWriter(rs.getString("reply_writer"))
					.replyOrigin(rs.getLong("reply_origin"))
					.replyContent(rs.getString("reply_content"))
					.replyWtime(rs.getTimestamp("reply_wtime"))
					.replyEtime(rs.getTimestamp("reply_etime"))
					.replyParent(rs.getObject("reply_parent", Long.class))
					.replyStatus(rs.getString("reply_status"))
					.replyLikecount(rs.getLong("reply_likecount"))
					.replyDislikecount(rs.getLong("reply_dislikecount"))
					.empLiked(rs.getString("emp_liked"))
					.empDisliked(rs.getString("emp_disliked"))
					.attachNo(rs.getObject("attach_no", Integer.class))
					.profileAttachNo(rs.getObject("profile_attach_no", Integer.class))
				.build();
	}
}
