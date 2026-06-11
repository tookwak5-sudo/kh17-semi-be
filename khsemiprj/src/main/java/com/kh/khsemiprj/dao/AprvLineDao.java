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
}
