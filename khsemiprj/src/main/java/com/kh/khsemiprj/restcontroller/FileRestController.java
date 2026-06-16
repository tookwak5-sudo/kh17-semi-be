package com.kh.khsemiprj.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpServletRequest;

import com.kh.khsemiprj.service.AttachService;

// 이름과 주소를 범용적으로 변경합니다.
@RestController
@RequestMapping("/rest/file") 
public class FileRestController {

    @Autowired
    private AttachService attachService;

    @PostMapping("/upload")
    public String upload(@RequestParam("uploadFile") MultipartFile file, HttpServletRequest request) {
        if (file.isEmpty()) {
            return "error: 파일이 없습니다.";
        }
        
        try {
            int attachNo = attachService.save(file);
            
            // 저장된 파일을 볼 수 있는 다운로드 주소를 반환
            return request.getContextPath() + "/download/modern?attachNo=" + attachNo;
            
        } catch (Exception e) {
            e.printStackTrace();
            return "error: 서버 파일 저장 실패";
        }
    }
}