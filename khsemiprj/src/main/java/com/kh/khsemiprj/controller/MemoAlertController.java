package com.kh.khsemiprj.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kh.khsemiprj.dao.MemoDao;
import com.kh.khsemiprj.dto.MemoDto;

import jakarta.servlet.http.HttpSession;

@RestController
public class MemoAlertController {

    @Autowired
    private MemoDao memoDao; // 기존 DAO 주입 (안전)
    
    // [캐시 저장소] 로그인ID별로 (최신쪽지 번호, 캐시생성시간)을 저장하는 구조
    private final Map<String, CacheValue> memoCache = new ConcurrentHashMap<>();
    
    // 캐시 유지 시간 설정 (3초 = 3000밀리초)
    private static final long CACHE_DURATION = 3000;
    
    // 캐시에 담을 데이터 구조 내부 클래스
    private static class CacheValue {
    	int latestMemoNo;
    	long timestamp;
    	
    	CacheValue(int latestMemoNo, long timestamp) {
    		this.latestMemoNo = latestMemoNo;
    		this.timestamp = timestamp;
    	}
    }
    
    @GetMapping("/memo/checkNewMemo")
    public Map<String, Object> checkNewMemo(HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        String loginId = (String) session.getAttribute("loginId"); // 학원 세션키 확인 필수

        if (loginId == null) {
            map.put("hasNewMemo", false);
            return map;
        }
        
        long currentTime = System.currentTimeMillis();
        int latestMemoNo = 0;
        
        // 캐시 확인 로직
        CacheValue cached = memoCache.get(loginId);
        
        if(cached != null && (currentTime - cached.timestamp) < CACHE_DURATION) {
        	// 1. 캐시가 존재하고 3초가 지나지 않았다면? -> DB 안 가고 캐시 데이터 사용!
        	latestMemoNo = cached.latestMemoNo;
        }
        else {
        	// 2. 캐시가 없거나 3초가 지났다면? -> DB 조회 후 캐시 갱신
        	List<MemoDto> list = memoDao.selectList(loginId, 1, 1);
            
            if (list == null || list.isEmpty()) {
                map.put("hasNewMemo", false);
                return map;
            }
            
            latestMemoNo = list.get(0).getMemoNo();
            // 새로운 캐시 저장 (현재 시간 스탬프 포함)
            memoCache.put(loginId, new CacheValue(latestMemoNo, currentTime));
        }
        
        // 세션에서 내가 마지막으로 팝업을 띄웠던 쪽지 번호 확인
        Integer lastAlertedNo = (Integer) session.getAttribute("lastAlertedNo");
        
        // 최신 번호와 세션 번호 비교 (기존 로직 동일)
        if (lastAlertedNo == null || latestMemoNo > lastAlertedNo) {
            session.setAttribute("lastAlertedNo", latestMemoNo);
            map.put("hasNewMemo", true);
            map.put("memoNo", latestMemoNo);
            return map;
        }

        map.put("hasNewMemo", false);
        return map;
    }
}