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
	public List<AprvHeadDto> selectList(){
		String sql = "select * from aprv_head order by head_no asc";
		return jdbcTemplate.query(sql, aprvHeadMapper);
	}
	
	//일반 목록 조회
	public List<AprvHeadDto> selectListNormal(){
		String sql = "select * from aprv_head where head_type= '일반' order by head_no asc";
		return jdbcTemplate.query(sql, aprvHeadMapper);
	}
	
	//입력된 헤더이름으로 같은 헤더 이름이 있는 지 조회
	public AprvHeadDto selectOneByName(String headName) {
		String sql = "select * from aprv_head where head_name = ? ";
		Object[] params = {headName};
		List<AprvHeadDto> list = jdbcTemplate.query(sql, aprvHeadMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
}
