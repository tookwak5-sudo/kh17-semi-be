package com.kh.khsemiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.HeadDto;
import com.kh.khsemiprj.dto.PlanDto;
import com.kh.khsemiprj.mapper.HeadMapper;
import com.kh.khsemiprj.mapper.PlanEmpDeptMapper;
import com.kh.khsemiprj.mapper.PlanHeadMapper;
import com.kh.khsemiprj.mapper.PlanMapper;
import com.kh.khsemiprj.vo.PageForPlanVO;
import com.kh.khsemiprj.vo.PageVO;
import com.kh.khsemiprj.vo.PlanEmpDeptVO;
import com.kh.khsemiprj.vo.PlanHeadVO;


@Repository
public class PlanDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private PlanMapper planMapper;
	@Autowired
	private HeadMapper headMapper;
	@Autowired
	private PlanHeadMapper planHeadMapper;
	@Autowired
	private PlanEmpDeptMapper planEmpDeptMapper;
	
	public int sequence() {
	    String sql = "select plan_seq.nextval from dual";
	    return jdbcTemplate.queryForObject(sql, int.class);//정해진 형태 (null 불가)
	}
	
	//일정 등록
	public void insert(PlanDto planDto) {
		String sql = "insert into plan "
				+ "(plan_no, plan_emp_id, plan_aprv_no, plan_dept_no, plan_head_no, plan_name, "
				+ "plan_type, plan_explain, plan_sdate, plan_edate) "
				+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		Object[] params = { planDto.getPlanNo(), 
				planDto.getPlanEmpId(), planDto.getPlanAprvNo(), planDto.getPlanDeptNo(), planDto.getPlanHeadNo(),
				planDto.getPlanName(), planDto.getPlanType(), planDto.getPlanExplain(), 
				planDto.getPlanSdate(), planDto.getPlanEdate()
		};
		jdbcTemplate.update(sql, params);
	}
	
	//일정 수정
	public boolean update(PlanDto planDto) {
		String sql = "update plan set "
				+ "plan_head_no =?, plan_name=?, plan_explain=?, plan_sdate=?, plan_edate=?, plan_type=? "
				+ "where plan_no = ?";
		Object[] params = {
				planDto.getPlanHeadNo(), planDto.getPlanName(), planDto.getPlanExplain(), 
				planDto.getPlanSdate(), planDto.getPlanEdate(),  planDto.getPlanType(), planDto.getPlanNo()
		};
		return jdbcTemplate.update(sql, params)> 0;
	}
	
	//일정 삭제
	public boolean delete(int planNo) {
		String sql = "delete plan where plan_no=?";
		Object[] params = { planNo };
		return jdbcTemplate.update(sql, params)>0;
	}
	
	//일정 상세
	public PlanDto selectOne(int planNo) {
		String sql = "select * from plan where plan_no = ?";
		Object[] params = { planNo };
		List<PlanDto> list = jdbcTemplate.query(sql,  planMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//type 조회
	public List<PlanDto> selectListType() {
		String sql = "select * from plan order by plan_no desc";
		return jdbcTemplate.query(sql, planMapper);
	}
	
	// head 조회 
	public List<HeadDto> selectListHeader() {
		String sql = "select * from aprv_head order by head_no asc";
		return jdbcTemplate.query(sql, headMapper);
	}
	//plan head 조인 조회
	public List<PlanHeadVO> selectListPlanHeader() {
		String sql = "select * from plan p "
				+ "left join aprv_head h on p.plan_head_no = h.HEAD_NO "
				+ "order by p.plan_no desc";
		return jdbcTemplate.query(sql, planHeadMapper);
	}	
	
	//plan head type ='일반'조인 조회
	public List<PlanHeadVO> selectListPlanHeadType() {
		String sql = "SELECT p.*, h.* FROM plan p " +
	             "JOIN aprv_head h ON p.plan_head_no = h.head_no " +
	             "WHERE h.head_type = '일반'";
		return jdbcTemplate.query(sql, planHeadMapper);
	}	
	
	public List<HeadDto> selectListHead() {
		String sql = "select * from aprv_head where head_type = '일반'";
		return jdbcTemplate.query(sql, headMapper);
	}
	
	//전체 일정 조회
    public List<PlanDto> selectList(String empId) {
    	String sql = "(SELECT * FROM PLAN p WHERE p.PLAN_EMP_ID = ? and p.PLAN_TYPE = '개인') "
    			+ "UNION "
    			+ "(SELECT * FROM plan p WHERE p.PLAN_DEPT_NO = (SELECT edr.DEPT_NO FROM EMP_DEPT_RELATION edr WHERE edr.EMP_ID = ?) and p.PLAN_TYPE = '부서') "
    			+ "UNION "
    			+ "(SELECT * FROM plan p WHERE p.PLAN_TYPE = '회사')";
        Object[] params = { empId, empId };
        return jdbcTemplate.query(sql,  planMapper, params);
    }
    
  //전체 일정 조회
    public List<PlanHeadVO> selectVOList(String empId) {
    	String sql = "SELECT TMP.*, h.* FROM ("
    			+ "(SELECT * FROM PLAN p WHERE p.PLAN_EMP_ID = ? and p.PLAN_TYPE = '개인') "
    			+ "UNION "
    			+ "(SELECT * FROM plan p WHERE p.PLAN_DEPT_NO = (SELECT edr.DEPT_NO FROM EMP_DEPT_RELATION edr WHERE edr.EMP_ID = ?) and p.PLAN_TYPE = '부서') "
    			+ "UNION "
    			+ "(SELECT * FROM plan p WHERE p.PLAN_TYPE = '회사')"
    			+ ") TMP "
    			+ "INNER JOIN aprv_head h ON h.head_no = TMP.plan_head_no ";
    	System.out.println("sql = " + sql);
        Object[] params = { empId, empId };
        return jdbcTemplate.query(sql,  planHeadMapper, params);
    }
    
    //일정제목 중복검사 조회
    public PlanDto selectOnePlanName(String planName) {
    	String sql = "select * from plan where plan_name = ?";
		Object[] params = { planName };
		List<PlanDto> list = jdbcTemplate.query(sql, planMapper, params);
		return list.isEmpty() ? null : list.get(0);
    }
    
  //일정유형 중복검사 조회
    public PlanDto selectOnePlanType(String planType) {
    	String sql = "select * from plan where plan_type = ?";
		Object[] params = { planType };
		List<PlanDto> list = jdbcTemplate.query(sql, planMapper, params);
		return list.isEmpty() ? null : list.get(0);
    }
     
 // 1. 일정 리스트 조회 
    public List<PlanEmpDeptVO> selectList(String empId, String planSdate, String planEdate, int beginRownum, int endRownum){
    	String sql = "select * from ("
    	        + "select rownum rn, TMP.* from ("
    	        + "  select p.*, e.emp_name, d.dept_name, h.head_type "
    	        + "  from plan p "
    	        + "  left outer join emp e on p.plan_emp_id = e.emp_id "
    	        + "  left outer join dept d on p.plan_dept_no = d.dept_no "
    	        + "  left outer join aprv_head h on p.plan_head_no = h.head_no "
    	        + "  where ((p.plan_type = '개인' and p.plan_emp_id = ?) or p.plan_type IN ('회사','부서')) "
    	        + "  and p.plan_sdate <= CASE WHEN ? IS NULL THEN p.plan_sdate ELSE ? END "
                + "  and p.plan_edate >= CASE WHEN ? IS NULL THEN p.plan_edate ELSE ? END "
    	        + "  order by p.plan_sdate desc"
    	        + ") TMP"
    	    + ") where rn between ? and ?";
        Object[] params = { empId, planEdate, planEdate, planSdate, planSdate, beginRownum, endRownum };
        return jdbcTemplate.query(sql, planEmpDeptMapper, params);
    }
    
    // 2. 검색목록조회 메소드 (검색 시에도 개인 일정 차단 및 SQL 에러 방지)
    public List<PlanEmpDeptVO> selectList(PageForPlanVO pageForPlanVO, String empId){
        if(pageForPlanVO.isList())
            return selectList(empId, pageForPlanVO.getPlanSdate(), pageForPlanVO.getPlanEdate(), pageForPlanVO.getBeginRownum(), pageForPlanVO.getEndRownum());
        
        Set<String> allowList = Set.of("emp_name", "dept_name" , "plan_name", "plan_type");
        if(allowList.contains(pageForPlanVO.getColumn()) == false)
            return List.of();
            
        // 오라클에서 emp_name, dept_name 검색 시 어떤 테이블 컬럼인지 명시하지 않으면 에러(Ambiguous)가 납니다.
        String col = pageForPlanVO.getColumn();
        if("emp_name".equals(col)) col = "e.emp_name";
        else if("dept_name".equals(col)) col = "d.dept_name";
        else col = "p." + col;
            
        String sql = "select * from ("
                + "select rownum rn, TMP.* from ("
                + "  select p.*, e.emp_name, d.dept_name, h.head_type "
                + "  from plan p " 
                + "  left outer join emp e on p.plan_emp_id = e.emp_id "
                + "  left outer join dept d on p.plan_dept_no = d.dept_no "
                + "  left outer join aprv_head h on p.plan_head_no = h.head_no "
                + "  where"
//                + "  instr (" + col + ", ?) > 0 " 
				+ " (instr(" + (col.equals("e.emp_name") ? "e.emp_name" : col)  + ", ?) > 0 "
				+ "or instr(" + (col.equals("e.emp_name") ? "p.plan_emp_id" : col)  + ", ?) > 0 )"
                + "  and ((p.plan_type = '개인' and p.plan_emp_id = ?) or p.plan_type IN ('회사','부서'))"
                + "  and p.plan_sdate <= CASE WHEN ? IS NULL THEN p.plan_sdate ELSE ? END "
                + "  and p.plan_edate >= CASE WHEN ? IS NULL THEN p.plan_edate ELSE ? END "
                + "  order by p.plan_sdate desc" 
                + ") TMP"
            + ") where rn between ? and ?";
            
        Object [] params = {
        		pageForPlanVO.getKeyword(),
        		pageForPlanVO.getKeyword(),
                empId,
                pageForPlanVO.getPlanEdate(),
                pageForPlanVO.getPlanEdate(),
                pageForPlanVO.getPlanSdate(),
                pageForPlanVO.getPlanSdate(),
                pageForPlanVO.getBeginRownum(),
                pageForPlanVO.getEndRownum()
                };
                
        return jdbcTemplate.query(sql, planEmpDeptMapper, params);
    }

    public int count(String empId, String planSdate, String planEdate) {
        String sql = "select count(*) from plan p "
                   + "left outer join aprv_head h on p.plan_head_no = h.head_no " // 조인 추가
                   + "where ((p.plan_type = '개인' and p.plan_emp_id = ?) "
                   + "   or p.plan_type in ('회사', '부서')) "
                   + "  and p.plan_sdate <= CASE WHEN ? IS NULL THEN p.plan_sdate ELSE ? END "
                   + "  and p.plan_edate >= CASE WHEN ? IS NULL THEN p.plan_edate ELSE ? END ";
        Object[] params = { empId, planEdate, planEdate, planSdate, planSdate };
        return jdbcTemplate.queryForObject(sql, int.class, params);
    }

    // 검색 상황별 카운트
    public int count(PageForPlanVO pageForPlanVO, String empId) {
        if(pageForPlanVO.isList()) return count(empId, pageForPlanVO.getPlanSdate(), pageForPlanVO.getPlanEdate());
        
        String col = pageForPlanVO.getColumn();
        if("emp_name".equals(col)) col = "e.emp_name";
        else if("dept_name".equals(col)) col = "d.dept_name";
        else col = "p." + col;
        
        String sql = "select count(*) "
                + "from plan p "
                + "left outer join emp e on p.plan_emp_id = e.emp_id "
                + "left outer join emp_dept_relation r on e.emp_id = r.emp_id "
                + "left outer join dept d on r.dept_no = d.dept_no "
                + "left outer join aprv_head h on p.plan_head_no = h.head_no " // 👈 조인 추가
                + "where " 
//                + "instr(" + col + ", ?) > 0 "
                + " (instr(" + (col.equals("e.emp_name") ? "e.emp_name" : col)  + ", ?) > 0 "
				+ "or instr(" + (col.equals("e.emp_name") ? "p.plan_emp_id" : col)  + ", ?) > 0 )"
                + "  and ((p.plan_type = '개인' and p.plan_emp_id = ?) or p.plan_type IN ('회사','부서')) "
                + "  and p.plan_sdate <= CASE WHEN ? IS NULL THEN p.plan_sdate ELSE ? END "
                + "  and p.plan_edate >= CASE WHEN ? IS NULL THEN p.plan_edate ELSE ? END ";
        Object[] params = { pageForPlanVO.getKeyword(),
        					pageForPlanVO.getKeyword(),
        					empId,
        					pageForPlanVO.getPlanEdate(),
        					pageForPlanVO.getPlanEdate(),
        					pageForPlanVO.getPlanSdate(),
        					pageForPlanVO.getPlanSdate()
        					};
        return jdbcTemplate.queryForObject(sql, int.class, params);    
    }
}
