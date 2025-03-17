package kr.co.aspn.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.QNSDao;
import kr.co.aspn.service.QNSService;

@Service
public class QNSServiceImpl implements QNSService{
	
	@Autowired
	QNSDao qnsDao;
	
	@Override
	public String insertQNSH(Map<String, Object> param) {
		if(qnsDao.insertQNSH(param) > 0)
			return "S";
		else
			return "E";
	}
}
