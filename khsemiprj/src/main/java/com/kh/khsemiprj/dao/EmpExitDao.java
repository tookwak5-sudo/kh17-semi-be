package com.kh.khsemiprj.dao;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.EmpExitDto;
import com.kh.khsemiprj.mapper.EmpExitMapper;
import com.kh.khsemiprj.mapper.EmpExitVOMapper;
import com.kh.khsemiprj.vo.EmpExitVO;
import com.kh.khsemiprj.vo.PageVO;

@Repository
public class EmpExitDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private EmpExitVOMapper empExitVOMapper;

    @Autowired
    private EmpExitMapper empExitMapper;
    // 1. 전체 데이터 개수(Count) 조회
    public int count(PageVO pageVO) {
        String sql = "";
        List<Object> params = new ArrayList<>();

        // 날짜 검색 조건이 있을 때와 없을 때로 명확하게 if-else 분기
        if (pageVO.isDateSearch()) {
            // 날짜 검색용 쿼리 (WHERE 절 추가)
            sql = "select count(*) "
                + "from emp_exit X "
                + "left join emp E on X.emp_id = E.emp_id "
                + "left join aprv_document D on E.emp_id = D.aprv_writer "
                + "where X.emp_exit_time >= to_date(?, 'YYYY-MM-DD HH24:MI:SS') "
                + "and X.emp_exit_time <= to_date(?, 'YYYY-MM-DD HH24:MI:SS')";
            
            params.add(pageVO.getStartDate() + " 00:00:00");
            params.add(pageVO.getEndDate() + " 23:59:59");
        } 
        else {
            // 전체 조회용 쿼리 (WHERE 절 없음)
            sql = "select count(*) "
                + "from emp_exit X "
                + "left join emp E on X.emp_id = E.emp_id "
                + "left join aprv_document D on E.emp_id = D.aprv_writer";
        }

        return jdbcTemplate.queryForObject(sql, Integer.class, params.toArray());
    }

    // 2. 3중 조인 목록 조회 (페이징 포함)
    public List<EmpExitVO> selectList(PageVO pageVO) {
        String sql = "";
        List<Object> params = new ArrayList<>();

        // 3중 서브쿼리 골격은 유지하되, 내부 WHERE 절만 if-else로 제어
        if (pageVO.isDateSearch()) {
            // 날짜 검색 조건이 포함된 쿼리 문자열 조립
            sql = "select * from ("
                + "select rownum rn, TMP.* from ("
                + "select X.emp_id, E.emp_name, X.emp_exit_time, D.aprv_etime "
                + "from emp_exit X "
                + "left join emp E on X.emp_id = E.emp_id "
                + "left join aprv_document D on E.emp_id = D.aprv_writer "
                + "where X.emp_exit_time >= to_date(?, 'YYYY-MM-DD HH24:MI:SS') "
                + "and X.emp_exit_time <= to_date(?, 'YYYY-MM-DD HH24:MI:SS') "
                + "order by X.emp_exit_time desc, X.emp_id asc"
                + ") TMP"
                + ") where rn between ? and ?";

            // 파라미터 순서 주의: 날짜 시작일 -> 날짜 종료일 -> 페이징 시작번호 -> 페이징 끝번호
            params.add(pageVO.getStartDate() + " 00:00:00");
            params.add(pageVO.getEndDate() + " 23:59:59");
        } 
        else {
            // 기존에 네가 쓰던 날짜 조건 없는 쿼리 형태 그대로 유지
        	 sql = "select * from ("
                     + "select rownum rn, TMP.* from ("
                     + "select X.emp_id, E.emp_name, X.emp_exit_time, D.aprv_etime "
                     + "from emp_exit X "
                     + "left join emp E on X.emp_id = E.emp_id "
                     + "left join aprv_document D on E.emp_id = D.aprv_writer "
                     + "order by X.emp_exit_time desc, X.emp_id asc"
                     + ") TMP"
                     + ") where rn between ? and ?";
        }

        // 페이징 번호는 날짜 검색 여부와 상관없이 무조건 마지막에 공통으로 들어감
        params.add(pageVO.getBeginRownum());
        params.add(pageVO.getEndRownum());

        return jdbcTemplate.query(sql, empExitVOMapper, params.toArray());
    }
    
    
 // 5. 단일 퇴사 정보 상세 조회 (기존 유지)
 	public EmpExitDto selectOne(String empId) {
 		String sql = "select * from emp_exit where emp_id = ? ";
 		Object[] params = { empId };
 		List<EmpExitDto> list = jdbcTemplate.query(sql, empExitMapper, params);
 		return list.isEmpty() ? null : list.get(0);
 	}
}