package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.AttachDto;
import com.kh.khsemiprj.mapper.AttachMapper;



@Repository
public class AttachDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private AttachMapper attachMapper;

	//등록
	public int sequence() {
		String sql = "select attach_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	public void insert(AttachDto attachDto) {
		String sql = "insert into attach("
						+ "attach_no, attach_name, "
						+ "attach_type, attach_size"
					+ ") values(?, ?, ?, ?)";
		Object[] params = {
			attachDto.getAttachNo(), attachDto.getAttachName(),
			attachDto.getAttachType(), attachDto.getAttachSize()
		};
		jdbcTemplate.update(sql, params);
	}
	
	//상세
	public AttachDto selectOne(int attachNo) {
		String sql = "select * from attach where attach_no = ?";
		Object[] params = { attachNo };
		List<AttachDto> list = jdbcTemplate.query(sql, attachMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//삭제
	public boolean delete(int attachNo) {
		String sql = "delete attach where attach_no = ?";
		Object[] params = { attachNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
}
