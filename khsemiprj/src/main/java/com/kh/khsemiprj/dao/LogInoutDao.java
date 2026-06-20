package com.kh.khsemiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.LogInoutDto;
import com.kh.khsemiprj.mapper.EmpLogInoutMapper;
import com.kh.khsemiprj.mapper.LogInoutMapper;
import com.kh.khsemiprj.vo.EmpLogInoutVO;
import com.kh.khsemiprj.vo.PageVO;

@Repository
public class LogInoutDao {
	@Autowired 
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private LogInoutMapper logInoutMapper;
	
	@Autowired
	private EmpLogInoutMapper empLogInoutMapper;
	
	//검색 허용할 컬럼
	Set<String> allowColumns = Set.of("log_inout_emp_id", "log_inout_type");
	
	//상세 조회 
	public LogInoutDto selectOne(String loginId) {
		String sql = "select * from log_inout where log_inout_emp_id = ?";
		Object[] params = { loginId };
		List<LogInoutDto> list =  jdbcTemplate.query(sql,logInoutMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	// 촐퇴근 목록 조회
	public List<EmpLogInoutVO> selectList(int page, int size) {
		String sql = "SELECT * FROM ("
	               		+ "SELECT ROWNUM RN, A.* FROM ("
		               		+ "SELECT l.log_inout_no, l.log_inout_emp_id, l.log_inout_time, l.log_inout_type, e.emp_name "
		               		+ "FROM log_inout l left join emp e on l.log_inout_emp_id = e.emp_id "
		               		+ "ORDER BY log_inout_no DESC"
	               		+ ") A"
	               + ") WHERE RN BETWEEN ? AND ?";
		int beginRow = page * size - (size - 1);
		int endRow = page * size;
		Object[] params = {beginRow, endRow};
		return jdbcTemplate.query(sql, empLogInoutMapper, params);
	}
	
	// 출퇴근 검색
	public List<EmpLogInoutVO> selectList(PageVO pageVO){
		if(pageVO.isList())
			return selectList(pageVO.getPage(), pageVO.getSize());
		if(!allowColumns.contains(pageVO.getColumn())) 
			return selectList(pageVO.getPage(), pageVO.getSize());
		
		String sql = "select * from ("
				+ "select rownum rn, TMP.* from ("
				+ "select * from log_inout "
				+ "where instr("+pageVO.getColumn()+", ?) > 0 "
				+ "order by log_inout_no desc"
			+ ") TMP"
			+ ") where rn between ? and ?";
		Object[] params = { 
				pageVO.getKeyword(), 
				pageVO.getBeginRownum(),
				pageVO.getEndRownum()
			};
			return jdbcTemplate.query(sql, empLogInoutMapper, params);
	}
	
	// 출퇴근 로그 등록
	public void insert(LogInoutDto logInoutDto) {
		String sql = "insert into log_inout(log_inout_no, log_inout_emp_id, log_inout_type) "
				+ "values(log_inout_seq.nextval, ?, ?)";
		Object[] params = {logInoutDto.getLogInoutEmpId(), logInoutDto.getLogInoutType()};
		jdbcTemplate.update(sql, params);
	}
	
	
	// 오늘의 최신 출퇴근 상태를 조회
	public LogInoutDto getLastType(String empId) {
		String sql = "select * from ("
				+ "select * from log_inout "
				+ "where log_inout_emp_id = ? "
				+ "and trunc(log_inout_time) = trunc(sysdate) "
				+ "order by log_inout_time desc"
				+ ") "
				+ "where rownum = 1";
		Object[] params = {empId};
		List<LogInoutDto> list =  jdbcTemplate.query(sql,logInoutMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
		
	// 마지막 페이지 확인을 위해 필요한 데이터
	public int count() {
		String sql = "select count(*) from log_inout";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	public int count(PageVO pageVO) {
		if(pageVO.isList()) return count();
		
		String sql = "select count(*) from log_inout where instr("+pageVO.getColumn()+", ?) > 0";
		Object[] params = {pageVO.getKeyword()};
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	
	// 특정 회원의 마지막 출퇴근 기록 하나만 조회 (조인 추가 버전)
	public LogInoutDto getLastLogin(String empId) {
	    String sql = "select * from ("
	            + "  select l.*, e.emp_name, d.dept_name "
	            + "  from log_inout l "
	            + "  left outer join emp e on l.log_inout_emp_id = e.emp_id "
	            + "  left outer join emp_dept_relation r on e.emp_id = r.emp_id "
	            + "  left outer join dept d on r.dept_no = d.dept_no "
	            + "  where l.log_inout_emp_id = ? "
	            + "  order by l.log_inout_no desc"
	            + ") where rownum = 1";
	    Object[] params = { empId };
	    List<LogInoutDto> list = jdbcTemplate.query(sql, logInoutMapper, params);
	    return list.isEmpty() ? null : list.get(0);
	}
}
