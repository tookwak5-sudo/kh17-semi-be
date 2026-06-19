package com.kh.khsemiprj.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @GetMapping("/memo/checkNewMemo")
    public Map<String, Object> checkNewMemo(HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        String loginId = (String) session.getAttribute("loginId"); // 학원 세션키 확인 필수

        if (loginId == null) {
            map.put("hasNewMemo", false);
            return map;
        }

        // 남이 만든 selectList를 활용: 내 쪽지함 1페이지의 딱 1개(가장 최신 쪽지)만 긁어옴
        List<MemoDto> list = memoDao.selectList(loginId, 1, 1);

        // 나한테 온 쪽지가 아예 없으면 컷
        if (list == null || list.isEmpty()) {
            map.put("hasNewMemo", false);
            return map;
        }

        // 가장 최신 쪽지 객체 꺼내기
        MemoDto latestMemo = list.get(0);
        int latestMemoNo = latestMemo.getMemoNo();

        // 세션에서 "내가 마지막으로 팝업을 띄웠던 쪽지 번호"를 확인
        Integer lastAlertedNo = (Integer) session.getAttribute("lastAlertedNo");

        // [핵심] 알림 기록이 없거나, 방금 온 최신 쪽지 번호가 기존 알림 번호보다 크다면? -> "진짜 새 쪽지 뜸"
        if (lastAlertedNo == null || latestMemoNo > lastAlertedNo) {
            
            // 세션 갱신 (다음 3초 뒤 체크할 때는 이 번호로 걸러짐)
            session.setAttribute("lastAlertedNo", latestMemoNo);

            map.put("hasNewMemo", true);
            map.put("memoNo", latestMemoNo); // 팝업창 열 때 주소에 태울 번호 전달
            return map;
        }

        map.put("hasNewMemo", false);
        return map;
    }
}