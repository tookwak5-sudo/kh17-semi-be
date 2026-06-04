package com.kh.khsemiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.AprvFormDto;
import com.kh.khsemiprj.mapper.AprvFormMapper;
import com.kh.khsemiprj.vo.AprvFormVO;
import com.kh.khsemiprj.vo.PageVO;
@Repository
public class AprvFormDao {
	@Autowired
	JdbcTemplate jdbcTemplate;
	@Autowired
	AprvFormMapper aprvFormMapper;
	

	private Set<String> allowColumns = Set.of("form_name", "form_head");

	//개별 파일 필요시	
	public AprvFormDto selectOne(int formNo) {
		String sql = "select * from aprv_form where form_no = ?";
		Object[] params = { formNo };
		List<AprvFormDto> list = jdbcTemplate.query(sql, aprvFormMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// 목록 및 키워드로 조회
	public List<AprvFormDto> selectList(int page, int size) {
		String sql = "select * from (" + "select rownum rn, TMP.* from (" + "select * from aprv_form "
				+ "order by form_no desc" + ") TMP" + ") where rn between ? and ?";
		int beginRow = page * size - (size - 1);
		int endRow = page * size;
		Object[] params = { beginRow, endRow };
		return jdbcTemplate.query(sql, aprvFormMapper, params);
	}

	public List<AprvFormDto> selectList(PageVO pageVO) {
		if (pageVO.isList())
			return selectList(pageVO.getPage(), pageVO.getSize());
		if (!allowColumns.contains(pageVO.getColumn()))
			return selectList(pageVO.getPage(), pageVO.getSize());

		String sql = "select * from (" + "select rownum rn, TMP.* from (" + "select * from aprv_form " + "where instr("
				+ pageVO.getColumn() + ", ?) > 0 " + "order by form_no asc" + ") TMP" + ") where rn between ? and ?";
		Object[] params = { pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum() };
		return jdbcTemplate.query(sql, aprvFormMapper, params);
	}
	
	public int sequence() {
		String sql = "select form_no_seq.nextval from dual";
		int nextNo= jdbcTemplate.queryForObject(sql, int.class);
		return nextNo;
	}
	
	public AprvFormVO insertForm(AprvFormDto aprvFormDto) {
	    
		int currentNo = this.sequence();
		
	    String sql = "insert into aprv_form( "
	            + "form_no, form_name, form_explain, form_use_yn, "
	            + "form_wtime, form_head) "
	            + "values(?, ?, ?, ?, systimestamp, ?)";
	            
	    
	    Object[] params = {
	        currentNo,//컨트롤러에서 다음번호를 받아주는게 아닌 인서트 구문에서 받아주도록 만들었습니다.
	        aprvFormDto.getFormName(),    
	        aprvFormDto.getFormExplain(), 
	        aprvFormDto.getFormUseYn(),  
	        aprvFormDto.getFormHead()     
	    };
	    
	   
	    jdbcTemplate.update(sql, params);
	    
	   
	    AprvFormVO aprvFormVo = new AprvFormVO();
	    aprvFormVo.setFormNo(aprvFormDto.getFormNo());
	    
	    
	    return aprvFormVo; 
	}
	
	
	public void connect(int formNo, int attachNo) {
		String sql = "insert into form_file(form_no,attach_no) values(?, ?)";
		Object[] params = {formNo,attachNo};
		jdbcTemplate.update(sql,params);
	}
}
