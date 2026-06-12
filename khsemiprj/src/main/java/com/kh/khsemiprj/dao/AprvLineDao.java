package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.AprvLineDto;
import com.kh.khsemiprj.mapper.AprvLineListMapper;
import com.kh.khsemiprj.mapper.AprvLineMapper;
import com.kh.khsemiprj.vo.AprvLineListVO;

@Repository
public class AprvLineDao {
	@Autowired
	JdbcTemplate jdbcTemplate;
	@Autowired
	AprvLineMapper aprvLineMapper;
	@Autowired
	AprvLineListMapper aprvLineListMapper;
	
	public int sequence() {
		String sql = "select aprv_line_seq.nextval from dual";
		int nextNo = jdbcTemplate.queryForObject(sql, int.class);
		return nextNo;
	}
	
	public boolean insertAprvLine(AprvLineDto aprvLineDto) {
		String sql = "insert into aprv_line(aprv_line_no, aprv_document_no, aprv_line_current_seq, aprv_line_status, emp_id) "
				+ "values(?, ?, ?, ?, ?)";
		Object[] params = { aprvLineDto.getAprvLineNo(), aprvLineDto.getAprvDocumentNo()
							, aprvLineDto.getAprvLineCurrentSeq(), aprvLineDto.getAprvLineStatus(), aprvLineDto.getEmpId() };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean deleteAprvLine(int aprvNo) {
		String sql = "delete from aprv_line where aprv_document_no = ?";
		Object[] params = { aprvNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public AprvLineListVO selectOne(int aprvLineNo) {
		String sql = "SELECT al.*, e.emp_name, ep.emp_position_name, d.dept_name "
				+ "FROM aprv_line al "
				+ "INNER JOIN emp e ON e.emp_id = al.emp_id "
				+ "LEFT JOIN emp_position ep ON ep.emp_position_no = e.emp_position_no "
				+ "INNER JOIN emp_dept_relation edr ON edr.emp_id = al.emp_id "
				+ "INNER JOIN dept d ON d.dept_no = edr.dept_no "
				+ "where aprv_line_no = ?";
		Object[] params = { aprvLineNo };
		List<AprvLineListVO> list = jdbcTemplate.query(sql, aprvLineListMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public List<AprvLineListVO> selectList1(int aprvNo) {
		String sql = "SELECT al.*, e.emp_name, ep.emp_position_name, d.dept_name "
				+ "FROM aprv_line al "
				+ "INNER JOIN emp e ON e.emp_id = al.emp_id "
				+ "LEFT JOIN emp_position ep ON ep.emp_position_no = e.emp_position_no "
				+ "INNER JOIN emp_dept_relation edr ON edr.emp_id = al.emp_id "
				+ "INNER JOIN dept d ON d.dept_no = edr.dept_no "
				+ "where al.aprv_line_current_seq = 1 and aprv_document_no = ?";
		Object[] params = { aprvNo };
		return jdbcTemplate.query(sql, aprvLineListMapper, params);
	}
	
	public List<AprvLineListVO> selectList2(int aprvNo) {
		String sql = "SELECT al.*, e.emp_name, ep.emp_position_name, d.dept_name "
				+ "FROM aprv_line al "
				+ "INNER JOIN emp e ON e.emp_id = al.emp_id "
				+ "LEFT JOIN emp_position ep ON ep.emp_position_no = e.emp_position_no "
				+ "INNER JOIN emp_dept_relation edr ON edr.emp_id = al.emp_id "
				+ "INNER JOIN dept d ON d.dept_no = edr.dept_no "
				+ "where al.aprv_line_current_seq = 2 and aprv_document_no = ?";
		Object[] params = { aprvNo };
		return jdbcTemplate.query(sql, aprvLineListMapper, params);
	}
	
	public boolean setAprvLineStatus(AprvLineDto aprvLineDto) {
		String sql = "update aprv_line set "
					+ "aprv_line_status = ? "
					+ ", aprv_line_comment = ? "
					+ ", aprv_line_date = systimestamp "
					+ "where aprv_line_no = ?";
		Object[] params = { aprvLineDto.getAprvLineStatus(), aprvLineDto.getAprvLineComment(), aprvLineDto.getAprvLineNo()};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public void setAprvStatus(int aprvNo, int aprvCurrentSeq) {
		String sql = "UPDATE aprv_document a "
				+ "   SET "
				// 1. 다음 단계(현재seq + 1)가 존재하면 seq를 1 증가, 없으면 그대로 유지
				+ "	    a.aprv_current_seq = CASE "
				+ "	        WHEN EXISTS ( "
				+ "	            SELECT 1 FROM aprv_line next_l "
				+ "	            WHERE next_l.aprv_document_no = a.aprv_no "
				+ "	              AND next_l.aprv_line_current_seq = a.aprv_current_seq + 1 "
				+ "	        ) THEN a.aprv_current_seq + 1 "
				+ "	        ELSE a.aprv_current_seq "
				+ "	    END, "
				//2. 다음 단계(현재seq + 1)가 없으면 상태를 '승인'으로 변경, 있으면 기존 상태 유지
				+ "	    a.aprv_status = CASE "
				+ "	        WHEN NOT EXISTS ( "
				+ "	            SELECT 1 FROM aprv_line next_l "
				+ "	            WHERE next_l.aprv_document_no = a.aprv_no "
				+ "	              AND next_l.aprv_line_current_seq = a.aprv_current_seq + 1 "
				+ "	        ) THEN '승인' "
				+ "	        ELSE a.aprv_status "
				+ "	    END, "
				+ "	    a.aprv_etime = CASE "
				+ "	        WHEN NOT EXISTS ( "
				+ "	            SELECT 1 FROM aprv_line next_l "
				+ "	            WHERE next_l.aprv_document_no = a.aprv_no "
				+ "	              AND next_l.aprv_line_current_seq = a.aprv_current_seq + 1 "
				+ "	        ) THEN systimestamp "
				+ "	        ELSE a.aprv_etime "
				+ "	    END "
				+ "WHERE a.aprv_no = ? "
				+ "  AND a.aprv_current_seq = ? "
				+ "  AND NOT EXISTS ( "
				+ "      SELECT 1 "
				+ "      FROM aprv_line al "
				+ "      WHERE al.aprv_document_no = a.aprv_no "
				+ "        AND al.aprv_line_current_seq = a.aprv_current_seq "
				+ "        AND al.aprv_line_status != '승인' "//'대기'나 '반려'가 하나라도 있으면 업데이트 안함
				+ "  )";
		Object[] params = { aprvNo, aprvCurrentSeq };
		jdbcTemplate.update(sql, params);
	}
}
