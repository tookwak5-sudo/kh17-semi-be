package com.kh.khsemiprj.vo;

import java.sql.Timestamp;



import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data @Builder @AllArgsConstructor @NoArgsConstructor
public class AprvFormSelectVO {
	
	
	    private int formNo;         
	    private String formName;     
	    private String formExplain;  
	    private String formUseYn;    
	    private Timestamp formWtime; 
	    private int formHeadNo;
	    
	    private String headName;//조인을 해서 분류명을 가져올 떄 필요해서 여기선 추가 되었습니다.
	    private String headType;//조인을 해서 헤드타입을 가져올 때 필요해서 추가 했습니다.
	}

