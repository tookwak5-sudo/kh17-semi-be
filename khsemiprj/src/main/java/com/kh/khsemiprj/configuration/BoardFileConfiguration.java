package com.kh.khsemiprj.configuration;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class BoardFileConfiguration implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
    	String rootPath = System.getProperty("user.dir");
        String uploadPath = "file:///" + rootPath + "/src/main/resources/static/upload/board/";

        registry.addResourceHandler("/upload/board/**")
                .addResourceLocations(uploadPath);
    }
}