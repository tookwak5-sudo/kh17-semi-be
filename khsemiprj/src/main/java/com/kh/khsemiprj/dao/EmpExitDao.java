package com.kh.khsemiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.EmpExitDto;
import com.kh.khsemiprj.mapper.EmpExitMapper;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import com.kh.khsemiprj.mapper.EmpExitVOMapper;
import com.kh.khsemiprj.vo.EmpExitVO;
import com.kh.khsemiprj.vo.PageVO;

@Repository
public class EmpExitDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EmpExitMapper empExitMapper;
	@Autowired
	private EmpExitVOMapper empExitVOMapper;

	// JSP에서 넘겨주는 column 히든태그 값이 "emp_name" 이므로 일치시킴
	private Set<String> allowColumns = Set.of("emp_name", "emp_exit_time");
	
	// 전체 목록 조회
	public List<EmpExitVO> selectList(int page, int size) {
		String sql = "select * from ("
				+ "select rownum rn, TMP.* from ("
				+ "select X.emp_id, E.emp_name, X.emp_exit_time "
				+ "from emp_exit X "
				+ "left join emp E on X.emp_id = E.emp_id "
				+ "order by X.emp_exit_time desc, X.emp_id asc"
				+ ") TMP"
				+ ") where rn between ? and ?";
		int beginRow = page * size - (size - 1);
		int endRow = page * size;
		Object[] params = { beginRow, endRow };
		return jdbcTemplate.query(sql, empExitVOMapper, params);
	}

	// 메인 동적 검색 및 페이징 목록 메서드
	public List<EmpExitVO> selectList(PageVO pageVO) {
		// 1. 검색어가 없는 기본 일반 목록 요청이면 위의 조인 페이징 메서드로 토스
		if (pageVO.isList()) {
			return selectList(pageVO.getPage(), pageVO.getSize());
		}
		// 2. 허용되지 않은 컬럼 접근 시 방어 처리
		if (!allowColumns.contains(pageVO.getColumn())) {
			return selectList(pageVO.getPage(), pageVO.getSize());
		}
		
		//선 조인
		String sql = "select * from ("
				   + "select rownum rn, TMP.* from ("
				   + "select X.emp_id, E.emp_name, X.emp_exit_time "
				   + "from emp_exit X "
				   + "left join emp E on X.emp_id = E.emp_id ";

		//페이지 처음과 끝 담을 리스트를 만들고
		List<Object> paramList = new ArrayList<>();

		// 3. 이름 검색 조건 동적 조립 
		if (pageVO.getColumn() != null && pageVO.getKeyword() != null && !pageVO.getKeyword().isEmpty()) {
			if (pageVO.getColumn().equals("emp_name")) {
				sql += " where instr(E.emp_name, ?) > 0 "; 
				paramList.add(pageVO.getKeyword());
			}
		}

		// 4. 정렬 및 서브쿼리 마감 페이징 연산
		sql += " order by X.emp_exit_time desc, X.emp_id asc"
			 + ") TMP"
			 + ") where rn between ? and ?";

		paramList.add(pageVO.getBeginRownum());
		paramList.add(pageVO.getEndRownum());

		//리스트를 배열화 해서 params로
		Object[] params = paramList.toArray();
		return jdbcTemplate.query(sql, empExitVOMapper, params);
	}
	
	// 전체 퇴사자 수 카운트 (emp_exit 테이블로 수정 완)
	public int count() {
		String sql = "select count(*) from emp_exit"; 
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	
	// 검색 시 퇴사자 수 동적 카운트 (조인 쿼리로 수정 완)
	public int count(PageVO pageVO) {
		if (pageVO.isList()) return count();
		if (!allowColumns.contains(pageVO.getColumn())) return count();
		
		String sql = "select count(*) from emp_exit X "
				   + "left join emp E on X.emp_id = E.emp_id ";
				   
		if (pageVO.getColumn().equals("emp_name")) {
			sql += "where instr(E.emp_name, ?) > 0";
		}
		
		Object[] params = { pageVO.getKeyword() };
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	public EmpExitDto selectOne(String empId) {
		String sql = "select * from emp_exit where emp_id = ? ";
		Object[] params = { empId };
		List<EmpExitDto> list = jdbcTemplate.query(sql, empExitMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
}
