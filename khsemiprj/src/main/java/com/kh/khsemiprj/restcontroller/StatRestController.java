package com.kh.khsemiprj.restcontroller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.khsemiprj.dao.StatDao;
import com.kh.khsemiprj.vo.StatVO;

@RestController
@RequestMapping("/rest/stat")
public class StatRestController {
	
	@Autowired
	private StatDao statDao;
	
	@GetMapping("/workhours")
	public List<StatVO> getWorkHours
					(@RequestParam String empId,
					@RequestParam String yearMonth) {
		return statDao.getDailyWorkHours(empId, yearMonth);
	}
}
