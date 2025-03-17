package kr.co.aspn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.ManualDao;
import kr.co.aspn.service.ManualService;
import kr.co.aspn.util.PageNavigator;

@Service
public class ManualServiceImpl implements ManualService {

	@Autowired
	ManualDao manualDao;
	
	@Override
	public Map<String, Object> selectManualList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		int totalCount = manualDao.selectManualCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> manualList = manualDao.selectManualList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", manualList);	
		map.put("navi", navi);
		return map;
	}

}
