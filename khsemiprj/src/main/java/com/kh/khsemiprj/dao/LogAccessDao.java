package com.kh.khsemiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.LogAccessDto;
import com.kh.khsemiprj.mapper.LogAccessMapper;
import com.kh.khsemiprj.vo.PageVO;

@Repository
public class LogAccessDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private LogAccessMapper logAccessMapper;
	
	//입력 메소드
	public void insert(LogAccessDto logAccessDto) {
		String sql = "insert into log_access "
				+ "(access_no, access_emp_id, access_url, access_ip) "
				+ "values(log_access_seq.nextval, ?, ?, ?)";
		Object[] params = {
				logAccessDto.getAccessEmpId(), logAccessDto.getAccessUrl(), 
				logAccessDto.getAccessIp()
		};
		jdbcTemplate.update(sql, params);
	}
	
	//조회 메소드
	public List<LogAccessDto> selectList(int beginRownum, int endRownum){
		String sql = "select * from ("
				+ "select rownum rn, TMP.* from("
				+ "select * from log_Access order by access_no desc"
			+ ") Tmp"
		+ "	)where rn between ? and ?";
		Object[] params = { beginRownum, endRownum };
		return jdbcTemplate.query(sql, logAccessMapper,  params);
	}
	
	public List<LogAccessDto> selectList(PageVO pageVO){
		if(pageVO.isList())
			return selectList(pageVO.getBeginRownum(), pageVO.getEndRownum());//검색항목이 없으면 목록 반환
		
		Set<String> allowList = Set.of("access_emp_id", "access_url");
		if(allowList.contains(pageVO.getColumn()) == false)
			return List.of();//허용되는 검색항목이 아니면 비어있는 결과
			
		String sql = "select * from ("
				+ "select rownum rn, TMP.* from("
				+ "select * from log_access "
				+ "where instr ("+pageVO.getColumn()+", ?)>0"
				+ "order by access_no desc"
				+ ") Tmp"
			+ "	)where rn between ? and ?";
		Object [] params = {
				pageVO.getKeyword(),
				pageVO.getBeginRownum(),
				pageVO.getEndRownum()
				};
		return jdbcTemplate.query(sql, logAccessMapper , params);
	}

}
