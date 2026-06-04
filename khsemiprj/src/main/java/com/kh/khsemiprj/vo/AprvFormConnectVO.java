package com.kh.khsemiprj.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

//첨부 파일 수정시 aprvformDao 커넥트메소드에서 반환 할때 쓰일 vo입니다.
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AprvFormConnectVO {
	private int formNo;
	private int attachNo;
}
