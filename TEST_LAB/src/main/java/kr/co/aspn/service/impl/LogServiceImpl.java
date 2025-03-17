package kr.co.aspn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.LogDao;
import kr.co.aspn.service.LogService;
import kr.co.aspn.util.PageNavigator;

@Service
public class LogServiceImpl implements LogService{
	private Logger logger = LoggerFactory.getLogger(LogServiceImpl.class);
	
	@Autowired
	LogDao logDao;
	
	@Override
	public Map<String, Object> getLoginLogList(Map<String, Object> param) throws Exception {
		//자재코드 전체 수
		int totalCount = logDao.getLoginLogListTotal(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> loginLogList = logDao.getLoginLogList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("totalCount", totalCount);
		map.put("loginLogList", loginLogList);
		map.put("navi", navi);
		map.put("paramVO", param);

		return map;
	}
	
	@Override
	public Map<String, Object> getBomLogList(Map<String, Object> param) throws Exception {
		int totalCount = logDao.getBomLogListTotal(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> bomLogList = logDao.getBomLogList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("totalCount", totalCount);
		map.put("bomLogList", bomLogList);
		map.put("navi", navi);
		map.put("paramVO", param);
		return map;
	}
	
	@Override
	public Map<String, Object> commonLogListAjax(Map<String, Object> param) throws Exception {
		int totalCount = logDao.getCommonLogListTotal(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> commonLogList = logDao.getCommonLogList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("totalCount", totalCount);
		map.put("commonLogList", commonLogList);
		map.put("navi", navi);
		map.put("paramVO", param);
		return map;
	}
	
	@Override
	public Map<String, Object> printLogListAjax(Map<String, Object> param) throws Exception {
		int totalCount = logDao.getPrintLogListTotal(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> printLogList = logDao.getPrintLogList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("totalCount", totalCount);
		map.put("printLogList", printLogList);
		map.put("navi", navi);
		map.put("paramVO", param);
		return map;
	}
}
