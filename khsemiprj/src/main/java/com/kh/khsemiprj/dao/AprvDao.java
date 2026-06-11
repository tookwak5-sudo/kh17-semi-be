package com.kh.khsemiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.AprvDto;
import com.kh.khsemiprj.mapper.AprvMapper;
import com.kh.khsemiprj.vo.PageVO;

@Repository
public class AprvDao {
	@Autowired
	JdbcTemplate jdbcTemplate;
	@Autowired
	AprvMapper aprvMapper;
	
	//검색 허용할 컬럼
	private Set<String> allowColumns = Set.of("aprv_writer", "aprv_title", "aprv_status");
	
	public int sequence() {
		String sql = "select aprv_no_seq.nextval from dual";
		int nextNo = jdbcTemplate.queryForObject(sql, int.class);
		return nextNo;
	}
	
	public boolean insertAprvTemp(AprvDto aprvDto) {
		String sql = "insert into aprv_document("
						+ "aprv_no, aprv_writer, aprv_form_no, aprv_title, aprv_content"
						+ ", aprv_status, aprv_current_seq, aprv_sdate, aprv_edate, aprv_temp_wtime) "
					+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?, systimestamp)";
		Object[] params = { aprvDto.getAprvNo(), aprvDto.getAprvWriter(), aprvDto.getAprvFormNo()
							, aprvDto.getAprvTitle(), aprvDto.getAprvContent(), aprvDto.getAprvStatus()
							, aprvDto.getAprvCurrentSeq(), aprvDto.getAprvSdate(), aprvDto.getAprvEdate() };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean insertAprv(AprvDto aprvDto) {
		String sql = "insert into aprv_document("
						+ "aprv_no, aprv_writer, aprv_form_no, aprv_title, aprv_content"
						+ ", aprv_status, aprv_current_seq, aprv_sdate, aprv_edate, aprv_wtime) "
					+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?, systimestamp)";
		Object[] params = { aprvDto.getAprvNo(), aprvDto.getAprvWriter(), aprvDto.getAprvFormNo()
							, aprvDto.getAprvTitle(), aprvDto.getAprvContent(), aprvDto.getAprvStatus()
							, aprvDto.getAprvCurrentSeq(), aprvDto.getAprvSdate(), aprvDto.getAprvEdate() };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean updateAprvTemp(AprvDto aprvDto) {
		String sql = "update aprv_document set "
					+ "aprv_title = ? "
					+ ", aprv_content = ? "
					+ ", aprv_status = ? "
					+ ", aprv_current_seq = ? "
					+ ", aprv_sdate = ? "
					+ ", aprv_edate = ? "
					+ ", aprv_temp_utime = systimestamp "
					+ "where aprv_no = ?";
		Object[] params = { aprvDto.getAprvTitle(), aprvDto.getAprvContent(), aprvDto.getAprvStatus()
							, aprvDto.getAprvCurrentSeq(), aprvDto.getAprvSdate(), aprvDto.getAprvEdate()
							, aprvDto.getAprvNo()};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean updateAprv(AprvDto aprvDto) {
		String sql = "update aprv_document set "
					+ "aprv_title = ? "
					+ ", aprv_content = ? "
					+ ", aprv_status = ? "
					+ ", aprv_current_seq = ? "
					+ ", aprv_sdate = ? "
					+ ", aprv_edate = ? "
					+ ", aprv_wtime = systimestamp "
					+ "where aprv_no = ?";
		Object[] params = { aprvDto.getAprvTitle(), aprvDto.getAprvContent(), aprvDto.getAprvStatus()
							, aprvDto.getAprvCurrentSeq(), aprvDto.getAprvSdate(), aprvDto.getAprvEdate()
							, aprvDto.getAprvNo()};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean save(int aprvNo) {
		String sql = "update aprv_document set "
				+ "aprv_status = '대기' "
				+ ", aprv_wtime = systimestamp "
				+ "where aprv_no = ? "
				+ "and aprv_status = '임시저장'";
		Object[] params = { aprvNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean delete(int aprvNo) {
		String sql = "delete aprv_document where aprv_no = ? and aprv_status = '임시저장'";
		Object[] params = { aprvNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public AprvDto selectOne(int aprvNo) {
		String sql = "select * from aprv_document where aprv_no = ? ";
		Object[] params = { aprvNo };
		List<AprvDto> list = jdbcTemplate.query(sql, aprvMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public List<AprvDto> selectList(int page, int size, String empId) {
		String sql = "select * from ("
				+ "select rownum rn, TMP.* from ("
					+ "select * from aprv_document "
					//임시저장은 작성자만 볼 수 있도록
					+ "where ((aprv_status = '임시저장' and aprv_writer = ?) or aprv_status in ('대기','승인','반려')) "
					+ "order by aprv_no asc"
				+ ") TMP"
			+ ") where rn between ? and ?";
		int beginRow = page * size - (size-1);
		int endRow = page * size;
		Object[] params = { empId, beginRow , endRow };
		return jdbcTemplate.query(sql, aprvMapper, params);
	}
	
	public List<AprvDto> selectList(PageVO pageVO, String empId) {
		if(pageVO.isList())
			return selectList(pageVO.getPage(), pageVO.getSize(), empId);
		if(!allowColumns.contains(pageVO.getColumn()))
			return selectList(pageVO.getPage(), pageVO.getSize(), empId);
		
		String sql = "select * from ("
						+ "select rownum rn, TMP.* from ("
							+ "select * from aprv_document "
							+ "where instr("+pageVO.getColumn()+", ?) > 0 "
							//임시저장은 작성자만 볼 수 있도록
							+ "and ((aprv_status = '임시저장' and aprv_writer = ?) or aprv_status in ('대기','승인','반려')) "
							+ "order by aprv_no asc"
						+ ") TMP"
					+ ") where rn between ? and ?";
		Object[] params = { 
			pageVO.getKeyword(), 
			pageVO.getBeginRownum(),
			pageVO.getEndRownum()
		};
		return jdbcTemplate.query(sql, aprvMapper, params);
	}
	
	//목록과 검색의 상황별 카운트 메소드
	//→ 화면에서 마지막 페이지가 어딘지 알기 위해 필요한 데이터 
	public int count() {
		String sql = "select count(*) from aprv_document";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	
	public int count(PageVO pageVO) {
		if(pageVO.isList()) return count();
		if(!allowColumns.contains(pageVO.getColumn())) return count();
		
		String sql = "select count(*) from aprv_document "
					+ "where instr("+pageVO.getColumn()+", ?) > 0";
		Object[] params = { pageVO.getKeyword() };
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	public void connect(int aprvNo, int attachNo) {
		String sql = "insert into document_file(aprv_no, attach_no) values(?, ?)";
		Object[] params = { aprvNo, attachNo };
		jdbcTemplate.update(sql, params);
	}
	
	public Integer searchAttach(int aprvNo) {
		String sql = "select attach_no from document_file where aprv_no=?";
		Object[] params = { aprvNo };
		try {
			return jdbcTemplate.queryForObject(sql, Integer.class, params);
		} catch (Exception e) {
			return null;
		}
	}
	
	public void deleteAttach(int attachNo) {
		String sql = "delete document_file where attach_no = ?";
		Object[] params = { attachNo };
		jdbcTemplate.update(sql, params);
	}
}
