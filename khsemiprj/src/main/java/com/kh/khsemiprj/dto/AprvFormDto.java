package com.kh.khsemiprj.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @AllArgsConstructor @NoArgsConstructor
public class AprvFormDto {
    private int formNo;         
    private String formName;     
    private String formExplain;  
    private String formUseYn;    
    private Timestamp formWtime; 
    private int formHeadNo;
    
    private String headName;
}