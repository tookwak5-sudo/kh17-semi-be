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
    	int currentDbCount;
    	CacheValue(int latestMemoNo, long timestamp, int currentDbCount) {
    		this.latestMemoNo = latestMemoNo;
    		this.timestamp = timestamp;
    		this.currentDbCount = currentDbCount;
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
        int currentDbCount = memoDao.memoCount(loginId);
        // 캐시 확인 로직
        CacheValue cached = memoCache.get(loginId);
       
        if(cached != null && (currentTime - cached.timestamp) < CACHE_DURATION) {
        	// 1. 캐시가 존재하고 3초가 지나지 않았다면? -> DB 안 가고 캐시 데이터 사용!
        	latestMemoNo = cached.latestMemoNo;
        	currentDbCount = cached.currentDbCount;
        }
        else {
        	// 2. 캐시가 없거나 3초가 지났다면? -> DB 조회 후 캐시 갱신
        	List<MemoDto> list = memoDao.selectList(loginId, 1, 1);
            
            if (list == null || list.isEmpty()) {
                map.put("hasNewMemo", false);
                map.put("unreadCount", currentDbCount);
                return map;
            }
            
            latestMemoNo = list.get(0).getMemoNo();
            //캐시에 새로 저장 하게 된 현재 db에 저장된 안 읽은 수
            currentDbCount = memoDao.memoCount(loginId);
            // 새로운 캐시 저장 (현재 시간 스탬프 포함)
            memoCache.put(loginId, new CacheValue(latestMemoNo, currentTime, currentDbCount));
        }
        
        // 세션에서 내가 마지막으로 팝업을 띄웠던 쪽지 번호 확인
        Integer lastAlertedNo = (Integer) session.getAttribute("lastAlertedNo");
        
        // 최신 번호와 세션 번호 비교 (기존 로직 동일)
        if (lastAlertedNo == null || latestMemoNo > lastAlertedNo) {
            
        	// 만약 캐시된 데이터를 썼는데 새 알림 구조라면, 
            // 그 사이에 카운트가 바뀌었을 수 있으므로 정확한 카운트를 위해 DB를 한 번 더 찌름
            if (cached != null && (currentTime - cached.timestamp) < CACHE_DURATION) {
                currentDbCount = memoDao.memoCount(loginId);
                // DB 찌른 김에 캐시도 최신화
                memoCache.put(loginId, new CacheValue(latestMemoNo, currentTime, currentDbCount));
            }
        	
        	session.setAttribute("lastAlertedNo", latestMemoNo);
            map.put("hasNewMemo", true);
            map.put("memoNo", latestMemoNo);
            map.put("unreadCount", currentDbCount); // 갱신된 총 안 읽은 개수 전달
           
            return map;
        }

        map.put("hasNewMemo", false);
        map.put("unreadCount", currentDbCount);
        return map;
    }
}