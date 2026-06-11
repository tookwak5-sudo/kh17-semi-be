package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.AprvDto;
import com.kh.khsemiprj.mapper.AprvMapper;
import com.kh.khsemiprj.mapper.EmpAprvLineMapper;
import com.kh.khsemiprj.vo.EmpAprvLineVO;

@Repository
public class AprvDao {
	@Autowired
	JdbcTemplate jdbcTemplate;
	@Autowired
	AprvMapper aprvMapper;
	@Autowired
	EmpAprvLineMapper empAprvLineMapper;
	
	public int sequence() {
		String sql = "select aprv_no_seq.nextval from dual";
		int nextNo = jdbcTemplate.queryForObject(sql, int.class);
		return nextNo;
	}
	
	public boolean insertAprv(AprvDto aprvDto) {
		String sql = "insert into aprv_document(aprv_no, aprv_writer, aprv_form_no, aprv_title, aprv_content, aprv_status, aprv_current_seq, aprv_sdate, aprv_edate) "
				+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = { aprvDto.getAprvNo(), aprvDto.getAprvWriter(), aprvDto.getAprvFormNo()
							, aprvDto.getAprvTitle(), aprvDto.getAprvContent(), aprvDto.getAprvStatus()
							, aprvDto.getAprvCurrentSeq(), aprvDto.getAprvSdate(), aprvDto.getAprvEdate() };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public void connect(int aprvNo, int attachNo) {
		String sql = "insert into document_file(aprv_no, attach_no) values(?, ?)";
		Object[] params = { aprvNo, attachNo };
		jdbcTemplate.update(sql, params);
	}
	
	// 사원 내가 쓴 결재 목록 (AprvDao)
	public List<EmpAprvLineVO> selectMyList(String aprvWriter){
	    String sql = "select d.aprv_no, d.aprv_title, d.aprv_status, d.aprv_writer, "
	               + "       e.emp_id, e.emp_name " 
	               + "from aprv_document d "
	               + "join emp e on d.aprv_writer = e.emp_id "
	               + "where d.aprv_writer = ? "
	               + "order by d.aprv_no desc";
	               
	    Object[] params = { aprvWriter };
	    return jdbcTemplate.query(sql, empAprvLineMapper, params);
	}

	//내가 승인해야 할 결재 목록 (AprvLineDao 또는 AprvDao)
	public List<EmpAprvLineVO> selectReceivedList(String empId){
	    // 중요: emp e 조인 조건을 'd.aprv_writer = e.emp_id'로 해야 "기안한 사람의 이름"이 나옵니다!
	    String sql = "select d.aprv_no, d.aprv_title, d.aprv_status, d.aprv_writer, "
	               + "e.emp_name, e.emp_id " // 글쓴이(기안자)의 이름이 됨
	               + "from aprv_line l "
	               + "join aprv_document d on l.aprv_document_no = d.aprv_no "
	               + "join emp e on d.aprv_writer = e.emp_id " //l.emp_id가 아니라 d.aprv_writer와 조인!
	               + "where l.emp_id = ? and l.aprv_line_status = '대기' "
	               + "order by l.aprv_document_no asc";
	               
	    Object[] params = { empId };
	    return jdbcTemplate.query(sql, empAprvLineMapper, params);
	}
	
}
