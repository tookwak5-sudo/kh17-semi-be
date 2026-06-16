package com.kh.khsemiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.MemoDto;
import com.kh.khsemiprj.mapper.MemoMapper;
import com.kh.khsemiprj.vo.PageVO;

@Repository
public class MemoDao {
	@Autowired
	JdbcTemplate jdbcTemplate;
	@Autowired
	MemoMapper memoMapper;
	
	public int sequence() {
	    String sql = "select memo_seq.nextval from dual";
	    return jdbcTemplate.queryForObject(sql, int.class);//정해진 형태 (null 불가)
	}
	
	//쪽지 생성
	public void insert(MemoDto memoDto) {
		String sql = "insert into memo "
				+ "(memo_no, memo_receiver_id, memo_sender_id, memo_title, "
				+ "memo_content, memo_read_status, memo_type) "
				+ "values(?, ?, ?, ?, ?, ?, ?)";
		Object[] params = {
				memoDto.getMemoNo(), memoDto.getMemoReceiverId(), memoDto.getMemoSenderId(), 
				memoDto.getMemoTitle(), memoDto.getMemoContent(), memoDto.getMemoReadStatus(), 
				memoDto.getMemoType()
		};
		jdbcTemplate.update(sql, params);
	}
	
	//쪽지 상세 메소드
	public MemoDto selectOne(int memoNo) {
	    // 💡 memo 테이블(M)과 emp 테이블(E)을 조인하여 emp_name까지 함께 조회합니다.
	    String sql = "select M.*, E.emp_name "
	               + "from memo M "
	               + "left outer join emp E on M.memo_sender_id = E.emp_id "
	               + "where M.memo_no = ?";
	               
	    Object[] params = { memoNo };
	    List<MemoDto> list = jdbcTemplate.query(sql, memoMapper, params);
	    
	    return list.isEmpty() ? null : list.get(0);
	}
	
    private Set<String> allowColumns = Set.of("memo_sender_id", "memo_title", "memo_content");

 // 목록 조회 (검색 X, 페이징 O)
    public List<MemoDto> selectList(String receiverId, int page, int size) {
        // 💡 JOIN을 추가하고, 서브쿼리(TMP) 외부에서 안전하게 순번(rownum)을 매기도록 수정
        String sql = "select * from ("
                        + "select rownum rn, TMP.* from ("
                            + "select M.*, E.emp_name " // memo의 모든 컬럼과 emp의 이름을 가져옴
                            + "from memo M "
                            + "left outer join emp E on M.memo_sender_id = E.emp_id " // 발신자 ID 기준 조인
                            + "where M.memo_receiver_id = ? "
                            + "order by M.memo_no desc"
                        + ") TMP"
                    + ") where rn between ? and ?";
        
        int beginRow = page * size - (size - 1);
        int endRow = page * size;
        Object[] params = { receiverId, beginRow, endRow };     
        
        return jdbcTemplate.query(sql, memoMapper, params);
    }

    // 검색 및 목록 조회 (검색 O, 페이징 O)
    public List<MemoDto> selectList(String receiverId, PageVO pageVO) {
        if(pageVO.isList() || !allowColumns.contains(pageVO.getColumn())) {
            return selectList(receiverId, pageVO.getPage(), pageVO.getSize());
        }
        
        // 💡 컬럼 모호성 해결을 위해 조건절에 테이블 별칭(M.) 추가 권장
        // 예: pageVO.getColumn()이 memo_title 이라면 M.memo_title이 되도록 처리 필요
        String column = pageVO.getColumn();
        if(!column.contains(".")) {
            column = "M." + column; 
        }
        
        String sql = "select * from ("
                        + "select rownum rn, TMP.* from ("
                            + "select M.*, E.emp_name "
                            + "from memo M "
                            + "left outer join emp E on M.memo_sender_id = E.emp_id "
                            + "where M.memo_receiver_id = ? "
                            + "and instr(" + column + ", ?) > 0 "
                            + "order by M.memo_no desc"
                        + ") TMP"
                    + ") where rn between ? and ?";
        
        Object[] params = { 
            receiverId,
            pageVO.getKeyword(), 
            pageVO.getBeginRownum(),
            pageVO.getEndRownum()
        };
        
        return jdbcTemplate.query(sql, memoMapper, params);
    }
    
 	public int count(String receiverId) {
 		String sql = "select count(*) from memo where memo_receiver_id = ?";
 		return jdbcTemplate.queryForObject(sql, int.class, receiverId);
 	}
 	
 	public int count(String receiverId, PageVO pageVO) {
 		if(pageVO.isList()) return count(receiverId);
 		if(!allowColumns.contains(pageVO.getColumn())) return count(receiverId);
 		
 		String sql = "select count(*) from memo "
 					+ "where memo_receiver_id = ? "
 					+ "and instr("+pageVO.getColumn()+", ?) > 0";
 		
 		Object[] params = { receiverId, pageVO.getKeyword() };
 		return jdbcTemplate.queryForObject(sql, int.class, params);
 	}
 	
 	//디테일로 들어왔을때 상태값이 N이면 Y로 바꿔주기
 	public boolean update(int memoNo) {
 		String sql = "update memo "
 				+ "set memo_read_status = 'Y' where memo_no = ? and	memo_read_status = 'N'";
 		Object[] params = { memoNo };
 		return jdbcTemplate.update(sql, params)>0;
 	}
 	
}
