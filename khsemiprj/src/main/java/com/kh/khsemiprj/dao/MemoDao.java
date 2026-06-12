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
	
    private Set<String> allowColumns = Set.of("memo_sender_id", "memo_title", "memo_content");

    public List<MemoDto> selectList(String receiverId, int page, int size) {
        String sql = "select * from ("
                        + "select rownum rn, TMP.* from ("
                            + "select * from memo "
                            + "where memo_receiver_id = ? "
                            + "order by memo_no desc"
                        + ") TMP"
                    + ") where rn between ? and ?";
        
        int beginRow = page * size - (size - 1);
        int endRow = page * size;
        Object[] params = { receiverId, beginRow, endRow };     
        
        return jdbcTemplate.query(sql, memoMapper, params);
    }

    //검색 및 목록 조회 (검색 O, 페이징 O)
    public List<MemoDto> selectList(String receiverId, PageVO pageVO) {
        if(pageVO.isList() || !allowColumns.contains(pageVO.getColumn())) {
            return selectList(receiverId, pageVO.getPage(), pageVO.getSize());
        }
        
        String sql = "select * from ("
                        + "select rownum rn, TMP.* from ("
                            + "select * from memo "
                            + "where memo_receiver_id = ? "
                            + "and instr(" + pageVO.getColumn() + ", ?) > 0 "
                            + "order by memo_no desc"
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
 					+ "where memo_receiver_id = ? " // 👈 내 쪽지 중에서만 검색하도록 조건 추가!
 					+ "and instr("+pageVO.getColumn()+", ?) > 0";
 		
 		Object[] params = { receiverId, pageVO.getKeyword() };
 		return jdbcTemplate.queryForObject(sql, int.class, params);
 	}
}
