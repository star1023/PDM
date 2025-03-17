package kr.co.aspn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.ProxyDao;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.ProxyService;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.util.exception.CommonException;
import kr.co.aspn.vo.MaterialVO;
import kr.co.aspn.vo.ProxyVO;

@Service
public class ProxyServiceImpl implements ProxyService {
	@Autowired 
	ProxyDao proxyDao;
	
	@Autowired
	CommonService commonService;
	
	@Override
	public Map<String, Object> proxyList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		//대결자 리스트 전체 수
		int totalCount = proxyDao.proxyTotalCount(param);
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, totalCount);
		
		List<ProxyVO> proxyList = proxyDao.proxyList(param);
				
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("totalCount", totalCount);
		map.put("proxyList", proxyList);
		map.put("navi", navi);
		return map;
	}

	@Override
	public Map<String, Object> insert(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		int count = proxyDao.proxyDataCount(param);
		if( count > 0 ) {
			map.put("result", "error");
			map.put("message", "동일기간 데이터가 존재합니다.");
		} else {
			proxyDao.insert(param);
			Map<String, Object> notiMap = new HashMap<String, Object>();
			notiMap.put("targetUserId",param.get("targetUserId"));
			notiMap.put("message",param.get("startDate")+" ~ "+param.get("endDate")+"까지  "+param.get("sourceUserName")+"님의 대결자로 지정되었습니다.");
			notiMap.put("regUserId",param.get("regUserId"));
			notiMap.put("isRead","N");
			notiMap.put("typeText","대결자 지정");
			notiMap.put("type","01");
			commonService.insertNotification(notiMap);
			map.put("result", "success");
		}
		return map;
	}

	@Override
	public void delete(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		int result = proxyDao.delete(param);
		if( result < 1 ) {
			throw new CommonException();
		}
	}
	
	

}
