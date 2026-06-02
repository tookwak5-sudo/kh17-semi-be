package com.kh.khsemiprj.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.kh.khsemiprj.dao.CertDao;

@Service
public class CertService {
	
	@Autowired
	private CertDao certDao;
	@Scheduled(cron = "0 0 * * * *")
	public void clear() {
		System.out.println("청소시작! " + LocalDateTime.now());
	}

}
