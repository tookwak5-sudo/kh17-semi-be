package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AprvFormSelectHomeListVO {
	// 결재 양식
    private int formNo;
    private String formName;

    // 양식 분류
    private String headName;
    
    // 결재문서
    private String aprvTitle;
    private String aprvWriter;
    private Timestamp aprvSdate;
    private Timestamp aprvEdate;
}