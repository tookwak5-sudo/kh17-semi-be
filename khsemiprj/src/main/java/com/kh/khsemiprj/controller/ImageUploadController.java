package com.kh.khsemiprj.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.kh.khsemiprj.service.AttachService;

import jakarta.servlet.http.HttpServletRequest;


@RestController
@RequestMapping("/board")
public class ImageUploadController {

    @Autowired
    private AttachService attachService;

    @PostMapping("/uploadImage")
    public String uploadImage(@RequestParam("uploadFile") MultipartFile file, HttpServletRequest request) {
        if (file.isEmpty()) {
            return "error: 파일이 없습니다.";
        }

        try {
            //D드라이브 물리적 저장
            int attachNo = attachService.save(file);

            //화면에 이미지를 띄우기 위해 다운로드 컨트롤러의 주소를 반환
            return request.getContextPath() + "/download/modern?attachNo=" + attachNo;
            
        } catch (Exception e) {
            e.printStackTrace();
            return "error: 서버 파일 저장 실패";
        }
    }
}