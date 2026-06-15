package com.kh.khsemiprj.dao;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.EmpExitDto;
import com.kh.khsemiprj.mapper.EmpExitMapper;
import com.kh.khsemiprj.mapper.EmpExitVOMapper;
import com.kh.khsemiprj.vo.PageVO;

@Repository
public class EmpExitDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EmpExitMapper empExitMapper;
	@Autowired
	private EmpExitVOMapper empExitVOMapper;

	// 전체 목록만(페이징)
	public List<EmpExitDto> selectList(int page, int size) {
		String sql = "select * from ("
				+ "select rownum rn, TMP.* from ("
				+ "select * from emp_exit "
				+ "order by emp_exit_time desc"
				+ ") TMP"
				+ ") where rn between ? and ?";
		int beginRow = page * size - (size-1);

		int endRow = page * size;
		Object[] params = { beginRow, endRow };
		return jdbcTemplate.query(sql, empExitMapper,params);
	}
	
	// 퇴사 처리 시각, 퇴사자의 이름 필요(요건 조인으로 해결 될 것 같습니다.)

	// 현재 병원 예약때문에 저희 식으로 맞게 고치는 건 내일 와서 하겠습니다. 죄송합니다.
	public List<EmpExitDto> selectList(PageVO pageVO) {
	    // 1. 페이징 처리를 위한 3중 서브쿼리의 앞부분 분리 선언
	    String sql = "select * from ("
	               + "select rownum rn, TMP.* from ("
	               + "select X.emp_id, E.emp_name, X.emp_exit_time "
	               + "from emp_exit X "
	               + "left join emp E on X.emp_id = E.emp_id ";

	    List<Object> paramList = new ArrayList<>();

	    // 2. 이름 검색 조건 동적 조립 (where 1=1을 안 쓰는 대신 완벽히 동적 제어)
	    if(pageVO.getColumn() != null && pageVO.getKeyword() != null && !pageVO.getKeyword().isEmpty()) {
	        if(pageVO.getColumn().equals("empName") || pageVO.getColumn().equals("emp_name")) {
	            
	            // 검색어가 처음 붙는 조건이므로 'where'를 붙여준다 (공백 주의)
	            sql += " where instr(E.emp_name, ?) > 0 "; 
	            paramList.add(pageVO.getKeyword());
	        }
	    }

	    // 3. 서브쿼리 내부 정렬 구문 이어 붙이기 (앞에 where가 안 붙었을 수도 있으니 공백 확보 필수)
	    sql += " order by X.emp_exit_time desc, X.emp_id asc";
	         
	    // 4. 페이징을 위한 서브쿼리 뒷부분 마감 처리
	    sql += ") TMP"
	         + ") where rn between ? and ?";

	    // 페이징 파라미터(? 자리에 들어갈 값) 추가
	    paramList.add(pageVO.getBeginRownum());
	    paramList.add(pageVO.getEndRownum());

	    // 리스트를 오브젝트 배열로 변환
	    Object[] params = paramList.toArray();
	    
	    // JdbcTemplate 실행 후 반환
	    return jdbcTemplate.query(sql, empExitMapper, params);
	}
}
