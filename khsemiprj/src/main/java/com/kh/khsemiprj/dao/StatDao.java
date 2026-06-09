package com.kh.khsemiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.mapper.StatMapper;
import com.kh.khsemiprj.vo.StatVO;

@Repository
public class StatDao {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private StatMapper statMapper;
	
	public List<StatVO> getDailyWorkHours(String empId, String yearMonth) {
		String sql = "SELECT "
                + "    work_week AS title, "
                + "    ROUND(SUM(daily_hours), 1) AS value "
                + "FROM ("
                + "    SELECT "
                + "        TO_CHAR(log_inout_time, 'W') || '주차' AS work_week, "
                + "        (MAX(CAST(CASE WHEN log_inout_type = '퇴근' THEN log_inout_time END AS DATE)) - "
                + "         MIN(CAST(CASE WHEN log_inout_type = '출근' THEN log_inout_time END AS DATE))) * 24 AS daily_hours "
                + "    FROM log_inout "
                + "    WHERE log_inout_emp_id = ? "
                + "      AND TO_CHAR(log_inout_time, 'YYYY-MM') = ? "
                + "    GROUP BY TRUNC(CAST(log_inout_time AS DATE)), TO_CHAR(log_inout_time, 'W') "
                + ") "
                + "GROUP BY work_week "
                + "ORDER BY title ASC";
		
		return jdbcTemplate.query(sql, statMapper, empId, yearMonth);
	}
}