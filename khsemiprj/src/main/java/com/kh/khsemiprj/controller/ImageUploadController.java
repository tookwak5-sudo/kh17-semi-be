package com.kh.khsemiprj.controller;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;


@RestController
@RequestMapping("/board")
public class ImageUploadController {

    @PostMapping("/uploadImage") //
    public String uploadImage(@RequestParam("uploadFile") MultipartFile file,
    						  HttpServletRequest request) {
        
        if (file.isEmpty()) {
            return "error: 파일이 없습니다.";
        }

        String rootPath = System.getProperty("user.dir");
        String uploadFolder = rootPath + "/src/main/resources/static/upload/board/";
        
        File dir = new File(uploadFolder);
        if (!dir.exists()) {
            dir.mkdirs(); 
        }

        // 파일명 중복 방지 (UUID)
        String originalFilename = file.getOriginalFilename();
        String ext = originalFilename.substring(originalFilename.lastIndexOf(".")); 
        String savedFilename = UUID.randomUUID().toString() + ext; 

        // 지정한 프로젝트 내부 경로에 파일 저장
        File targetFile = new File(uploadFolder + savedFilename);
        try {
            file.transferTo(targetFile); 
        } catch (IOException e) {
            e.printStackTrace();
            return "error: 서버 파일 저장 실패";
        }

        String returnUrl = request.getContextPath() + "/upload/board/" + savedFilename;
        return returnUrl;
    }
}