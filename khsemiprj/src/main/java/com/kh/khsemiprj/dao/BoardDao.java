package com.kh.khsemiprj.dao;

import java.util.ArrayList;
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
							+ "select * from board_list "
							+ "order by board_no desc"
						+ ") TMP"
					+ ") where rn between ? and ?";
		int beginRow = page * size - (size-1);

		int endRow = page * size;
		Object[] params = { beginRow, endRow };
		return jdbcTemplate.query(sql, boardMapper, params);
	}

	public List<BoardDto> selectList(PageVO pageVO) {
	
		StringBuilder tempoSql=new StringBuilder();
		tempoSql.append("select * from board_list ");
		boolean hasKeyword = !pageVO.isList() && allowColumns.contains(pageVO.getColumn());
	    boolean hasHead = pageVO.getBoardHead() != null && !pageVO.getBoardHead().isEmpty();
	    List<Object> paramList = new ArrayList<>();
	    
	    if (hasKeyword || hasHead) {
	        tempoSql.append("where ");
	        
	        if (hasHead) {
	            tempoSql.append("board_head = ? ");
	            paramList.add(pageVO.getBoardHead());
	        }
	        
	        if (hasKeyword) {
	            if (hasHead) tempoSql.append("and "); // 둘 다 있으면 and로 연결
	            tempoSql.append("instr(").append(pageVO.getColumn()).append(", ?) > 0 ");
	            paramList.add(pageVO.getKeyword());
	        }
	    }
	    
//		if (pageVO.isList())
//			return selectList(pageVO.getPage(), pageVO.getSize());
//
//		if (!allowColumns.contains(pageVO.getColumn()))
//			return selectList(pageVO.getPage(), pageVO.getSize());
		
		String sql = "select * from ("
						+ "select rownum rn, TMP.* from ("
							+ tempoSql.toString()
							+ "order by board_no desc"
						+ ") TMP"
					+ ") where rn between ? and ?";
			paramList.add(pageVO.getBeginRownum());
			paramList.add(pageVO.getEndRownum());
		return jdbcTemplate.query(sql, boardMapper, paramList.toArray());
	}

	// 공지사항 조회
	public List<BoardDto> selectNoticeList() {
	    String sql = "select * from ("
	                    + "select * from board_list "
	                    + "where board_head = '공지' "
	                    + "order by board_no desc" // 최신순 정렬
	                + ") where rownum <= 5"; // 상위 5개만
	    return jdbcTemplate.query(sql, boardMapper);
	}
//	//첫 주석과 같은 이유로 넣었습니다.
//	public List<BoardDto> selectNullList() {//이제 null없음
//		String sql = "select * from board_list "
//					+ "where board_head is null "
//					+ "order by board_no desc";
//		return jdbcTemplate.query(sql, boardMapper);
//	}
	

	// 상세
	public BoardDto selectOne(long boardNo) {
		String sql = "select * from board where board_no = ?";
		Object[] params = { boardNo };
		List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// [변형] 이전글 정보
	public BoardDto selectPreviousOne(long boardNo) {

		String sql = "select * from board_list where board_no = ("
						+ "select max(board_no) from board_list where board_no < ?"
					+ ")";
		Object[] params = { boardNo };
		List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	// [변형] 이전글 정보
	public BoardDto selectPreviousOne(long boardNo, PageVO pageVO) {
	    StringBuilder sql = new StringBuilder();
	    sql.append("select * from board_list where board_no = (");
	    sql.append("select max(board_no) from board_list where board_no < ? ");
	    
	    List<Object> paramList = new ArrayList<>();
	    paramList.add(boardNo);
	    
	    //조건 검사
	    boolean hasKeyword = !pageVO.isList() && allowColumns.contains(pageVO.getColumn());
	    boolean hasHead = pageVO.getBoardHead() != null && !pageVO.getBoardHead().isEmpty();
	    
	    //말머리 조건이 있으면 추가
	    if (hasHead) {
	        sql.append("and board_head = ? ");
	        paramList.add(pageVO.getBoardHead());
	    }
	    
	    //검색어 조건이 있으면 추가
	    if (hasKeyword) {
	        sql.append("and instr(").append(pageVO.getColumn()).append(", ?) > 0 ");
	        paramList.add(pageVO.getKeyword());
	    }
	    
	    sql.append(")");
	    
	    List<BoardDto> list = jdbcTemplate.query(sql.toString(), boardMapper, paramList.toArray());
	    return list.isEmpty() ? null : list.get(0);
	}
	// [변형] 다음글 정보
	public BoardDto selectNextOne(long boardNo) {
		String sql = "select * from board_list where board_no = ("
						+ "select min(board_no) from board_list where board_no > ?"
					+ ")";
		Object[] params = { boardNo };
		List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	// [변형] 다음글 정보 
	public BoardDto selectNextOne(long boardNo, PageVO pageVO) {
	    StringBuilder sql = new StringBuilder();
	    sql.append("select * from board_list where board_no = (");
	    sql.append("select min(board_no) from board_list where board_no > ? ");
	    
	    List<Object> paramList = new ArrayList<>();
	    paramList.add(boardNo);
	    
	    //조건 검사
	    boolean hasKeyword = !pageVO.isList() && allowColumns.contains(pageVO.getColumn());
	    boolean hasHead = pageVO.getBoardHead() != null && !pageVO.getBoardHead().isEmpty();
	    
	    //말머리 조건이 있으면 추가
	    if (hasHead) {
	        sql.append("and board_head = ? ");
	        paramList.add(pageVO.getBoardHead());
	    }
	    
	    //검색어 조건이 있으면 추가
	    if (hasKeyword) {
	        sql.append("and instr(").append(pageVO.getColumn()).append(", ?) > 0 ");
	        paramList.add(pageVO.getKeyword());
	    }
	    
	    sql.append(")");
	    
	    List<BoardDto> list = jdbcTemplate.query(sql.toString(), boardMapper, paramList.toArray());
	    return list.isEmpty() ? null : list.get(0);
	}
	public long sequence() {
		String sql = "select board_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, long.class);
	}

	public void insert(BoardDto boardDto) {

		String sql = "insert into board(" + "board_no, board_writer, board_head, " + "board_title, board_content "
				+ ") " + "values(?, ?, ?, ?, ?)";
		Object[] params = { boardDto.getBoardNo(), boardDto.getBoardWriter(), boardDto.getBoardHead(),
				boardDto.getBoardTitle(), boardDto.getBoardContent() };
		jdbcTemplate.update(sql, params);
	}

	// 삭제
	public boolean delete(long boardNo) {
		String sql = "delete board where board_no = ?";
		Object[] params = { boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}

	// 변경
	public boolean update(BoardDto boardDto) {
		String sql = "update board " + "set board_title=?, " + "board_head=?, " + "board_content=?, "
				+ "board_etime=systimestamp " + "where board_no=?";
		Object[] params = { boardDto.getBoardTitle(), boardDto.getBoardHead(), boardDto.getBoardContent(),
				boardDto.getBoardNo() };
		return jdbcTemplate.update(sql, params) > 0;
	}

	// 작성자로 검색하는 메소드
	public List<BoardDto> selectListByBoardWriter(String boardWriter) {
		String sql = "select * from board_list " + "where board_writer=? " + "order by board_no desc";
		Object[] params = { boardWriter };
		return jdbcTemplate.query(sql, boardMapper, params);
	}

	public List<BoardDto> selectListByBoardHead(String boardHead) {
		String sql = "select * from board_list" + "where board_head=? " + "order by board_no desc";
		Object[] params = { boardHead };
		return jdbcTemplate.query(sql, boardMapper, params);
	}

	// 조회수를 1 증가시키는 메소드
	public boolean updateBoardReadcount(long boardNo) {
		String sql = "update board " + "set board_readcount=board_readcount+1 " + "where board_no=?";
		Object[] params = { boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}

	// 목록과 검색의 상황별 카운트 메소드
	// → 화면에서 마지막 페이지가 어딘지 알기 위해 필요한 데이터
	public int count() {
		String sql = "select count(*) from board";
		return jdbcTemplate.queryForObject(sql, int.class);
	}

	public int count(PageVO pageVO) {
		//말머리와 검색어가 각각 존재하는지 확인
		boolean hasBoardHead = pageVO.getBoardHead() != null && !pageVO.getBoardHead().equals("");
		boolean hasSearch = pageVO.getKeyword() != null && !pageVO.getKeyword().equals("");
		
		//검색어가 있는데 허용되지 않은 컬럼이면 검색 취소 처리
		if (hasSearch && !allowColumns.contains(pageVO.getColumn())) {
			hasSearch = false;
		}

		// 말머리도 있고, 검색어도 있을 때
		if (hasBoardHead && hasSearch) {
			String sql = "select count(*) from board where board_head = ? and instr(" + pageVO.getColumn() + ", ?) > 0";
			Object[] params = { pageVO.getBoardHead(), pageVO.getKeyword() };
			return jdbcTemplate.queryForObject(sql, int.class, params);
		} 
		//말머리만 있을 때
		else if (hasBoardHead) {
			String sql = "select count(*) from board where board_head = ?";
			Object[] params = { pageVO.getBoardHead() };
			return jdbcTemplate.queryForObject(sql, int.class, params);
		} 
		//검색어만 있을 때
		else if (hasSearch) {
			String sql = "select count(*) from board where instr(" + pageVO.getColumn() + ", ?) > 0";
			Object[] params = { pageVO.getKeyword() };
			return jdbcTemplate.queryForObject(sql, int.class, params);
		} 
		//둘 다 없을 때
		else {
			return count();
		}
	}

	public boolean updateBoardLikecount(long boardNo) {
		String sql = "update board set board_likecount = (" + "select count(*) from board_like where board_no = ?"
				+ ") where board_no = ?";
		Object[] params = { boardNo, boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}

	public boolean updateBoardDislikecount(long boardNo) {
		String sql = "update board set board_dislikecount = (" + "select count(*) from board_dislike where board_no = ?"
				+ ") where board_no = ?";
		Object[] params = { boardNo, boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}

	public boolean updateBoardReplycount(long boardNo) {
		String sql="update board set board_replycount = ("
				+ "select count(*) from reply where reply_origin = ? "
				+ "and reply_status='N') where board_no = ?";
		Object[] params = { boardNo, boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//AprvFormDao 파쿠리
	public void connect(long boardNo, int attachNo) {
		String sql = "insert into board_file(board_no,attach_no) values(?, ?)";
		Object[] params = { boardNo, attachNo };
		jdbcTemplate.update(sql, params);
	}
	
	// 파일 연결 관계 끊어 버리는 메소드
	//AprvFormDao 파쿠리
		public boolean disconnect(long boardNo, int attachNo) {
			String sql = "delete from board_file where board_no = ? and attach_no = ?";
			Object[] params = { boardNo, attachNo };
			return jdbcTemplate.update(sql, params) > 0;
		}

		//AprvFormDao 파쿠리
		public Integer findAttachNo(long boardNo) {
			String sql = "select attach_no from board_file where board_no=?";
			Object[] params = { boardNo };
			try {
				return jdbcTemplate.queryForObject(sql, Integer.class, params);
			} catch (Exception e) {
				e.getMessage();
				return null;
			}
		}
}
