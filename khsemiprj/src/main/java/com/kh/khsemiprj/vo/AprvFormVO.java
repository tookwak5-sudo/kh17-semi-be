package com.kh.khsemiprj.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class AprvFormVO {
	private int formNo;
	private String formName;     
    private String formExplain;  
    private String formUseYn;    
    private Timestamp formWtime; 
    private int formHeadNo;
    
    //헤드 이름
    private String headName;
}
