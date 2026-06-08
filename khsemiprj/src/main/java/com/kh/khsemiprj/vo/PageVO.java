package com.kh.khsemiprj.vo;

import lombok.Data;

//VO(Value Object) :
//- 테이블과 무관하게 필요에 의해서 데이터를 묶어두기 위한 클래스
//- 자바에서 배웠던 클래스와 가장 유사한 형태
@Data
public class PageVO {
	private String column;//파라미터에 있는 검색항목
	private String keyword;//파라미터에 있는 검색키워드
	private Integer page = 1;//파라미터에 있는 페이지번호 (없으면 1페이지)
	private Integer size = 10;//파라미터에 있는 페이지규격 (없으면 5개)
	private int count; //총 데이터 개수 (DB에서 조회해서 채워줘야함)
	
	//목록인지 검색인지 판정하는 메소드
	//- 목록 : 컬럼과 키워드 중 하나라도 없는 경우
	//- 검색 : 컬럼과 키워드 모두 있는 경우
	public boolean isList() {
		return column == null || keyword == null || keyword.trim().isEmpty();
	}
	public boolean isSearch() {
		return !isList();
	}
	
	//시작 Rownum과 종료 Rownum을 계산
	public int getBeginRownum() {
		return page * size - (size-1);
	}
	public int getEndRownum() {
		return page * size;
	}
	
	//목록 및 검색 유지용 파라미터 생성
	public String getSearchParams() {
		if(isList())
			return "size="+size;
		else
			return "size="+size+"&column="+column+"&keyword="+keyword;
	}
	//현재 페이지에 맞는 첫 블록 번호를 반환하는 메소드
	public int getBeginBlock() {
		return (page-1) /10 *10 +1;
	}
	
	//이전 블록이 존재하는지 판정하는 메소드
	public boolean hasPrevious() {
		return getBeginBlock() > 1;
	}
	
	//이전을 누르면 이동할 블록 번호를 반환하는 메소드
	public int getPreviousBlock() {
		return getBeginBlock() - 1;
	}
	
	//총 페이지수를 계산하여 반환하는 메소드 (pageCount)
	public int getPageCount() {
		return (count-1) / size + 1;
	}
	//현재 페이지 기준 마지막 블록을 계산하여 반환하는 메소드(endBlock)
	public int getEndBlock() {
		int endBlock = getBeginBlock() + 9;
		return Math.min(getPageCount(), endBlock);
	}
	//다음이 존재하는지 판정하여 반환하는 메소드
	public boolean hasNext() {
		return getEndBlock() < getPageCount();
	}
	//다음을 누르면 나올 블록번호를 계산하는 메소드(endBlock + 1)
	public int getNextBlock() {
		return getEndBlock() + 1;
	}
}
