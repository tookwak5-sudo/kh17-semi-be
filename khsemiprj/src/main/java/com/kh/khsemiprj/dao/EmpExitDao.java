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

    // 1. 전체 데이터 개수(Count) 조회 (이름 검색 추가)
    public int count(PageVO pageVO, String empName) {
        String sql = "";
        List<Object> params = new ArrayList<>();

        boolean isDateSearch = pageVO.isDateSearch();
        boolean isNameSearch = empName != null && !empName.equals("");

        // 1) 날짜 + 이름 둘 다 검색할 때
        if (isDateSearch && isNameSearch) {
            sql = "select count(*) "
                + "from emp_exit X "
                + "left join emp E on X.emp_id = E.emp_id "
                + "left join aprv_document D on E.emp_id = D.aprv_writer "
                + "where X.emp_exit_time >= to_date(?, 'YYYY-MM-DD HH24:MI:SS') "
                + "and X.emp_exit_time <= to_date(?, 'YYYY-MM-DD HH24:MI:SS') "
                + "and E.emp_name like '%' || ? || '%'";
            
            params.add(pageVO.getStartDate() + " 00:00:00");
            params.add(pageVO.getEndDate() + " 23:59:59");
            params.add(empName);
        } 
        // 2) 날짜만 검색할 때
        else if (isDateSearch) {
            sql = "select count(*) "
                + "from emp_exit X "
                + "left join emp E on X.emp_id = E.emp_id "
                + "left join aprv_document D on E.emp_id = D.aprv_writer "
                + "where X.emp_exit_time >= to_date(?, 'YYYY-MM-DD HH24:MI:SS') "
                + "and X.emp_exit_time <= to_date(?, 'YYYY-MM-DD HH24:MI:SS')";
            
            params.add(pageVO.getStartDate() + " 00:00:00");
            params.add(pageVO.getEndDate() + " 23:59:59");
        }
        // 3) 이름만 검색할 때
        else if (isNameSearch) {
            sql = "select count(*) "
                + "from emp_exit X "
                + "left join emp E on X.emp_id = E.emp_id "
                + "left join aprv_document D on E.emp_id = D.aprv_writer "
                + "where E.emp_name like '%' || ? || '%'";
            
            params.add(empName);
        }
        // 4) 아무 조건 없이 전체 조회할 때
        else {
            sql = "select count(*) "
                + "from emp_exit X "
                + "left join emp E on X.emp_id = E.emp_id "
                + "left join aprv_document D on E.emp_id = D.aprv_writer";
        }

        return jdbcTemplate.queryForObject(sql, Integer.class, params.toArray());
    }

    // 2. 3중 조인 목록 조회 (페이징, 이름 검색 포함)
    public List<EmpExitVO> selectList(PageVO pageVO, String empName) {
        String sql = "";
        List<Object> params = new ArrayList<>();

        boolean isDateSearch = pageVO.isDateSearch();
        boolean isNameSearch = empName != null && !empName.equals("");

        // 1) 날짜 + 이름 둘 다 검색할 때
        if (isDateSearch && isNameSearch) {
            sql = "select * from ("
                + "select rownum rn, TMP.* from ("
                + "select X.emp_id, E.emp_name, X.emp_exit_time, D.aprv_etime "
                + "from emp_exit X "
                + "left join emp E on X.emp_id = E.emp_id "
                + "left join aprv_document D on E.emp_id = D.aprv_writer "
                + "where X.emp_exit_time >= to_date(?, 'YYYY-MM-DD HH24:MI:SS') "
                + "and X.emp_exit_time <= to_date(?, 'YYYY-MM-DD HH24:MI:SS') "
                + "and E.emp_name like '%' || ? || '%' "
                + "order by X.emp_exit_time desc, X.emp_id asc"
                + ") TMP"
                + ") where rn between ? and ?";
            
            params.add(pageVO.getStartDate() + " 00:00:00");
            params.add(pageVO.getEndDate() + " 23:59:59");
            params.add(empName);
        } 
        // 2) 날짜만 검색할 때
        else if (isDateSearch) {
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
            
            params.add(pageVO.getStartDate() + " 00:00:00");
            params.add(pageVO.getEndDate() + " 23:59:59");
        }
        // 3) 이름만 검색할 때
        else if (isNameSearch) {
            sql = "select * from ("
                + "select rownum rn, TMP.* from ("
                + "select X.emp_id, E.emp_name, X.emp_exit_time, D.aprv_etime "
                + "from emp_exit X "
                + "left join emp E on X.emp_id = E.emp_id "
                + "left join aprv_document D on E.emp_id = D.aprv_writer "
                + "where E.emp_name like '%' || ? || '%' "
                + "order by X.emp_exit_time desc, X.emp_id asc"
                + ") TMP"
                + ") where rn between ? and ?";
            
            params.add(empName);
        }
        // 4) 아무 조건 없이 전체 조회할 때
        else {
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

        // 페이징 번호는 모든 분기에서 마지막에 공통으로 들어감
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