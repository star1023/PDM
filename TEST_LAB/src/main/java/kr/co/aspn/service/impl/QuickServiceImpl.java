package kr.co.aspn.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.QuickDao;
import kr.co.aspn.service.QuickService;

@Service
public class QuickServiceImpl implements QuickService {
	
	@Autowired
	QuickDao quickDao;
	
	@Override
	public int registQuick(Map<String, Object> param) {
		return quickDao.registQuick(param);
	}
	
	@Override
	public List<Map<String, Object>> getQuickInfoList(Map<String, Object> param) {
		return quickDao.getQuickInfoList(param);
	}
	
	@Override
	public int deleteQuickInfo(Map<String, Object> param) {
		return quickDao.deleteQuickInfo(param);
	}
}
