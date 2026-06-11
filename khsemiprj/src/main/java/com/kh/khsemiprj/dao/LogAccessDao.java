package com.kh.khsemiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.ui.Model;

import com.kh.khsemiprj.dto.LogAccessDto;
import com.kh.khsemiprj.mapper.EmpMapper;
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
	            + "select rownum rn, TMP.* from ("
	            + "  select l.*, e.emp_name, d.dept_name "
	            + "  from log_access l "
	            + "  left outer join emp e on l.access_emp_id = e.emp_id "
	            + "  left outer join emp_dept_relation r on e.emp_id = r.emp_id "
	            + "  left outer join dept d on r.dept_no = d.dept_no "
	            + "  order by l.access_no desc"
	            + ") TMP"
	        + ") where rn between ? and ?";
	    Object[] params = { beginRownum, endRownum };
	    return jdbcTemplate.query(sql, logAccessMapper, params);
	}
	
	//검색목록조회 메소드
	public List<LogAccessDto> selectList(PageVO pageVO){
	    if(pageVO.isList())
	        return selectList(pageVO.getBeginRownum(), pageVO.getEndRownum());
	    
	    Set<String> allowList = Set.of("access_emp_id", "access_url");
	    if(allowList.contains(pageVO.getColumn()) == false)
	        return List.of();
	        
	    String sql = "select * from ("
	            + "select rownum rn, TMP.* from ("
	            + "  select l.*, e.emp_name, d.dept_name "
	            + "  from log_access l "
	            + "  left outer join emp e on l.access_emp_id = e.emp_id "
	            + "  left outer join emp_dept_relation r on e.emp_id = r.emp_id "
	            + "  left outer join dept d on r.dept_no = d.dept_no "
	            + "  where instr (l." + pageVO.getColumn() + ", ?) > 0 "
	            + "  order by l.access_no desc"
	            + ") TMP"
	        + ") where rn between ? and ?";
	    Object [] params = {
	            pageVO.getKeyword(),
	            pageVO.getBeginRownum(),
	            pageVO.getEndRownum()
	            };
	    return jdbcTemplate.query(sql, logAccessMapper , params);
	}
	
	//목록과 검색의 상황별 카운트 메소드
	public int count() {
		String sql = "select count(*) from log_access";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	public int count(PageVO pageVO) {
		if(pageVO.isList()) return count();
		
		String sql = "select count(*) from log_access where instr("+pageVO.getColumn()+", ?) > 0";
		Object[] params = { pageVO.getKeyword() };
		return jdbcTemplate.queryForObject(sql, int.class, params);	
	}
	
	// 특정 회원의 마지막 접속 기록 하나만 조회 (매퍼 규격에 맞게 조인 추가)
	public LogAccessDto getLastAccess(String empId) {
	    String sql = "select * from ("
	            + "  select l.*, e.emp_name, d.dept_name "
	            + "  from log_access l "
	            + "  left outer join emp e on l.access_emp_id = e.emp_id "
	            + "  left outer join emp_dept_relation r on e.emp_id = r.emp_id "
	            + "  left outer join dept d on r.dept_no = d.dept_no "
	            + "  where l.access_emp_id = ? "
	            + "  order by l.access_no desc"
	            + ") where rownum = 1";
	    Object[] params = { empId };
	    List<LogAccessDto> list = jdbcTemplate.query(sql, logAccessMapper, params);
	    return list.isEmpty() ? null : list.get(0);
	}
	
	
}
