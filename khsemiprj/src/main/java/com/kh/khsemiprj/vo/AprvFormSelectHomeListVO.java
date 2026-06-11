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
    private int formNo;
    private String formName;
    private String headName;
    private String aprvTitle;
    private String aprvWriter;
    private Timestamp aprvSdate;
    private Timestamp aprvEdate;
}