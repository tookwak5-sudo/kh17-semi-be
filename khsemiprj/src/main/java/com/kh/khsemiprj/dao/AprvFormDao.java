package com.kh.khsemiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.khsemiprj.dto.AprvFormDto;
import com.kh.khsemiprj.mapper.AprvFormHeadNameMapper;
import com.kh.khsemiprj.mapper.AprvFormHeadTypeMapper;
import com.kh.khsemiprj.mapper.AprvFormMapper;
import com.kh.khsemiprj.mapper.AprvFormSelectHeadMapper;
import com.kh.khsemiprj.mapper.AprvFormSelectHomeListMapper;
import com.kh.khsemiprj.mapper.AprvFormSelectMapper;
import com.kh.khsemiprj.mapper.AprvFormVOMapper;
import com.kh.khsemiprj.mapper.AprvMapper;
import com.kh.khsemiprj.vo.AprvFormConnectVO;
import com.kh.khsemiprj.vo.AprvFormHeadNameVO;
import com.kh.khsemiprj.vo.AprvFormHeadTypeVO;
import com.kh.khsemiprj.vo.AprvFormSelectHomeListVO;
import com.kh.khsemiprj.vo.AprvFormSelectVO;
import com.kh.khsemiprj.vo.AprvFormVO;
import com.kh.khsemiprj.vo.PageVO;

@Repository
public class AprvFormDao {

	private final AprvMapper aprvMapper;
	@Autowired
	JdbcTemplate jdbcTemplate;
	@Autowired
	AprvFormMapper aprvFormMapper;
	@Autowired
	AprvFormSelectHomeListMapper aprvFormSelectHomeListMapper;
	@Autowired
	AprvFormSelectMapper aprvFormSelectMapper;
	@Autowired
	AprvFormSelectHeadMapper aprvFormSelectHeadMapper;
	@Autowired
	AprvFormHeadNameMapper aprvFormHeadNameMapper;
	@Autowired
	AprvFormHeadTypeMapper aprvFormHeadTypeMapper;
	@Autowired
	AprvFormVOMapper aprvFormVOMapper;

	private Set<String> allowColumns = Set.of("form_name", "form_head");

	AprvFormDao(AprvMapper aprvMapper) {
		this.aprvMapper = aprvMapper;
	}

	// 개별 파일 필요시
	public AprvFormDto selectOne(int formNo) {
		String sql = "select * from aprv_form where form_no = ?";
		Object[] params = { formNo };
		List<AprvFormDto> list = jdbcTemplate.query(sql, aprvFormMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// 개별 파일인데 헤드 필요시(현재 타입네임과 결합 되어있는데 이거 제가 나중에 분리 하겠습니다.)
	public AprvFormSelectVO selectOneUsingHead(int formNo) {

		String sql = "select af.*, ah.head_name, ah.head_type " + "from aprv_form af "
				+ "left join aprv_head ah on af.form_head_no = ah.head_no " + "where af.form_no = ?";
		Object[] params = { formNo };
		List<AprvFormSelectVO> list = jdbcTemplate.query(sql, aprvFormSelectMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// 개별 파일인데 타입만 필요시(현재 헤드네임과 결합 되어있는데 이거 제가 나중에 분리 하겠습니다.)
	public AprvFormSelectVO selectOneUsingType(int formNo) {

		String sql = "select af.*, ah.head_type, ah.head_name " + "from aprv_form af "
				+ "left join aprv_head ah on af.form_head_no = ah.head_no " + "where af.form_no = ?";
		Object[] params = { formNo };
		List<AprvFormSelectVO> list = jdbcTemplate.query(sql, aprvFormSelectMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// 오직 헤드 타입 목록만 가져오는 메소드 ('일반' 제외)
	//distinct는 공시 때 봤던 컴퓨터 일반 교재에서 참고했습니다.
		public List<AprvFormHeadTypeVO> selectFilteredTypeList() {
			
			String sql = "select distinct head_type from aprv_head where head_type != '일반'";

			return jdbcTemplate.query(sql, aprvFormHeadTypeMapper);
		}

		// 오직 head_name만 딱 뽑아오는 메소드 ('일반' 타입에 속한 이름들 제외)
		public List<AprvFormHeadNameVO> selectFilteredHeadList() {
			
			String sql = "select head_name from aprv_head where head_type != '일반'";

			return jdbcTemplate.query(sql, aprvFormHeadNameMapper);
		}
		
		
		
	// 목록 및 키워드로 조회
	public List<AprvFormSelectVO> selectList(int page, int size) {
		String sql = "select * from (" + "select rownum rn, TMP.* from (" + "select af.*, ah.head_name, ah.head_type "
				+ "from aprv_form af " + "left join aprv_head ah on af.form_head_no = ah.head_no "
				+ "order by af.form_no desc" + ") TMP" + ") where rn between ? and ?";
		int beginRow = page * size - (size - 1);
		int endRow = page * size;
		Object[] params = { beginRow, endRow };
		return jdbcTemplate.query(sql, aprvFormSelectMapper, params);
	}

	public List<AprvFormSelectVO> selectList(PageVO pageVO) {
		if (pageVO.isList())
			return selectList(pageVO.getPage(), pageVO.getSize());
		if (!allowColumns.contains(pageVO.getColumn()))
			return selectList(pageVO.getPage(), pageVO.getSize());

		// 빈 검색 sql문장을 먼저 만든후 조건에 따라 분기 시켰습니다.
		String search = "";

		if (pageVO.getColumn().equals("form_name")) {
			search = "where instr(af.form_name, ?) > 0 ";
		}

		else if (pageVO.getColumn().equals("form_head")) {
			search = "where instr(ah.head_name,?) >0 ";
		}

		else if (pageVO.getColumn().equals("head_type")) {
			search = "where instr(ah.head_type,?) >0 ";
		}

		String sql = "select * from (" + "select rownum rn, TMP.* from ("
				+ "select af.*, ah.head_name from aprv_form af "
				+ "left join aprv_head ah on af.form_head_no = ah.head_no " + search + "order by af.form_no desc"
				+ ") TMP " + ") where rn between ? and ?";
		Object[] params = { pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum() };
		return jdbcTemplate.query(sql, aprvFormSelectMapper, params);
	}

	public List<AprvFormVO> selectListForInsert() {
		String sql = "select * from (" + "select rownum rn, TMP.* from (" + "select * from aprv_form af "
				+ "inner join aprv_head ah on ah.head_no = af.form_head_no " + "where form_use_yn = 'Y' "
				+ "order by form_no asc " + ") TMP" + ")";
		Object[] params = {};
		return jdbcTemplate.query(sql, aprvFormVOMapper, params);
	}

	public AprvFormDto selectOneByName(String formName) {
		String sql = "select * from aprv_form where form_name = ?";
		Object[] params = { formName };
		List<AprvFormDto> list = jdbcTemplate.query(sql, aprvFormMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	public int sequence() {
		String sql = "select form_no_seq.nextval from dual";
		int nextNo = jdbcTemplate.queryForObject(sql, int.class);
		return nextNo;
	}

	// 서비스에서 번호 넣을때 훨씬 변해서 vo 반환을 택했습니다.
	public AprvFormVO insertForm(AprvFormDto aprvFormDto) {

		int currentNo = this.sequence();

		// 사용 여부 null 체크 안전장치
		if (aprvFormDto.getFormUseYn() == null) {
			aprvFormDto.setFormUseYn("N");
		}

		// 원래 쓰던 확실한 VALUES 쿼리로 복구
		String sql = "insert into aprv_form(form_no, form_name, form_explain, form_use_yn, form_wtime, form_head_no) "
				+ "values(?, ?, ?, ?, systimestamp, ?)";

		Object[] params = { 
				currentNo, 
				aprvFormDto.getFormName(), 
				aprvFormDto.getFormExplain(), 
				aprvFormDto.getFormUseYn(),
				aprvFormDto.getFormHeadNo() // 여기서 진짜 번호를 받아서 넣음
		};

		jdbcTemplate.update(sql, params);

		aprvFormDto.setFormNo(currentNo);

		AprvFormVO aprvFormVo = new AprvFormVO();
		aprvFormVo.setFormNo(currentNo);

		return aprvFormVo;
	}
	
	
	//head_no 찾아주는 메소드
	public int findHeadNo(String headName, String headType) {
	    String sql = "select head_no from aprv_head where head_name = ? and head_type = ?";
	    try {
	        return jdbcTemplate.queryForObject(sql, Integer.class, headName, headType);
	    } catch (Exception e) {
	        return 0; 
	    }
	}

	public void insert(AprvFormDto aprvFormDto) {
		int currentNo = this.sequence();

		String sql = "insert into aprv_form( " + "form_no, form_name, form_explain, form_use_yn, "
				+ "form_wtime, form_head_no) " + "values(?, ?, ?, ?, systimestamp, ?)";

		Object[] params = { currentNo, // 컨트롤러에서 다음번호를 받아주는게 아닌 인서트 구문에서 받아주도록 만들었습니다.
				aprvFormDto.getFormName(), aprvFormDto.getFormExplain(), aprvFormDto.getFormUseYn(),
				aprvFormDto.getFormHeadNo() };

		jdbcTemplate.update(sql, params);
	}

	public AprvFormConnectVO connect(int formNo, int attachNo) {
		String sql = "insert into form_file(form_no,attach_no) values(?, ?)";
		Object[] params = { formNo, attachNo };
		jdbcTemplate.update(sql, params);
		AprvFormConnectVO aprvFormConnectVo = new AprvFormConnectVO();
		aprvFormConnectVo.setAttachNo(attachNo);
		aprvFormConnectVo.setFormNo(formNo);
		return aprvFormConnectVo;
	}

	// 양식 본문 수정
		public boolean update(AprvFormDto aprvFormDto) {
			
			String sql = "update aprv_form " 
					+ "set form_name=?, " 
					+ "form_explain=?, " 
					+ "form_use_yn=?, "
					+ "form_head_no=?,  " 
					+ "form_wtime=systimestamp " 
					+ "where form_no=?";
					
			Object[] params = { 
					aprvFormDto.getFormName(), 
					aprvFormDto.getFormExplain(), 
					aprvFormDto.getFormUseYn(),
					aprvFormDto.getFormHeadNo(), // 컨트롤러가 찾아서 채워준 번호가 들어감
					aprvFormDto.getFormNo() 
			};

			return jdbcTemplate.update(sql, params) > 0;
		}

	public boolean delete(int formNo) {
		String sql = "delete aprv_form where form_no=?";
		Object[] params = { formNo };
		return jdbcTemplate.update(sql, params) > 0;
	}

	// 파일 연결 관계 끊어 버리는 메소드
	public boolean disconnect(int formNo, int attachNo) {
		String sql = "delete from form_file where form_no = ? and attach_no = ?";
		Object[] params = { formNo, attachNo };
		return jdbcTemplate.update(sql, params) > 0;
	}

	public Integer findAttachNo(int formNo) {
		String sql = "select attach_no from form_file where form_no=?";
		Object[] params = { formNo };
		try {
			return jdbcTemplate.queryForObject(sql, Integer.class, params);
		} catch (Exception e) {
			e.getMessage();
			return null;
		}
	}

	// 승인 대기 결재 문서 조회
	// 해당 sql 조인 구문 전용 vo, 매퍼를 만들었습니다.
	public List<AprvFormSelectHomeListVO> selectHomeList() {
		String sql = "select " + "f.form_no AS formNo, " + "f.form_name AS formName, " + "h.head_name AS headName, "
				+ "d.aprv_title AS aprvTitle, " + "d.aprv_writer AS aprvWriter, " + "d.aprv_sdate AS aprvSdate, "
				+ "d.aprv_edate AS aprvEdate " + "from aprv_document d "
				+ "left join aprv_form f on d.aprv_no = f.form_no "
				+ "left join aprv_head h on f.form_head_no = h.head_no "
				// + ") where h.head_type='결재'";
				+ "order by d.aprv_edate asc, d.aprv_no asc";
		return jdbcTemplate.query(sql, aprvFormSelectHomeListMapper);
	}
}
