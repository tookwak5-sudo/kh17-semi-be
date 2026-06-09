package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.AprvHeadDto;
import com.kh.khsemiprj.mapper.AprvHeadMapper;

@Repository
public class AprvHeadDao {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private AprvHeadMapper aprvHeadMapper;
	
	public int sequence() {
		String sql = "select aprv_head_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	
	//헤더 입력
	public void insert(AprvHeadDto aprvHeadDto) {
			String sql = "insert into aprv_head " 
			+ "(head_no, head_name, head_type) "
			+ "values(?, ?, ?)";
			Object[] params = { 
					aprvHeadDto.getHeadNo(),aprvHeadDto.getHeadName(), aprvHeadDto.getHeadType()
					};
			jdbcTemplate.update(sql, params);
		}
		
	//헤더 삭제
	public boolean delete(int headNo) {
		String sql = "delete aprv_head where head_no=?";
		Object[] params = {headNo};
		return jdbcTemplate.update(sql, params)>0;
	}
	
	//헤더 목록 조회
	public List<AprvHeadDto> selectList(int beginRownum, int endRownum){
		String sql = "select * from ("
				+ "select rownum rn, TMP.* from("
				+ "select * from aprv_head order by head_no asc"
			+ ") Tmp"
		+ "	)where rn between ? and ?";
		Object[] params = { beginRownum , endRownum };
		return jdbcTemplate.query(sql, aprvHeadMapper, params);
	}
	
	public int count() {
		String sql = "select count(*) from aprv_head";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	
}
