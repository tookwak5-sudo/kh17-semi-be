package com.kh.khsemiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.BoardDto;
import com.kh.khsemiprj.mapper.BoardMapper;
import com.kh.khsemiprj.vo.PageVO;

@Repository
public class BoardDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private BoardMapper boardMapper;
	
	//검색 허용할 컬럼
	private Set<String> allowColumns = Set.of("board_writer", "board_title");
	
	//목록 및 조회
	public List<BoardDto> selectList(int page, int size) {
		String sql = "select * from ("
						+ "select rownum rn, TMP.* from ("
							+ "select * from board "
							+ "order by board_no desc"
						+ ") TMP"
					+ ") where rn between ? and ?";
		int beginRow = page * size - (size-1);
		int endRow = page * size;
		Object[] params = { beginRow , endRow };		
		return jdbcTemplate.query(sql, boardMapper, params);
	}
	public List<BoardDto> selectList(PageVO pageVO) {
		if(pageVO.isList())
			return selectList(pageVO.getPage(), pageVO.getSize());
		if(!allowColumns.contains(pageVO.getColumn()))
			return selectList(pageVO.getPage(), pageVO.getSize());
		
		String sql = "select * from ("
						+ "select rownum rn, TMP.* from ("
							+ "select * from board "
							+ "where instr("+pageVO.getColumn()+", ?) > 0 "
							+ "order by board_no asc"
						+ ") TMP"
					+ ") where rn between ? and ?";
		Object[] params = { 
			pageVO.getKeyword(), 
			pageVO.getBeginRownum(),
			pageVO.getEndRownum()
		};
		return jdbcTemplate.query(sql, boardMapper, params);
	}
	//공지사항 조회
	public List<BoardDto> selectNoticeList() {
		String sql = "select * from board "
					+ "where board_head = '공지' "
					+ "order by board_no desc";
		return jdbcTemplate.query(sql, boardMapper);
	}
	
	//상세
	public BoardDto selectOne(long boardNo) {
		String sql = "select * from board where board_no = ?";
		Object[] params = { boardNo };
		List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//[변형] 이전글 정보
	public BoardDto selectPreviousOne(long boardNo) {
		String sql = "select * from board where board_no = ("
						+ "select max(board_no) from board where board_no < ?"
					+ ")";
		Object[] params = { boardNo };
		List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	//[변형] 다음글 정보
	public BoardDto selectNextOne(long boardNo) {
		String sql = "select * from board where board_no = ("
						+ "select min(board_no) from board where board_no > ?"
					+ ")";
		Object[] params = { boardNo };
		List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public long sequence() {
		String sql = "select board_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, long.class);
	}
	public void insert(BoardDto boardDto) {
		String sql = "insert into board("
						+ "board_no, board_writer, board_head, "
						+ "board_title, board_content "
					+ ") "
					+ "values(?, ?, ?, ?, ?)";
		Object[] params = {
			boardDto.getBoardNo(), boardDto.getBoardWriter(),
			boardDto.getBoardHead(), boardDto.getBoardTitle(),
			boardDto.getBoardContent()
		};
		jdbcTemplate.update(sql, params);
	}
	
	//삭제
	public boolean delete(long boardNo) {
		String sql = "delete board where board_no = ?";
		Object[] params = { boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	//변경
	public boolean update(BoardDto boardDto) {
		String sql = "update board "
						+ "set board_title=?, "
							+ "board_head=?, "
							+ "board_content=?, "
							+ "board_etime=systimestamp "
						+ "where board_no=?";
		Object[] params = {
			boardDto.getBoardTitle(), boardDto.getBoardHead(),
			boardDto.getBoardContent(), boardDto.getBoardNo()
		};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//작성자로 검색하는 메소드
	public List<BoardDto> selectListByBoardWriter(String boardWriter) {
		String sql = "select * from board_list "
					+ "where board_writer=? "
					+ "order by board_no desc";
		Object[] params = {boardWriter};
		return jdbcTemplate.query(sql, boardMapper, params);
	}
	
	//조회수를 1 증가시키는 메소드
	public boolean updateBoardReadcount(long boardNo) {
		String sql = "update board "
					+ "set board_readcount=board_readcount+1 "
					+ "where board_no=?";
		Object[] params = { boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//목록과 검색의 상황별 카운트 메소드
	//→ 화면에서 마지막 페이지가 어딘지 알기 위해 필요한 데이터 
	public int count() {
		String sql = "select count(*) from board";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	public int count(PageVO pageVO) {
		if(pageVO.isList()) return count();
		if(!allowColumns.contains(pageVO.getColumn())) return count();
		
		String sql = "select count(*) from board "
					+ "where instr("+pageVO.getColumn()+", ?) > 0";
		Object[] params = { pageVO.getKeyword() };
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	public boolean updateBoardLikecount(long boardNo) {
		String sql = "update board set board_likecount = ("
						+ "select count(*) from board_like where board_no = ?"
					+ ") where board_no = ?";
		Object[] params = { boardNo, boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean updateBoardDislikecount(long boardNo) {
		String sql = "update board set board_dislikecount = ("
						+ "select count(*) from board_dislike where board_no = ?"
					+ ") where board_no = ?";
		Object[] params = { boardNo, boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean updateBoardReplycount(long boardNo) {
		String sql="update board set board_replycount = ("
				+ "select count(*) from reply where reply_origin = ?"
				+ ") where board_no = ?";
		Object[] params = { boardNo, boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
}

