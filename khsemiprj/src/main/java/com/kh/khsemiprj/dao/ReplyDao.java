package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.ReplyDto;
import com.kh.khsemiprj.mapper.ReplyMapper;
import com.kh.khsemiprj.mapper.ReplyVOMapper;
import com.kh.khsemiprj.vo.ReplyVO;

@Repository
public class ReplyDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private ReplyMapper replyMapper;
	@Autowired
	private ReplyVOMapper replyVOMapper;
	
	//등록 - 2개(시퀀스 생성 및 등록)
	public long sequence() {
		String sql = "select reply_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, long.class);
	}
	public void insert(ReplyDto replyDto) {
		String sql = "insert into reply("
						+ "reply_no, reply_writer, "
						+ "reply_origin, reply_content, reply_parent"
					+ ") values(?, ?, ?, ?, ?)";
		Object[] params = {
			replyDto.getReplyNo(), replyDto.getReplyWriter(),
			replyDto.getReplyOrigin(), replyDto.getReplyContent(), 
			replyDto.getReplyParent()
		};
		jdbcTemplate.update(sql, params);
	}
	// 목록 - 전체목록이 없고 replyOrigin별 목록이 존재
	public List<ReplyVO> selectList(long replyOrigin, String empId) {
		String sql = "select "
				+ "r.*"
				+ ", CASE WHEN rl.emp_id = ? THEN 'Y' ELSE 'N' END AS emp_liked "
				+ ", CASE WHEN rd.emp_id = ? THEN 'Y' ELSE 'N' END AS emp_disliked "
				+ ", rf.attach_no " //댓글 자체의 첨부파일 번호
				+ ", ep.attach_no AS profile_attach_no " //작성자의 프사 파일 번호
				+ "from reply r "
				+ "LEFT JOIN reply_like rl ON rl.reply_no = r.reply_no AND rl.emp_id = ? "
				+ "LEFT JOIN reply_dislike rd ON rd.reply_no = r.reply_no AND rd.emp_id = ? "
				+ "LEFT JOIN reply_file rf ON rf.reply_no = r.reply_no "
				+ "LEFT JOIN emp_profile ep ON ep.emp_id = r.reply_writer "//프사 장부와 연결
				+ "where r.reply_origin = ? "
				+ "order by NVL(r.reply_parent, r.reply_no) asc, r.reply_no asc";
		Object[] params = { empId, empId, empId, empId, replyOrigin };
		return jdbcTemplate.query(sql, replyVOMapper, params);
	}
	//삭제
	public boolean delete(long replyNo) {
		String sql = "update reply set reply_status='Y' where reply_no = ?";
		Object[] params = { replyNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	//수정
	public boolean update(ReplyDto replyDto) {
		String sql = "update reply "
						+ "set reply_content=?, reply_etime=systimestamp "
						+ "where reply_no=?";
		Object[] params = {
			replyDto.getReplyContent(), replyDto.getReplyNo()
		};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//상세 조회
	public ReplyDto selectOne(long replyNo) {
		String sql = "select * from reply where reply_no=?";
		Object[] params = { replyNo };
		List<ReplyDto> list = jdbcTemplate.query(sql, replyMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public boolean updateReplyLikecount(long replyNo) {
		String sql = "update reply set reply_likecount = ("
						+ "select count(*) from reply_like where reply_no = ?"
					+ ") where reply_no = ?";
		Object[] params = { replyNo, replyNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean updateReplyDislikecount(long replyNo) {
		String sql = "update reply set reply_dislikecount = ("
						+ "select count(*) from reply_dislike where reply_no = ?"
					+ ") where reply_no = ?";
		Object[] params = { replyNo, replyNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//AprvFormDao 파쿠리
		public void connect(long replyNo, int attachNo) {
			String sql = "insert into reply_file(reply_no,attach_no) values(?, ?)";
			Object[] params = { replyNo, attachNo };
			jdbcTemplate.update(sql, params);
		}
		
		// 파일 연결 관계 끊어 버리는 메소드
		//AprvFormDao 파쿠리
			public boolean disconnect(long replyNo, int attachNo) {
				String sql = "delete from reply_file where reply_no = ? and attach_no = ?";
				Object[] params = { replyNo, attachNo };
				return jdbcTemplate.update(sql, params) > 0;
			}

			//AprvFormDao 파쿠리
			public Integer findAttachNo(long replyNo) {
				String sql = "select attach_no from reply_file where reply_no=?";
				Object[] params = { replyNo };
				try {
					return jdbcTemplate.queryForObject(sql, Integer.class, params);
				} catch (Exception e) {
					e.getMessage();
					return null;
				}
			}
}








